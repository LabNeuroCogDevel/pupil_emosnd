function data=cleanscanpath(data)
% interpolates scanpaths through (already computed) blinktimes 
% usage: data=cleanscanpath(data)



numpts=length(data.RescaleData);
% now interpolate
blinkends=find((data.BlinkTimes(1:end-1)==1) & (data.BlinkTimes(2:end)==0));
blinkstarts  =find((data.BlinkTimes(2:end)==1) & (data.BlinkTimes(1:end-1)==0));
if length(blinkends)>length(blinkstarts)
 blinkends=blinkends(2:end);
end

if length(blinkends)<length(blinkstarts)
  blinkends(length(blinkends):length(blinkstarts))=blinkstarts(length(blinkends):length(blinkstarts))+1;
end


for ct=1:length(blinkstarts)
  firstindex=max(1,blinkstarts(ct)-4);
  lastindex=min(numpts,blinkends(ct)+9);
  data.X(firstindex:lastindex)=linspace(data.X(firstindex),data.X(lastindex),max(1,lastindex-firstindex+1));
  data.Y(firstindex:lastindex)=linspace(data.Y(firstindex),data.Y(lastindex),max(1,lastindex-firstindex+1));
  if isfield(data,'CRX')
    data.CRX(firstindex:lastindex)=linspace(data.CRX(firstindex),data.CRX(lastindex),max(1,lastindex-firstindex+1));
    data.CRY(firstindex:lastindex)=linspace(data.CRY(firstindex),data.CRY(lastindex),max(1,lastindex-firstindex+1));
  end
  if isfield(data,'XmCRX')
    data.XmCRX(firstindex:lastindex)=linspace(data.XmCRX(firstindex),data.XmCRX(lastindex),max(1,lastindex-firstindex+1));
    data.YmCRY(firstindex:lastindex)=linspace(data.YmCRY(firstindex),data.YmCRY(lastindex),max(1,lastindex-firstindex+1));
  end
  if isfield(data,'Xn')
    data.Xn(firstindex:lastindex)=linspace(data.Xn(firstindex),data.Xn(lastindex),max(1,lastindex-firstindex+1));
    data.Yn(firstindex:lastindex)=linspace(data.Yn(firstindex),data.Yn(lastindex),max(1,lastindex-firstindex+1));
  end
end

% fix blinks at beginning
if max(data.BlinkTimes(1:10))
  goodct=[1:length(data.NoBlinks)]'+10000000.*data.BlinkTimes;
  mingood=min(goodct);
  data.X(1:mingood-1)=data.X(mingood);
  data.Y(1:mingood-1)=data.Y(mingood);  
  if isfield(data,'CRX')
    data.CRX(1:mingood-1)=data.CRX(mingood);
    data.CRY(1:mingood-1)=data.CRY(mingood);  
  end
  if isfield(data,'XmCRX')
    data.XmCRX(1:mingood-1)=data.XmCRX(mingood);
    data.YmCRY(1:mingood-1)=data.YmCRY(mingood);  
  end
  if isfield(data,'Xn')
    data.Xn(1:mingood-1)=data.Xn(mingood);
    data.Yn(1:mingood-1)=data.Yn(mingood);  
  end

end
% fix blinks at end
if max(data.BlinkTimes(end-10:end))
  data.BlinkTimes((end-10):end)=1;
  goodct=[1:length(data.NoBlinks)]'+-9999999.*data.BlinkTimes;
  maxgood=max(goodct);
  data.X((maxgood+1):end)=data.X(maxgood);
  data.Y((maxgood+1):end)=data.Y(maxgood);
  if isfield(data,'CRX')
    data.CRX((maxgood+1):end)=data.CRX(maxgood);
    data.CRY((maxgood+1):end)=data.CRY(maxgood);
  end
  if isfield(data,'XmCRX')
    data.XmCRX((maxgood+1):end)=data.XmCRX(maxgood);
    data.YmCRY((maxgood+1):end)=data.YmCRY(maxgood);
  end
  if isfield(data,'Xn')
    data.Xn((maxgood+1):end)=data.Xn(maxgood);
    data.Yn((maxgood+1):end)=data.Yn(maxgood);
  end
end
