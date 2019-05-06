function realpeaks=findrelpeaks(wav,peakthresh)
% finds peaks size peakthresh (default 1.5) std from the mean
% usage: findrelpeaks(wav [,peakthresh])
if nargin<2, peakthresh=1.5; end

mwav=mean(wav); stwav=std(wav);
overpeaktimes=find((wav>(mwav+peakthresh.*stwav)) | (wav<(mwav-peakthresh.*stwav)));
if ~isempty(overpeaktimes)
  realpeaks=overpeaktimes(1);
  for ct=2:length(overpeaktimes)
    if overpeaktimes(ct)-overpeaktimes(ct-1)>1
      realpeaks=[realpeaks overpeaktimes(ct)];
    end
  end
else
  realpeaks=[];
end
