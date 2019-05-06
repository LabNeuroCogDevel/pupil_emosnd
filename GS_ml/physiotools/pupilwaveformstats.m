function[trialstats]=pupilwaveformstats(waveforms,events,offset,winstart,winend,rtcode,RescaleFactor)
% returns structure of relevant statistics for
% pupil waveforms
% Useage: pupilwaveformstats(waveforms,events,offset,winstart,
%                            winend,rtcode,RescaleFactor)
%   where offset is the amount of time after a reaction time to wait
%         winstart-winend defines a window of interest


% to get from seconds to point,
% multiply seconds*SamplesPerSecond=seconds*RescaleFactor

if nargin<7 RescaleFactor=62.5; end;
if nargin<6 rtcode=2; end;
if nargin<5 winend=size(waveforms,2)./RescaleFactor; end;
if nargin<4 winstart=1./RescaleFactor; end;
if nargin<3 offset=0; end;

numtrials=size(waveforms,1);
baselength=10; % area to average for baseline

twoseconds=round(2.*RescaleFactor);
threeseconds=round(3.*RescaleFactor);
% get stats on pupil trials
avgAmplitude=mean(waveforms');
[peakAmplitude,peakLatency]=max(waveforms');
[StimTypes,StimLatencies]=max(events(1:size(waveforms,1),:)');

[rtc,rts]=max(events==rtcode);
peakPostRt=zeros(1,numtrials);
peakLatencyPostRt=zeros(1,numtrials);

for i=1:numtrials
  [peakAmplitudePostStim(i),peakLatencyPostStim(i)]= ...
      max(waveforms(i,StimLatencies(i):size(waveforms,2))');
  avgAmplitudeBaseline(i)=mean(waveforms(i,(StimLatencies(i)- ...
					     baselength): ...
					  StimLatencies(i))');  
  avgAmplitudePostStimulus(i)=mean(waveforms(i,StimLatencies(i): ...
				  size(waveforms,2))'); 
  slope2sPostPeak(i)=slope(waveforms(i,peakLatencyPostStim(i): ...
			     min(size(waveforms,2), ...
				 peakLatencyPostStim(i)+twoseconds)));  
  slope3sPostPeak(i)=slope(waveforms(i,peakLatencyPostStim(i): ...
			     min(size(waveforms,2), ...
				 peakLatencyPostStim(i)+threeseconds)));
  avgAmplitudePostRt=mean(waveforms(i,(rts(i)+offset):size(waveforms,2))'); 
  avgAmplitudePostStimulusPreRt(i)= mean(waveforms(i, ...
						  StimLatencies(i):rts(i))');
  [peakPostRt(i),peakLatencyPostRt(i)]= ...
      max(waveforms(i,(rts(i)+offset):size(waveforms,2))); 
end


startindex=round(winstart.*RescaleFactor);
endindex=round(winend.*RescaleFactor);
[peakAmplitudeWindow,peakLatencyWindow]= max(waveforms(:,startindex:endindex)'); 
peakLatencyWindow=peakLatencyWindow+startindex-1;
avgAmplitudeWindow=mean(waveforms(:,startindex:endindex)'); 


%rescale point indices to seconds
peakLatency=peakLatency./RescaleFactor;
peakLatencyPostStim=peakLatencyPostStim./RescaleFactor;
peakLatencyPostRt=peakLatencyPostRt./RescaleFactor;
peakLatencyWindow=peakLatencyWindow./RescaleFactor;

trialstats=struct('Trial',1:size(rts,2),'rts',rts,... 
            'triallengths',triallengths, ...
	    'peakAmplitude',peakAmplitude,'peakLatency', peakLatency,...
	    'peakAmplitudePostStim',peakAmplitudePostStim,'peakLatencyPostStim', peakLatencyPostStim,...
	    'peakPostRt',peakPostRt,'peakLatencyPostRt',peakLatencyPostRt,...  
	    'peakAmplitudeWindow',peakAmplitudeWindow, ...
	    'peakLatencyWindow',peakLatencyWindow, ...
	    'avgAmplitude',avgAmplitude,... 
	    'avgAmplitudeWindow',avgAmplitudeWindow,...
	    'avgAmplitudeBaseline',avgAmplitudeBaseline, ...
	    'avgAmplitudePostStimulus',avgAmplitudePostStimulus,...
	    'avgAmplitudePostStimulusPreRt',avgAmplitudePostStimulusPreRt, ...
	    'avgAmplitudePostRt',avgAmplitudePostRt,...
            'slope2sPostPeak',slope2sPostPeak,'slope3sPostPeak',slope3sPostPeak); 


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
