function data=emgpreprocess(data,weightingWidth) 
% useage: data=pupblinkcorrect(data,regThreshold,slopeThreshold,extremeThreshold,numSamples,weightingWidth) 
% smooths and corrects pupil data for blinks. Stores result in the incoming
% data structure, and identifies times at which blinks were removed

if nargin < 2, weightingWidth=10; end
if nargin < 1, fprintf(-1,'Need at least a data array'); noblinks=-1; return; end


numpts=length(data.RescaleData);
avgdata=runningrms(abs(data.RescaleData),weightingWidth)'; % smooth 
avgdata=rescaleoutliers(avgdata,2);
%avgdata=eegfilt(data.RescaleData,250,0,3);
avgdata=avgdata(1:numpts);
data.NoBlinks=avgdata;
