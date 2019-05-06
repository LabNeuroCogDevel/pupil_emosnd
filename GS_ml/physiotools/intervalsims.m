function pfrac=intervalsims(Ng1,Ng2,T,S,sig,ro,numsims,intlock)
% finds the likelihood that there is even one simulation significant
% in means of successive points S long.
% We want pfrac to be <.05 which would mean that in less than
% five percent of cases would there be an interval S samples long
% in which the observed data occurred
%
% N is the # subjects per group
% T is the length of the sampling interval
% S is the interval length
% sig is the significance for each test
% ro is the autocorrelation in the data
% numsims is the number of simulations to do
% intlock - significant intervals can only occur every intlock samples
% p is the likelihood that an interval S long will be observed by chance

% e.g.,  Ng1=24; Ng2=16; T=2050; S=250; sig=.05; ro=.9903; numsims=1000; intlock=250;
for sim=1:numsims
  wav1=zeros(Ng1,T);   wav2=zeros(Ng2,T);
  for ct=1:Ng1
    wav1(ct,:)=gsrandauto2(T,ro)';
  end
  for ct=1:Ng2
    wav2(ct,:)=gsrandauto2(T,ro)';
  end
  wav1=wav1-repmat(wav1(:,1),1,T);
  wav2=wav2-repmat(wav2(:,1),1,T);
  wav1=wav1(:,2:end);
  wav2=wav2(:,2:end);
  
  Mg1=mean(wav1); Mg2=mean(wav2);
  sp=sqrt(((Ng1-1).*var(wav1)+(Ng2-1).*var(wav2))./(Ng1+Ng2-2));
  d=(Mg1-Mg2)./sp;  
  
  % now do the requisite tests
  tsnum=1;
  for tst=1:intlock:(length(d)-S)
    tstats(tsnum)=mean(d(tst:tst+S)).*(1./sqrt((1./Ng1)+(1./Ng2)));
    tsnum=tsnum+1;
  end
  df=Ng1+Ng2-2;
  p=2.*(1-tcdf(abs(tstats),df)); % p values for each row - 2 tailed
  haslowp(sim)=(min(p)<sig);
  if mod(sim,100)==0, fprintf('.'); end
end
fprintf('\n');
pfrac=sum(haslowp)./numsims;
