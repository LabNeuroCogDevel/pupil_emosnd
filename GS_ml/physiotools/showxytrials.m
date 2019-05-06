function showxytrials(p,normed,mintrial,maxtrial,fignum,miny,maxy,dodetrend)
% given a pupil data structure
% graphs an overlay plot of all trials
% USEAGE: showxytrials(p [,normed,mintrial,maxtrial,fignum,miny,maxy,dodetrend])
% e.g., showxytrials(p,0,1,45,1,0,0)
if nargin < 8, dodetrend=0; end

if isstruct(p)
  if nargin < 2 
    normed = 0;
  end 
  if normed==1 
    datax=p.XnTrials;
    datay=p.YnTrials;
  else 
    datax=p.XTrials;
    datay=p.YTrials;
  end
else
  datax=squeeze(p(:,1,:));
  datay=squeeze(p(:,2,:));
  normed=0;
  p.RescaleFactor=1; %62.5;
  p.EventTrials=zeros(size(data));
  p.PupilTrials=data;
  p.TrialSeconds=zeros(size(data,1),1);
end

data(:,1,:)=datax;
data(:,2,:)=datay;


if nargin < 3, mintrial = 1; end
if nargin < 4, maxtrial = size(data,1); end
if nargin < 5, 
  if isempty (get(gcf,'CurrentAxes'))
    fignum=1;
  else
    fignum=max(findobj('Type','figure'))+1;
  end
end
if nargin < 6, miny=min(min(squeeze(data(mintrial:maxtrial,2,:)))); end
if nargin < 7, maxy=max(max(squeeze(data(mintrial:maxtrial,2,:)))); end




if ((maxtrial-mintrial+1) > 20)
  for block=1:ceil(maxtrial/20)
         newmin=(block-1)*20+1;
         newmax=block*20;
         showxytrials(p,normed,newmin,newmax,block+fignum-1,miny,maxy);
  end
else
  figure(fignum);
  set(fignum,'Name','Individual Trials');
  if (maxtrial>size(data,1))
    maxtrial=size(data,1);
  end
  maxev=max(max(p.EventTrials));
  if maxev>0, eventscale=maxy./max(max(p.EventTrials));
  else eventscale=0;
  end
  
  
  if normed
    plotxy(data(mintrial:maxtrial,:,:),0,0, ...
	   miny, maxy, ...
	   p.TrialSeconds,eventscale.*p.EventTrials(mintrial:maxtrial, 1:length(p.TrialSeconds)),...
	   mintrial); 
  else
    seconds=0:1./p.RescaleFactor:(1./p.RescaleFactor).*(size(data,2)-1);
    plotxy(data(mintrial:maxtrial,:,:),0,0, ...
	   miny, maxy, ...
	   seconds,eventscale.*p.EventTrials(mintrial:maxtrial,:),mintrial); 
  end
end
