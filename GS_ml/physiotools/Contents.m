% Tools for analysis of pupil data
%  (c) Greg Siegle, University of Pittsburgh
%
% Pupil data analysis requires a number of steps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reading the data (specific to the data collection medium)
%      must return a structure with the following slots:
%           RawPupil: - the raw, unadulterated
%                        pupil data sampled at 250 Hz
%           RescaleData: - rescaled to 62.5 Hz
%           AllSeconds: - units to put NoBlinks in
%                         seconds
%           EventTimes: - times at which events occured
%           EventCodes: - all event codes
%           EventTrain: - event codes on same time scale
%                         as noblinks
%           RescaleFactor: - number of samples per second
%      e.g., data=readmicromeas('c:/greg/tmp/ericpup/PATFIX1.TXT'); 
%            data=readeegsyspupil('fname');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preprocessing the data
%       data=puppreprocess(data,.3,.2,1.0,10,7);
%         adds
%           NoBlinks: - denoised and deblink'd
%           BlinkTimes - times at which blinks were removed
%       data=pupilextrafancy(data)
%         adds:
%           SmoothWavelet: - results of wavelet transform
%           FastWavelet:
%           Frequencies: - results of fourier transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% identify trial boundaries (specific to the experiment)
%        must add data.TrialMarkers which is a 1# per row list of ticks at which trials begin
%                 EventCodes & EventTimes
%        e.g., data=makerorshachtrials(data); % specific for rorshach experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% segment the data into trials 
%     via segmentpupiltrials
%       adds
%         EventTrials: - events on same time scale as trials
%         PupilTrials: - NoBlink'd data segmented into trials
%         NormedPupTrials: - Trials equated for baselines
%         TrialSeconds: - units to put trials in seconds
%     e.g., data=segmentpupiltrials(data,0,10,1800); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getting condition information
% pupilcondmeans
%   note: this can take a bad trial list (loaded from whereever)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graphing
%  plotmanipulator(data,xaxis); e.g., plotmanipulator([p.RescaleData; p.NoBlinks']')
%  showpupiltrials(data); % shows each trial separately
%  figure; plot(data.TrialSeconds,mean(data.NormedPupTrials));  % all trials superimposed
%  figure; plotpupiltrialmatrix(data);  % matrix graph
%  threedpupilgraph(data); % 3d graph
%  plotpupilcondmeans(p);
%  graphtrial(p,1); % graphs a particular trial
%  pupilautocorrgraph(p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% statistics
%  data.stats=pupiltrialstats(data);
%  pupiltrialstats(data,[event code for rt, stimulus-onset-time, offset,
%       start of window, end of window])
%       - returns relevant statistics on pupil trials
%      The following statistics are calculated from pupil waveforms:
%      peak amplitude, peak latency, amplitude of peak after
%      reaction-time plus offset, amplitude of peak after
%      late-threshold, average pupil area, average area pre-stimulus
%      (baseline), average area post-stimulus,
%      average area post-stimulus but pre-reaction-time, average area
%      post reaction-time plus offset, average area pre-peak, average
%      area post-peak, average area post-stimulus but
%      pre-early-threshold, average area post-late-threshold, whether a
%      blink occurs during the baseline, whether a blink occurs during
%      the peak, percent of trial with blinks, dilation at
%      reaction-time, slope pre-user-defined-time-threshold, slope
%      post-user-defined-time-threshold, slope pre-reaction-time, slope
%      post-reaction-time plus user-defined-time-threshold, slope
%      post-peak
%        Window functions: average diameter, peak, latency to peak, slope


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Conventionally I name routines to do all of these "xproc" 
%   e.g., "procvid" or "procrorshach"
% also, by convention, these functions take a filename for 
% bad trials

% ================================================
% For example:

% reading the data
%  data=readmicromeas('c:/greg/tmp/ericpup/PATFIX1.TXT'); % generic for all micromeasurements files
%  data=makerorshachtrials(data); % specific for rorshach experiment
%  data=segmentpupiltrials(data,0,10,1800);

% graphing
%  showpupiltrials(data) - graphs overlay of each trial, normed to baseline
%    in a separate subplot with events overlayed
%  figure; plot(data.TrialSeconds,mean(data.NormedPupTrials));  % all trials superimposed
%  figure; plotpupiltrialmatrix(data);  % matrix graph
%  threedpupilgraph(data); % 3d graph
%  graphtrial(data,trial#) - graphs any trial in its own window
%  3dpupilgraph(data) - graphs NoBlinks in a funky 3d way
%  scrollplot(dataset) - plots any dataset in a window, e.g.,
%     scrollplot(data.NormedPupTrials) - plots all trials
%     scrollplot(data.Frequencies) - plots fourier transform graph

% statistics
%  data.stats=pupiltrialstats(data);
%  data.stats=pupiltrialstats(data,0,.0167,20,999,0) % rt's are not stored...

% ================================================

% unique to rq
%   rqwritesx - makes a text file w/ relevant data
%   rqreadsx - reads a text file
%   rqplottrialmatrix(p) - Sejnowski style plots
%   rqplotaggpupilcondmeans(p)
%   rqaggall - responses to each valence
%   rqcalcallsprstats - within subject regressions
%   rqmakedatfromsx
%   rqpreparepupil
%   rqproc
 
