function[noblinks]=rblinks(data,regThreshold,slopeThreshold,extremeThreshold,numSamples,weightingWidth,outofrange) 
% removes blinks in a 1d array of pupil data
% Useage: rblinks(data,regressionThreshold,slopeThreshold,
%   extremeThreshold,#samplesAtATime,WeightingWidth)
% Where Weighting width is one of 0/3/5/7/15/31 only

if nargin < 7, outofrange=Inf; end
if nargin < 6, weightingWidth=5; end
% not used
if nargin < 5, numSamples=10; end
if nargin < 4, extremeThreshold=1; end
% extremeThreshold max=5 (higher gives error)
% extremeThreshold: higher number=more liberal threshold
if nargin < 3, slopeThreshold=.2; end
% slopeThreshold: higher number=more liberal threshold
if nargin < 2, regThreshold=.3; end
if nargin < 1, fprintf(-1,'Need at least a data array'); noblinks=-1; return; end

if size(data,2)==1
  data=data';
end


noblinks=zeros(1,size(data,2));
storage=zeros(1,size(data,2));
buffer=zeros(1,numSamples);
noblinkindex=1;

% first use the weightingWidth to run a moving average of the
% data
%avgdata=movingaverage(data,weightingWidth);

% establish sequential array for use in regression slope determination
inc=1:numSamples;

EndBlink=1;
StartBlink=0;

datamd=median(data); lbd=datamd-outofrange; ubd=datamd+outofrange;

allReliable=[];

for count=1:numSamples:size(data,2)-numSamples
   SumXY=0;
   SumX=0;
   SumY=data(count);
   SumX2=0;
   
   % was a loop for 1:numSamples
   buffer(1:numSamples)=data(count:count+numSamples-1);
   SumXY=dot(buffer,inc);
   SumX=sum(inc);
   SumY=sum(buffer);
   SumX2=sum(inc.^2);

   Sum2X=SumX.^2;
   
   % calculate regression line
   Slope=(SumXY-SumX.*SumY./numSamples)./(SumX2-Sum2X./numSamples);
   high=max(buffer); low=min(buffer);
   if ((low<=0) | (low<lbd) | (high>ubd)) Reliable=0; 
   else 
     if (abs(Slope)>slopeThreshold)
       if (abs(high-low)>extremeThreshold)
	 Reliable=0;
       else Reliable=1;
       end
     else
       Reliable=1;
       Intercept=(SumY-Slope*SumX)/numSamples;
     end
   end
   
   allReliable(count)=Reliable;
   % get regression threshold
   % sufficiently far deviations are blinks
   if Reliable
     regThreshBuffer=abs(Slope.*inc+Intercept-buffer); % my abs - GJS
     if max(regThreshBuffer>regThreshold) Reliable=0;
     end
   end
   if (not(Reliable))
     storage(EndBlink:EndBlink+numSamples-1)=buffer;
     EndBlink=EndBlink+numSamples;
   else
     if (EndBlink>1)
       SlopePup=(buffer(1)-StartBlink)./EndBlink;
       IntPup=StartBlink;
       storage(1:EndBlink)=SlopePup.*(1:EndBlink)+IntPup;
       if (noblinkindex+EndBlink)> size(data,2)
	 EndBlink=EndBlink-(size(data,2)-noblinkindex)
       end
%      fprintf(1,'%d vs %d w/ %d\n', size(noblinkindex: ...
%GJS					  noblinkindex+EndBlink-1), ...
%	                                 size(storage(1:EndBlink)), EndBlink);
       noblinks(noblinkindex:noblinkindex+EndBlink-1)=storage(1:EndBlink);
       noblinkindex=noblinkindex+EndBlink-1;
       EndBlink=1;
     end
     StartBlink=buffer(numSamples);
     noblinks(noblinkindex:noblinkindex+numSamples-1)=buffer;
     noblinkindex=noblinkindex+numSamples;
   end
end
if EndBlink
  noblinks(noblinkindex:noblinkindex+EndBlink-1)=storage(1:EndBlink);
end

%noblinks=noblinks(1:(size(noblinks,2)-numSamples)); % this may remove some good data?
noblinks((size(noblinks,2)-numSamples):size(noblinks,2))= data((size(noblinks,2)-numSamples):size(noblinks,2));
% find last non-zero index and carry that out.
index=size(noblinks,2);
while(noblinks(index)==0)
  index=index-1;
end
noblinks(index:size(noblinks,2))=noblinks(index-1);

figure
plot(data);
hold on
plot(allReliable*50)
plot(noblinks)
return

% known bugs
%   allows interpolation between trials - shouldn't
%    w/ blink @ beginning or end either take last good data point
%    and continue it, or define a point with a cursor
%   w/ 1 deviant point just correct that.
