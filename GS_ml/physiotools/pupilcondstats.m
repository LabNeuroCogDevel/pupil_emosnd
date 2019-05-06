function[stats]=pupilcondstats(p,offset,winstart,winend,rtcode,eotcode,startcode,defaultstimlatency)
% returns structure of relevant statistics for
% EEGSYS pupil data files... 
% Useage: pupiltrialstats(p,offset,winstart,winend,rtcode,eotcode)
%   where offset is the amount of time after a reaction time to wait
%         winstart-winend defines a window of interest in seconds

% to get from seconds to point,
% multiply seconds*SamplesPerSecond=seconds*RescaleFactor
% offset=0; winstart=p.winstart; winend = p.winend; rtcode=34; eotcode=60; startcode=-999; defaultstimlatency=round(median(p.StimLatencies));

baselength=10; % area to average for baseline
if nargin<7 startcode=-999; end;
if nargin<6 eotcode=64; end;
if nargin<5 rtcode=2; end;
if nargin<4 winend=size(p.NormedPupTrials,2)./p.RescaleFactor; end;
if nargin<3 winstart=1./p.RescaleFactor; end;
if nargin<2 offset=0; end;
if nargin<8 defaultstimlatency=baselength+1; end

numtrials=size(p.ConditionMeans,1);

twoseconds=round(2.*p.RescaleFactor);
threeseconds=round(3.*p.RescaleFactor);
% get stats on pupil trials
stats.avgAmplitude=mean(p.ConditionMeans');
[stats.peakAmplitude,stats.peakLatency]=max(p.ConditionMeans');

if isfield(p,'StimLatencies')
  [StimTypes,StimLatencies]=max(p.EventTrials(1:size(p.ConditionMeans,1),:)');
  StimLatencies=mean(StimLatencies,baselength+1);
  StimLatencies=StimLatencies.*(StimLatencies>baselength)+defaultstimlatency.*(StimLatencies<=baselength);
else
  StimLatencies=61.*ones(size(p.ConditionMeans,1));
end

for ct=1:numtrials
  [stats.peakAmplitudePostStim(ct),stats.peakLatencyPostStim(ct)]= ...
      max(p.ConditionMeans(ct,StimLatencies(ct):size(p.ConditionMeans,2))');
  if isfield(p,'RawConditionMeans')
    stats.avgAmplitudeBaseline(ct)=mean(p.RawConditionMeans(ct,(StimLatencies(ct)- baselength): StimLatencies(ct))');  
  end
  stats.avgAmplitudePostStimulus(ct)=mean(p.ConditionMeans(ct,StimLatencies(ct): size(p.ConditionMeans,2))'); 
  if (stats.peakLatency(ct)==size(p.ConditionMeans,2))
    stats.slope2sPostPeak(ct)=0;
    stats.slope3sPostPeak(ct)=0;
  else
    stats.slope2sPostPeak(ct)= slope(p.ConditionMeans(ct,stats.peakLatency(ct): min(size(p.ConditionMeans,2), stats.peakLatency(ct)+twoseconds)));  
    stats.slope3sPostPeak(ct)= slope(p.ConditionMeans(ct,stats.peakLatency(ct): min(size(p.ConditionMeans,2), stats.peakLatency(ct)+threeseconds)));
  end
%  stats.percentBlinks(ct)=length(find(p.BlinkTrials(ct,:)))./length(p.BlinkTrials(ct,:));
%  stats.blinkBaseline(ct)=max(p.BlinkTrials(ct,1:baselength))>0;
end

if isfield(p,'stats')
  stats.percentBlinks=pupilcondmeans(p.stats.percentBlinks',p.TrialTypes');
  if member(0,p.TrialTypes)
    stats.percentBlinks=stats.percentBlinks(2:end);
  end
end


stats.peakPostRt=zeros(1,numtrials);
stats.peakLatencyPostRt=zeros(1,numtrials);

startindex=round((winstart).*p.RescaleFactor);
endindex=round((winend).*p.RescaleFactor);
[stats.peakAmplitudeWindow,stats.peakLatencyWindow]= max(p.ConditionMeans(:,startindex:endindex)'); 
stats.peakLatencyWindow=stats.peakLatencyWindow+startindex-1;
stats.avgAmplitudeWindow=mean(p.ConditionMeans(:,startindex:endindex)'); 


% get trial stats
stats.triallengths=zeros(1,numtrials);
stats.rts=zeros(1,numtrials);


%rescale point indices to seconds
stats.peakLatency=stats.peakLatency./p.RescaleFactor;
stats.peakLatencyPostStim=stats.peakLatencyPostStim./p.RescaleFactor;
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
