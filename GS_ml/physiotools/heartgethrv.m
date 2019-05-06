function p=heartgethrv(p,graphics,samprate)
% gets hrv from heart tachygram
% assumes it's been acquired with heartpreprocess.
% Do wavelet transform of the whole dataset
% assumes the sampling rate is 100

if nargin<2, graphics=0; end
if nargin<3, samprate=100; end

% might want p.curhrsmooth instead
if graphics, figure(1); clf; end
%ps=waveplot(p.curhrsmooth,100,65,graphics);
[ps,yax]=waveplot(p.curhrsmooth,samprate,85,graphics);

% hfhrv=RSA=parasymp=.18-.4Hz
p.hfhrv=mean(ps(16:27,:),1)./10000;
% lfhrv=symp+parasymp=.04-.15Hz
p.lfhrv=mean(ps(31:43,:),1)./10000;


if graphics
  figure(2);
  plot(p.hfhrv);
  hold on; 
  plot(p.lfhrv,'r');
  legend('hfhrv (.18-.4 Hz)','lfhrv (.04-.15 Hz)');
  
end

%p.wavelet=ps;
