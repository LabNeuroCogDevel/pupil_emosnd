function p=heartpreprocess(p,stdthresh,pleth) 
% useage: p=heartpreprocess(p,regThreshold,slopeThreshold,extremeThreshold,numSamples,weightingWidth) 
% smooths and corrects pupil p for blinks. Stores result in the incoming
% p structure, and identifies times at which blinks were removed

if nargin < 3, pleth = 1; end
if nargin < 2, stdthresh=.25; end
if nargin < 1, fprintf(-1,'Need at least a p array'); noblinks=-1; return; end


numpts=length(p.RescaleData);
%avgdata=runningrms(abs(data.RescaleData),weightingWidth)'; % smooth 
%avgdata=rescaleoutliers(avgdata,2);
%avgdata=eegfilt(data.RescaleData,250,0,3);
%avgdata=avgdata(1:numpts);
%p.Filtered=bandpass(p.RescaleData',.2,4,1./p.RescaleFactor);
%p.Filtered=bandpass(p.RescaleData',4,20,1./p.RescaleFactor);

% note: if we're picking up too much or too little it's probably because
% we haven't filtered enough or have filtered too much. We want to filter
% enough that bumpy areas become smooth peaks.
if pleth
  p.Filtered=bandpass(p.RescaleData',.1,3,1./(p.RescaleFactor));
else
  p.Filtered=bandpass(p.RescaleData',.1,40,1./(p.RescaleFactor));
end
%p.Filtered=p.RescaleData';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%% get hbs

p.hb=zeros(size(p.Filtered));
hbrange=p.Filtered.*(p.Filtered>(mean(p.Filtered)+stdthresh.*std(p.Filtered)));
startbeat=0;
for ct=1:length(p.Filtered)
  if ((startbeat==0) & (hbrange(ct)>0)) startbeat=ct; end
  if (startbeat & (hbrange(ct)==0))
    [bamp,btime]=max(hbrange(startbeat:ct));
    p.hb(startbeat+btime-1)=1;
    startbeat=0;
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% clean up hbs
%%%% filter out outliers > 1.6s or <.4s
% 2: add in missed ibis via derivatives

if pleth
  for cpass=1:1
    hbticks=find(p.hb); 
    ibis=[hbticks hbticks(end)]-[0 hbticks];
    wrongibis=[0 ibis(2:end)>(1.25.*ibis(1:end-1))];
    mibi=m(ibis(2:end-1)',wrongibis(2:end-1)');
    for ct=2:length(wrongibis)
      if wrongibis(ct)
	plethseg=p.Filtered(hbticks(ct-1):hbticks(ct));
	plethder=diff(plethseg);
	hbinder=find(([0 plethder]>0) & ([plethder 0]< 0));
	if hbinder, 
	  %[v,ni]=max(plethseg(hbinder)); % get max hb
	  % Rather get hbinder nearest to the right distance
	  [v,ni]=min(abs(hbinder-mibi));
	  if (hbticks(ct)-(hbinder(ni)+hbticks(ct-1)))>42
	    p.hb(hbinder(ni)+hbticks(ct-1))=1; 
	  end
	end
      end
    end
  end
  
  for cpass=1:1
    % 3: take out extras via time-in-between criteria
    hbticks=find(p.hb);
    ibis=[hbticks 0]-[0 hbticks];
    wrongibis=[0 ibis(2:end)<(.5.*ibis(1:end-1))];
    p.hb(hbticks(find(wrongibis(1:end-1))-1))=p.hb(hbticks(find(wrongibis(1:end-1))-1))-1;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p.hbind=find(p.hb);
p.hbtimes=p.hbind/p.RescaleFactor;
p.ibis=[p.hbtimes(2:end)-p.hbtimes(1:end-1)];

%data.beats=find(data.RescaleData>500);
% plot([p.RescaleData(2000:4000)' p.Filtered(2000:4000) 20.*p.hb(2000:4000)]);

%%%% get local hr
p.curhr=zeros(size(p.hb));
p.curhr(1:p.hbind(1))=(1./p.ibis(1)).*60;
bstart=1;
for cur=1:length(p.hbind)-2
  %curnow=(1./(p.hbtimes(cur+1)-p.hbtimes(cur))).*60;
  %curnext=(1./(p.hbtimes(cur+2)-p.hbtimes(cur+1))).*60;
  %p.curhr(p.hbind(cur):p.hbind(cur+1))=linspace(curnow,curnext,p.hbind(cur+1)-p.hbind(cur)+1);

  bstart=round((p.hbind(cur)+p.hbind(cur+1))./2);
  bend=round((p.hbind(cur+1)+p.hbind(cur+2))./2);
  
  %bend=round((p.hbind(cur+1)+p.hbind(cur+2))./2);
  curnow=(1./(p.hbtimes(cur+1)-p.hbtimes(cur))).*60;
  curnext=(1./(p.hbtimes(cur+2)-p.hbtimes(cur+1))).*60;
  p.curhr(bstart:bend)=linspace(curnow,curnext,bend-bstart+1); 

  
  hbmaxnow=p.plethraw(p.hbind(cur)); % peak
  hbmaxnext=p.plethraw(p.hbind(cur+1));
  if cur==1
    hbminnow=min(p.plethraw(p.hbind(cur):p.hbind(cur+1)));    
  else
    hbminnow=min(p.plethraw(p.hbind(cur-1):p.hbind(cur)));
  end
  hbminnext=min(p.plethraw(p.hbind(cur):p.hbind(cur+1)));
  hbampnow=hbmaxnow-hbminnow; % peak to trough measure
  hbampnext=hbmaxnext-hbminnext;
  p.curheartamp(p.hbind(cur):p.hbind(cur+1))=linspace(hbampnow,hbampnext,p.hbind(cur+1)-p.hbind(cur)+1);
  p.curheartamppk(p.hbind(cur):p.hbind(cur+1))=linspace(hbmaxnow,hbmaxnext,p.hbind(cur+1)-p.hbind(cur)+1);
  
  bstart=bend;
end

cur=length(p.hbind)-1;
p.curhr(p.hbind(cur):p.hbind(cur+1))=(1./(p.hbtimes(cur+1)-p.hbtimes(cur))).*60;
p.curhr(p.hbind(end):end)=(1./p.ibis(end)).*60;
p.curhr=rescaleoutlierstimeseries(p.curhr')';
p.curhrsmooth=filtertenpt100hz(p.curhr) % smooth

hbmaxnow=p.plethraw(p.hbind(cur)); % peak
hbmaxnext=p.plethraw(p.hbind(cur+1));
hbminnow=min(p.plethraw(p.hbind(cur-1):p.hbind(cur)));
hbminnext=min(p.plethraw(p.hbind(cur):p.hbind(cur+1)));
hbampnow=hbmaxnow-hbminnow; % peak to trough measure
hbampnext=hbmaxnext-hbminnext;
p.curheartamp(p.hbind(cur):p.hbind(cur+1))=linspace(hbampnow,hbampnext,p.hbind(cur+1)-p.hbind(cur)+1);
p.curheartamp(p.hbind(end):length(p.curhr))=p.curheartamp(p.hbind(end));

p.curheartamppk(p.hbind(cur):p.hbind(cur+1))=linspace(hbmaxnow,hbmaxnext,p.hbind(cur+1)-p.hbind(cur)+1);
p.curheartamppk(p.hbind(end):length(p.curhr))=p.curheartamppk(p.hbind(end));

p.curheartamp=rescaleoutlierstimeseries(p.curheartamp')';
p.curheartamppk=rescaleoutlierstimeseries(p.curheartamppk')';




%plot(p.hb(10000:15000).*60,'r'); hold on; plot(p.curhr(10000:15000),'g'); axis([0 5000 50 80])

%%%% get local hr
%p.curhrn=zeros(size(p.hb));
%p.curhrn(1:p.hbind(1))=(1./p.ibis(1)).*60;
%for cur=1:length(p.hbind)-1
%  p.curhrn(p.hbind(cur):p.hbind(cur+1))=(1./(p.hbtimes(cur+1)-p.hbtimes(cur))).*60;
%end
%p.curhrn(p.hbind(end):end)=(1./p.ibis(end)).*60;
%p.curhrn=rescaleoutliers(p.curhrn')';
%p.curhrnsmooth=  dbfilter(p.curhrn,40); % smooth 

p=heartgethrv(p,p.RescaleFactor);
% p=heartgetcoherence(p);

%%%% get heart phase
p.hrphase=zeros(size(p.hb));
for cur=1:length(p.hbind)-1
   p.hrphase(p.hbind(cur):p.hbind(cur+1))=2.*pi.*((p.hbind(cur):p.hbind(cur+1))-p.hbind(cur))./(p.hbind(cur+1)-p.hbind(cur));
end

