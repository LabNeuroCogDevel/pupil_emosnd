function[puptrials]=segmenttrials(h,events,data,rescalefactor) 
% segments pupil data into trials based on event codes
% assumes there is just one channel in the data
if nargin < 4, rescalefactor=h.SampInt; end

% assumes data=collected at 4/second and events are 1/second
samprate=h.SampInt./1000000; % sampling rate in ms
incfactor=(1./samprate)./rescalefactor; % rescale skip for resampling
samprate=samprate.*incfactor; % new sampling rate

[timelist,eventlist]=gathereegsysevents(h,events);

numtrials=sum(eventlist==64);
puptrials=zeros(numtrials,round(size(data,1)./numtrials));

time=0;
trial=1;
abscount=0;
prevtime=1;
for index=1:size(eventlist,2),
  if(eventlist(index)==64)
    % fprintf(1,'at end of trial %d\n',trial);
    curtime=round(timelist(index)./samprate);
    puptrials(trial,1:curtime-prevtime+1)=data(prevtime:curtime);
    trial=trial+1; 
    prevtime=curtime;
    end
end


