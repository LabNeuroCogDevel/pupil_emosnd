function xcs=gsxcorr(wav1,wav2,numlags,covars)
% intuitive cross correlation measure we can easily understand
% as opposed to xcov..
% usage: gsxcorr(wav1,wav2,numlags,covars)
% covars=1 ==> covary out lag 0
% covars=2 ==> covary out autocorrelation of predictor (for Granger causality)

if nargin<3, numlags=10; end
if nargin<4, covars=0; end


if covars==1, covlag0=1; 
else covlag0=0; 
end

if covars==2, covauto=1; 
else covauto=0;
end

xcs=zeros(1,2.*numlags+1);
xcs(numlags+1)=r(wav1,wav2); % lag zero



for ct=1:numlags
  if covlag0
    % positive lags - r_x(t+1),y(t).x(t)
    mr=mhreg(wav1(1:end-ct),wav1((1+ct):end),wav2(1:end-ct));
    xcs(numlags+1+ct)=sqrt(mr.dr.Rsq);
    % negative lags - r_x(t),y(t+1).x(t+1)
    mr=mhreg(wav1((1+ct):end),wav1(1:end-ct),wav2((1+ct):end));
    xcs(numlags+1-ct)=sqrt(mr.dr.Rsq);
  elseif covauto
    % positive lags - r_x(t+1),y(t).x(t)
    mr=mhreg(wav1(1:end-ct),wav1((1+ct):end),wav2(1:end-ct));
    xcs(numlags+1+ct)=sqrt(mr.dr.Rsq);
    % negative lags - r_x(t),y(t+1).y(t)
    mr=mhreg(wav2(1:end-ct),wav1(1:end-ct),wav2((1+ct):end));
    xcs(numlags+1-ct)=sqrt(mr.dr.Rsq);
  else
    % positive lags are when wav2 predicts wav1 offset by some
    % e,g., when the amplitude of wav2 at t1 predicts the amplitude of wav1 at t2
    % i.e., r_x(t+1),y(t)
    xcs(numlags+1+ct)=r(wav1((1+ct):end),wav2(1:end-ct));
    % negative lags are when wav1 predicts wav2 offset by some
    % i.e., r_x(t),y(t+1)
    xcs(numlags+1-ct)=r(wav1(1:end-ct),wav2((1+ct):end));
  end
end
