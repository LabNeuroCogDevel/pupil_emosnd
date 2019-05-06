function data = stublinks(data,graphics,lrtask,manualblinks)

% Stuart Steinhauer's blink algorithm that correctly misses 
% light reflex onsets.
% last modified by Greg Siegle - 3/3/04
% usage: data = stublinks(data,graphics,lrtask)
% note: if lrtask=0 it expects a task with relatively
%         slow responses (i.e., no light reflex) and is thus
%         more conservative.
%   if lrtask =1, it expects a task with relatively
%         quick light-reflex responses
% note: can add manual blinks e.g.,
% p=stublinks(p,1,0,[1000:2000 3000:3200]);


if nargin<2, graphics=0; end
if nargin<3, lrtask=0; end
if nargin<4, manualblinks=[]; end

if ~isstruct(data)
  tmp=data; clear data;
  data.RescaleData=tmp;
end

numpts=length(data.RescaleData);
%avgdata=dbfilter(data.RescaleData,3); % smooth 
%avgdata=dbfilter(avgdata,3)'; % smooth 

avgdata=conv([1 1 1]./3,data.RescaleData);
avgdata=avgdata(2:numpts+1);
avgdata=conv([1 1 1]./3,data.RescaleData);
avgdata=avgdata(2:numpts+1);
avgdata(1:10)=data.RescaleData(1:10);
avgdata((end-10):end)=data.RescaleData(end-10:end);
avgdata(end:length(data.RescaleData))=avgdata(end);


data.BlinkTimes=zeros(size(data.RescaleData'));

if lrtask
  data.BlinkTimes=data.BlinkTimes | (abs([(data.RescaleData(2:end)) (data.RescaleData(end))] - data.RescaleData) > .4)';
  data.BlinkTimes=(data.BlinkTimes | (data.RescaleData'<.2));  
else
  % mark any change greater than .5 mm in 1 sample
  data.BlinkTimes=data.BlinkTimes | (abs([(data.RescaleData(2:end)) (data.RescaleData(end))] - data.RescaleData) > .5)';
  
  % mark any change where the data is very different from the smoothed version of the data
  % and where the smoothing does not average in a blink
  smoothblinks=conv(ones(1,30)./30,data.BlinkTimes);
  smoothblinks=smoothblinks((length(smoothblinks)-length(data.BlinkTimes)+1):end);
  smoothblinks(1:100)=data.BlinkTimes(1:100);
  smoothblinks(end-100:end)=data.BlinkTimes(end-100:end);
  smoothdata=conv(ones(1,30)./30,data.RescaleData);
  smoothdata=smoothdata((length(smoothdata)-length(data.RescaleData)+1):end);
  smoothdata(1:100)=data.RescaleData(1:100);
  smoothdata(end-100:end)=data.RescaleData(end-100:end);
  data.BlinkTimes=data.BlinkTimes | ((abs(smoothdata-data.RescaleData)>1)' & (smoothblinks==0));
  
  data.BlinkTimes=(data.BlinkTimes | (data.RescaleData'<.1));
  if (max(data.BlinkTimes)>0)
    data.BlinkTimes=(data.BlinkTimes | (data.RescaleData'<(min(data.RescaleData)+.1)));
  end
  
  % mark changes in the derivative greater than expected
  diffs=[0 data.RescaleData(2:end)-data.RescaleData(1:end-1)]';
  %data.BlinkTimes=(data.BlinkTimes | (diffs>[(prctile(diffs,75)+3.*iqr(diffs))]));
  
  % mark changes outside the IQR
  data.BlinkTimes=(data.BlinkTimes | (abs(data.RescaleData'-median(data.RescaleData))>4));
  data.BlinkTimes=(data.BlinkTimes | (data.RescaleData'<(prctile(data.RescaleData,25)-1.5.*iqr(data.RescaleData)))); % was 2
  data.BlinkTimes=(data.BlinkTimes | (data.RescaleData'>(prctile(data.RescaleData,75)+2.0.*iqr(data.RescaleData)))); % was 2
  
  % 200 was good
  
  % kill >3mm change in 500 points
  smoothdata=conv(ones(1,500)./500,data.RescaleData);
  smoothdata=smoothdata((length(smoothdata)-length(data.RescaleData)+1):end);
  smoothdata(1:500)=data.RescaleData(1:500);
  smoothdata(end-500:end)=data.RescaleData(end-500:end);
  smoothblinks=conv(ones(1,500)./500,data.BlinkTimes);
  smoothblinks=smoothblinks((length(smoothblinks)-length(data.BlinkTimes)+1):end);
  smoothblinks(1:500)=data.BlinkTimes(1:500);
  smoothblinks(end-500:end)=data.BlinkTimes(end-500:end);
  % was >3
  data.BlinkTimes=data.BlinkTimes | ((abs(smoothdata-data.RescaleData)>1.5)' & (smoothblinks==0));
  
%  for ct=500:length(data.RescaleData)
%    if abs(data.RescaleData(ct)-md(data.RescaleData(ct-499:ct)',data.BlinkTimes(ct-499:ct)))>3, data.BlinkTimes(ct)=1; end
%  end
  
  % mark .3 changes in 4 points - made .4 12/22/04
%  smoothdata=conv(ones(1,4)./4,data.RescaleData);
%  smoothdata=smoothdata((length(smoothdata)-length(data.RescaleData)+1):end);
%  smoothdata(1:4)=data.RescaleData(1:4);
%  smoothdata(end-4:end)=data.RescaleData(end-4:end);
%  smoothblinks=conv(ones(1,4)./4,data.BlinkTimes);
%  smoothblinks=smoothblinks((length(smoothblinks)-length(data.BlinkTimes)+1):end);
%  smoothblinks(1:4)=data.BlinkTimes(1:4);
%  smoothblinks(end-4:end)=data.BlinkTimes(end-4:end);
%  data.BlinkTimes=data.BlinkTimes | ((abs(smoothdata-data.RescaleData)>.4)' & (smoothblinks==0));

  newblinks=data.BlinkTimes;
  for ct=1:(length(data.RescaleData)-5)
    if ((~data.BlinkTimes(ct)) & ~data.BlinkTimes(ct+4) & (abs(data.RescaleData(ct+4)-data.RescaleData(ct))>.4)), newblinks(ct:ct+4) = 1; end
  end
  data.BlinkTimes=newblinks;
  
  % fill in the gaps between close blinks
  for ct=1:length(data.RescaleData)-10
    if (data.BlinkTimes(ct)==1) & (data.BlinkTimes(ct+10)==1) data.BlinkTimes(ct:ct+10)=1; end
    if (data.BlinkTimes(ct)==1) & (data.BlinkTimes(ct+4)==1) data.BlinkTimes(ct:ct+4)=1;   end
  end
  
  
end


if nargin>3, data.BlinkTimes(manualblinks)=1; end
data.NoBlinks=avgdata;
data.NoBlinksUnsmoothed=data.RescaleData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now interpolate
% creates noblinks
blinkends=find((data.BlinkTimes(1:end-1)==1) & (data.BlinkTimes(2:end)==0));
blinkstarts  =find((data.BlinkTimes(2:end)==1) & (data.BlinkTimes(1:end-1)==0));
if data.BlinkTimes(1)==1
  blinkstarts=[1; blinkstarts];
end

if length(blinkends)>length(blinkstarts)
 blinkends=blinkends(2:end);
end

if length(blinkends)<length(blinkstarts)
  %blinkends(length(blinkends):length(blinkstarts))=blinkstarts(length(blinkends):length(blinkstarts))+1;
  blinkends(length(blinkends)+1)=length(data.BlinkTimes);
end

% if there are blinks with big slopes within 20 samples of each other then
% make them one long period.
  % if we have close blinks and the slope for one blink is oppositely signed of the slope
  % of the next blink then they should cancel
for roundnum=1:3
  for ct=1:(length(blinkstarts)-1)
    if ((blinkstarts(ct+1)-blinkends(ct))<30) & abs(((data.RescaleData(blinkends(ct))- data.RescaleData(blinkstarts(ct)))>.4)) &  abs(((data.RescaleData(blinkends(ct+1))- data.RescaleData(blinkstarts(ct+1)))<.2))
      blinkends(ct)=blinkstarts(ct);
      blinkstarts(ct+1)=blinkends(ct);
      data.BlinkTimes(blinkstarts(ct):blinkends(ct+1))=1;
    end
  end
end

for ct=1:length(blinkstarts)
  firstindex=max(1,blinkstarts(ct)-4);
  lastindex=min(numpts,blinkends(ct)+9);
  %endind=blinkends(min(length(blinkends),ct));
  %interpdata=linspace(avgdata(firstindex,avgdata(min(length(avgdata),endind+4)),max(1,endind-blinkstarts(ct)+1));
  %data.NoBlinks(blinkstarts(ct):endind)=interpdata;
  %data.NoBlinksUnsmoothed(blinkstarts(ct):endind)=interpdata;
  interpdata=linspace(avgdata(firstindex),avgdata(lastindex),max(1,lastindex-firstindex+1));
  data.NoBlinks(firstindex:lastindex)=interpdata;
  data.NoBlinksUnsmoothed(firstindex:lastindex)=interpdata;
end

% fix blinks at beginning
if max(data.BlinkTimes(1:10))
  goodct=[1:length(data.NoBlinks)]'+10000000.*data.BlinkTimes;
  mingood=min(goodct);
  data.NoBlinks(1:mingood-1)=data.NoBlinks(mingood);
  data.NoBlinksUnsmoothed(1:mingood-1)=data.NoBlinks(mingood);
end
% fix blinks at end
if max(data.BlinkTimes(end-10:end))
  data.BlinkTimes((end-10):end)=1;
  goodct=[1:length(data.NoBlinks)]'+-9999999.*data.BlinkTimes;
  maxgood=max(goodct);
  data.NoBlinks((maxgood+1):end)=data.NoBlinks(maxgood);
  data.NoBlinksUnsmoothed((maxgood+1):end)=data.NoBlinks(maxgood);
end


data.NoBlinks=data.NoBlinks';

if graphics
 figure
 plot([data.RescaleData' data.NoBlinks data.BlinkTimes]);
end
