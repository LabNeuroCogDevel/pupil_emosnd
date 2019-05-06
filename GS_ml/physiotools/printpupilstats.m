function [trialstats]=printpupilstats(s)
 fields=fieldnames(s);
 trialstats=[];
 for i=1:size(fields,1)
%   fprintf(1,'%s ',char(fields(i)));
%   if ~mod(i,7) fprintf(1,'\n'); end;
   trialstats=[trialstats; getfield(s,char(fields(i)))];
 end
trialstats=trialstats';
%fprintf(1,'\n');

% trialstats= [s.Trial;s.rts;s.triallengths; ...
%	    s.peakAmplitude;s.peakLatency;s.peakPostRt;s.peakLatencyPostRt; ...
%	    s.peakAmplitudeWindow;s.peakLatencyWindow;s.avgAmplitude; ...
%	    s.avgAmplitudeWindow;s.avgAmplitudeBaseline; ...
%	    s.avgAmplitudePostStimulus;s.avgAmplitudePostStimulusPreRt; ...
%	    s.avgAmplitudePostRt;s.blinkBaseline;s.percentBlinks]'

