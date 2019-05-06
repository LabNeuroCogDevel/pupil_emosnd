function p=heartgetcoherence(p,graphics)
% gets coherence from heart tachygram
% assumes it's been acquired with heartpreprocess.
% Do wavelet transform of the whole dataset
% Take 1/(sum of high freq components) for whole dataset.

if nargin<2, graphics=0; end

% might want p.curhrsmooth instead
if graphics, figure(1); clf; end
%ps=waveplot(p.curhrsmooth,100,65,graphics);
ps=waveplot(p.curhrsmooth,100,85,graphics);

[maxval,maxind]=max(mean(ps,2));
p.coherence=ps(maxind,:);

if graphics
  figure(2);
  plot(p.coherence./600);
  hold on; plot(p.curhrsmooth-50,'r');
  legend('maxfreq power / 600','hr-50');
end

%p.wavelet=ps;
