function data=puppreprocess(data,regThreshold,slopeThreshold,extremeThreshold,numSamples,weightingWidth,outofrange,outofwiderange,widerange) 
% useage: data=pupblinkcorrect(data,regThreshold,slopeThreshold,extremeThreshold,numSamples,weightingWidth) 
% smooths and corrects pupil data for blinks. Stores result in the incoming
% data structure, and identifies times at which blinks were removed

% this code would do it Eric's way
%  avgdata=dbfilter(data.RescaleData,5)'; % smooth 
%  avgdata=avgdata(1:numpts);
%  data.NoBlinks=rblinks(avgdata,.3,.2,1.0,10,7)'; % 
%  data.BlinkTimes=avgdata~=data.NoBlinks;
% this code does it my way, with a second pass

if nargin < 9, widerange=200; end
if nargin < 8, outofwiderange=Inf; end
if nargin < 7, outofrange=Inf; end
if nargin < 6, weightingWidth=5; end
if nargin < 5, numSamples=10; end
if nargin < 4, extremeThreshold=1; end
if nargin < 3, slopeThreshold=.2; end
if nargin < 2, regThreshold=.3; end
if nargin < 1, fprintf(-1,'Need at least a data array'); noblinks=-1; return; end


if ~isstruct(data)
  tmp=data; clear data;
  data.RescaleData=tmp;
end

  numpts=length(data.RescaleData);
  if weightingWidth==5
    avgdata=filter3p86hz(data.RescaleData);
  else
    avgdata=dbfilter(data.RescaleData,weightingWidth)'; % smooth 
  end
  avgdata=avgdata(1:numpts);
%  data.JustSmoothed=avgdata;
  data.NoBlinks=rblinks(avgdata,regThreshold,slopeThreshold,extremeThreshold,numSamples,weightingWidth,outofrange)'; 

  % second pass, which I do and Eric doesn't
%SO - do not use std  
%lowestlegal=median(data.NoBlinks)-4.2.*std(data.NoBlinks);
  lowestlegal=median(data.NoBlinks)-5.*iqr(data.NoBlinks);
  needsadjusting=data.NoBlinks<lowestlegal;

  data.BlinkTimes=avgdata~=data.NoBlinks;
  prevblink=[data.BlinkTimes(1:length(data.BlinkTimes)-1); 0];
  nextblink=[0; data.BlinkTimes(1:length(data.BlinkTimes)-1)];
  moreadjust=(~data.BlinkTimes) & (prevblink.*nextblink);

  % DO SOMETHING WITH THE MISMATCH HERE

  data.NoBlinks=data.NoBlinks.*(1-(needsadjusting | moreadjust | data.BlinkTimes));
  data.NoBlinks=[data.NoBlinks(1) rblinks(data.NoBlinks(2:numpts),regThreshold,slopeThreshold,extremeThreshold,numSamples,weightingWidth,outofrange)]';

  % 3rd pass to weed out long blinks
  if outofwiderange<Inf
    data.NoBlinks=rblinks(data.NoBlinks,regThreshold,Inf,outofwiderange,widerange,weightingWidth)'; 
  end
%  if outofrange<Inf
%    data.NoBlinks=rblinks(data.NoBlinks,Inf,Inf,Inf,numSamples,weightingWidth,3.*iqr(data.NoBlinks))'; 
%  end
  

  % store where we found blinks
  data.BlinkTimes=avgdata~=data.NoBlinks;

  % fix blinks at beginning
  if data.BlinkTimes(1)
    goodct=[1:length(data.NoBlinks)]'+10000000.*data.BlinkTimes;
    mingood=min(goodct);
    for ct=1:mingood-1
      data.NoBlinks(ct)=data.NoBlinks(mingood);
    end
  end
  % fix blinks at end
  if data.BlinkTimes(length(data.NoBlinks))
    data.BlinkTimes(length(data.NoBlinks)-10:length(data.NoBlinks))=1;
    goodct=[1:length(data.NoBlinks)]'+-9999999.*data.BlinkTimes;
    maxgood=max(goodct);
    for ct=(maxgood+1):length(data.NoBlinks)
      data.NoBlinks(ct)=data.NoBlinks(maxgood);
    end
  end
    
data.NoBlinksUnsmoothed=(data.RescaleData'.*(data.BlinkTimes==0))+(data.NoBlinks.*(data.BlinkTimes==1));

% doesn't gracefully handle mulimodal blinks (e.g., as in lightreflex\7007016
%  could fix this by saying if there's an interval of less than n points between blinks,
%  include it all as a blink.
