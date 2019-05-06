function p=resppreprocess(p,weightingWidth) 
% useage: p=resppreprocess(p,regThreshold,slopeThreshold,extremeThreshold,numSamples,weightingWidth) 
% smooths and corrects pupil p for blinks. Stores result in the incoming
% p structure, and identifies times at which blinks were removed

if nargin < 2, weightingWidth=10; end
if nargin < 1, fprintf(-1,'Need at least a p array'); noblinks=-1; return; end


numpts=length(p.RescaleData);
%avgdata=runningrms(abs(data.RescaleData),weightingWidth)'; % smooth 
%avgdata=rescaleoutliers(avgdata,2);
%avgdata=eegfilt(data.RescaleData,250,0,3);
%avgdata=avgdata(1:numpts);
%p.Filtered=bandpass(p.RescaleData',.2,4,1./p.RescaleFactor);
p.Filtered=bandpass(p.RescaleData',.05,1,1./p.RescaleFactor);
%p.Filtered=p.RescaleData';
p.RespAbs=abs(detrend(p.Filtered));


% for respiration - run a peak identifier and get
%   rate = # peaks/time (convert to breaths/min)
%   amplitude = trough to peak amplitude for successive periods
p.resppeak=zeros(size(p.Filtered));
resppeakrange=p.Filtered.*(p.Filtered>(mean(p.Filtered)+.25.*std(p.Filtered)));
startbeat=0;
for ct=1:length(p.Filtered)
  if ((startbeat==0) & (resppeakrange(ct)>0)) startbeat=ct; end
  if (startbeat & (resppeakrange(ct)==0))
    [bamp,btime]=max(resppeakrange(startbeat:ct));
    p.resppeak(startbeat+btime-1)=1;
    startbeat=0;
  end
end
p.resppeak=p.resppeak.*p.Filtered;
[bog,p.resppeakind,p.resppeakamps]=find(p.resppeak);
p.resppeaktimes=p.resppeakind./p.RescaleFactor;
p.iris=[p.resppeaktimes(2:end)-p.resppeaktimes(1:end-1)];

p.resptrough=zeros(size(p.Filtered));
resptroughrange=p.Filtered.*(p.Filtered<(mean(p.Filtered)-.25.*std(p.Filtered)));
startbeat=0;
for ct=1:length(p.Filtered)
  if ((startbeat==0) & (resptroughrange(ct)<0)) startbeat=ct; end
  if (startbeat & (resptroughrange(ct)==0))
    [bamp,btime]=min(resptroughrange(startbeat:ct));
    p.resptrough(startbeat+btime-1)=1;
    startbeat=0;
  end
end
p.resptrough=p.resptrough.*p.Filtered;
[p.resptroughtimes,bog,p.resptroughamps]=find(p.resptrough);
p.resptroughtimes=p.resptroughtimes./p.RescaleFactor;


%%%% get local resprate
p.curresp=zeros(size(p.resppeak));
p.curresp(1:p.resppeakind(1))=(1./p.iris(1)).*60;
for cur=1:length(p.resppeakind)-1
  p.curresp(p.resppeakind(cur):p.resppeakind(cur+1))=(1./(p.resppeaktimes(cur+1)-p.resppeaktimes(cur))).*60;
end
p.curresp(p.resppeakind(end):end)=(1./p.iris(end)).*60;
p.curresp=rescaleoutliers(p.curresp')';

%%%% get resp phase
p.respphase=zeros(size(p.resppeak));
for cur=1:length(p.resppeakind)-1
   p.respphase(p.resppeakind(cur):p.resppeakind(cur+1))=2.*pi.*((p.resppeakind(cur):p.resppeakind(cur+1))-p.resppeakind(cur))./(p.resppeakind(cur+1)-p.resppeakind(cur));
end

