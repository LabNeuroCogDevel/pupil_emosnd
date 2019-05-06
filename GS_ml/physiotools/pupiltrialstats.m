function[stats]=pupiltrialstats(p,offset,winstart,winend,rtcode,eotcode,startcode,defaultstimlatency,maxgoodevent,dodetrend,overriderts)
% returns structure of relevant statistics for
% EEGSYS pupil data files... 
% Useage: pupiltrialstats(p,offset,winstart,winend,rtcode,eotcode)
%   where offset is the amount of time after a reaction time to wait
%         winstart-winend defines a window of interest in seconds

% to get from seconds to point,
% multiply seconds*SamplesPerSecond=seconds*RescaleFactor

baselength=10; % area to average for baseline

if nargin<11, overriderts=0; end
if nargin<10 dodetrend=0; end
if dodetrend, datatouse=p.NormedDetrendPupTrials; 
else datatouse=p.NormedPupTrials;
end
if nargin<2 offset=0; end;
if nargin<3 winstart=1./p.RescaleFactor; end;
if nargin<4 winend=size(datatouse,2)./p.RescaleFactor; end;
if nargin<5 rtcode=2; end;
if nargin<6 eotcode=64; end;
if nargin<7 startcode=-999; end;
if nargin<8 defaultstimlatency=baselength+1; end
if nargin<9 maxgoodevent=200; end

% offset=0; winstart=1; winend=9; rtcode=2; eotcode=64; startcode=-999; defaultstimlatency=11+1; maxgoodevent=200;
% offset=0; winstart=p.winstart; winend=p.winend; eotcode=64; startcode=-999; defaultstimlatency=127; maxgoodevent=48; dodetrend=0;


numtrials=size(datatouse,1);

twoseconds=round(2.*p.RescaleFactor);
threeseconds=round(3.*p.RescaleFactor);
% get stats on pupil trials
stats.avgAmplitude=mean(datatouse');
[stats.peakAmplitude,stats.peakLatency]=max(datatouse');
allevents=p.EventTrials(1:size(datatouse,1),:)';
if isfield(p,'StimLatencies')
  StimTypes=p.StimTypes;
  StimLatencies=p.StimLatencies;
else
   [StimTypes,StimLatencies]=max(allevents.*(allevents<maxgoodevent));
   StimLatencies=StimLatencies.*(StimLatencies>baselength)+ defaultstimlatency.*(StimLatencies<=baselength);
end
if (min(StimLatencies)<1) | (max(StimLatencies)>size(datatouse,2))
  fprintf('Found StimLatency out of range... Correcting but should not have to\n'); 
  for ct=1:length(StimLatencies)
    StimLatencies(ct)=max(1,min(StimLatencies(ct),size(datatouse,2)));
  end
end

for ct=1:numtrials
  [stats.peakAmplitudePostStim(ct),stats.peakLatencyPostStim(ct)]= ...
      max(datatouse(ct,StimLatencies(ct):size(datatouse,2))');
  stats.avgAmplitudeBaseline(ct)=mean(p.PupilTrials(ct,max(1,(StimLatencies(ct)- baselength)): max(4,StimLatencies(ct)))');  
  stats.avgAmplitudePostStimulus(ct)=mean(datatouse(ct,StimLatencies(ct): size(datatouse,2))'); 
  if stats.peakLatency(ct)<size(datatouse,2)
    stats.slope2sPostPeak(ct)= ...
	slope(datatouse(ct,stats.peakLatency(ct): min(size(datatouse,2), stats.peakLatency(ct)+twoseconds)));  
    stats.slope3sPostPeak(ct)= ...
	slope(datatouse(ct,stats.peakLatency(ct): min(size(datatouse,2), ...
						  stats.peakLatency(ct)+threeseconds)));
  else
    stats.slope2sPostPeak(ct)=0; stats.slope3sPostPeak(ct)=0;
  end  
  stats.percentBlinks(ct)=length(find(p.BlinkTrials(ct,:)))./length(p.BlinkTrials(ct,:));
  stats.blinkBaseline(ct)=max(p.BlinkTrials(ct,1:baselength))>0;
  rttick=min(find(p.EventTrials(ct,:)==rtcode));
  if (overriderts & (p.rts(ct)>0)) rttick=round(p.rts(ct).*p.RescaleFactor); end
  trial=ct;
  if isempty(rttick)
    fprintf('no rt for trial %d\n',trial);
  else
    if rttick==0, rttick=1; end
    stats.rttick(trial)=rttick;
    stats.rts(trial)=(rttick-StimLatencies(trial))./p.RescaleFactor;
    [stats.peakPostRt(trial),stats.peakLatencyPostRt(trial)]= max(datatouse(min(size(datatouse,1),trial),min(end,max(1,rttick)):end));
    stats.peakLatencyPostRt(trial)=stats.peakLatencyPostRt(trial)+ rttick-1;
    stats.avgAmplitudePostStimulusPreRt(trial)= mean(datatouse(trial,StimLatencies(trial):min(rttick,size(datatouse,2))))';
    stats.avgAmplitudePostRt(trial)=mean(datatouse(trial,min(rttick,size(datatouse,2)):end)); 
    if isfield(p,'TrialLengths')
      stats.triallengths=p.TrialLengths;
    end
  end
end

startindex=round(winstart.*p.RescaleFactor);
endindex=round(winend.*p.RescaleFactor);
endindex=min(endindex,size(datatouse,2));

if length(startindex)>1
  for ct=1:length(startindex) %added loop
    [stats.peakAmplitudeWindow(ct),stats.peakLatencyWindow(ct)]= max(datatouse(:,startindex(ct):endindex(ct))'); 
    stats.peakLatencyWindow(ct)=stats.peakLatencyWindow(ct)+startindex(ct)-1;
    stats.avgAmplitudeWindow(ct)=mean(datatouse(:,startindex(ct):endindex(ct))'); 
  end
else
    [stats.peakAmplitudeWindow,stats.peakLatencyWindow]= max(datatouse(:,startindex:endindex)'); 
    stats.peakLatencyWindow=stats.peakLatencyWindow+startindex-1;
    stats.avgAmplitudeWindow=mean(datatouse(:,startindex:endindex)'); 
end



% get trial stats
%stats.peakPostRt=zeros(1,numtrials);
%stats.peakLatencyPostRt=zeros(1,numtrials);
%stats.triallengths=zeros(1,numtrials);
%stats.rts=zeros(1,numtrials);
% trial=1;
% trialstart=p.EventTimes(1);
% trialstartindex=1;
% startindex=0;
% for index=1:size(p.EventCodes,2),
%   switch p.EventCodes(index),
%    case {eotcode,255},
%     if trial<=numtrials 
%       stats.triallengths(trial)=p.EventTimes(index)-trialstart; 
%     end
%     trial=trial+1; 
%     trialstart=p.EventTimes(index);
%     trialstartindex=round(trialstart.*p.RescaleFactor);
%    case startcode
%     trialstart=p.EventTimes(index);
%     trialstartindex=round(trialstart.*p.RescaleFactor);       
%    case rtcode,
%     if trial<=numtrials         
%       stats.rts(trial)=p.EventTimes(index)-lasttime; 
%       absrt=p.EventTimes(index)-trialstart;
%       trialrtindex=max(1,round((absrt+offset).*p.RescaleFactor));
%       %fprintf(1,'rt=%.3f, trial=%d; index=%d; trialrtindex=%d;\n',stats.rts(trial),trial,index,trialrtindex);
%       [stats.peakPostRt(trial),stats.peakLatencyPostRt(trial)]= ...
% 	     max(datatouse(trial,trialrtindex:size(datatouse,2))); 
%       stats.peakLatencyPostRt(trial)=stats.peakLatencyPostRt(trial)+ trialrtindex-1;
%       stats.avgAmplitudePostStimulusPreRt(trial)= ...
% 	     mean(datatouse(trial,StimLatencies(trial):round(absrt.*p.RescaleFactor))');
%       stats.avgAmplitudePostRt(trial)=mean(datatouse(trial,trialrtindex:size(datatouse,2))); 
%     end;
%   end
%   lasttime=p.EventTimes(index);
% end
% if stats.triallengths(numtrials)==0
%   stats.triallengths(numtrials)=p.EventTimes(index)-trialstart
% end

%rescale point indices to seconds
stats.peakLatency=stats.peakLatency./p.RescaleFactor;
stats.peakLatencyPostStim=stats.peakLatencyPostStim./p.RescaleFactor;
stats.peakLatencyPostRt=stats.peakLatencyPostRt./p.RescaleFactor;
stats.peakLatencyWindow=stats.peakLatencyWindow./p.RescaleFactor;


stats.Trial=1:size(stats.rts,2);


%   pupilstats(data,[optional: event code for rt, stimulus-onset-time,offset,
%       start of window, end of window])
%       - returns relevant statistics on pupil trials
%      The following statistics are calculated from pupil
%      waveforms:
%      peak amplitude, peak latency, amplitude of peak after
%      reaction-time plus offset, latency of peak after rt+offset,
%      amplitude of peak in window, latency of peak in window,
%      average pupil area, average pupil area in window, 
%      average area pre-stimulus (baseline), average area post-stimulus,
%      average area post-stimulus but pre-reaction-time, average area
%      post reaction-time plus offset, whether a
%      blink occurs during the baseline, whether a blink occurs during
%      the peak, percent of trial with blinks, dilation at
%      reaction-time, slope pre-user-defined-time-threshold, slope
%      post-user-defined-time-threshold, slope pre-reaction-time, slope
%      post-reaction-time plus user-defined-time-threshold, slope
%      post-peak
%        Window functions: average diameter, peak, latency to peak, slope
%         within window
