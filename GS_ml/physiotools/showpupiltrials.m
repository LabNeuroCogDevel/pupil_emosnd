function showpupiltrials(p,normed,mintrial,maxtrial,fignum,miny,maxy,dodetrend)
% given a pupil data structure
% graphs an overlay plot of all trials
% USEAGE: showpupiltrials(p [,normed,mintrial,maxtrial,fignum,miny,maxy,dodetrend])
if nargin < 8, dodetrend=0; end

if isstruct(p)
  if nargin < 2 
    normed = 1;
  end
  if normed==1 
    if dodetrend
      data=p.NormedDetrendPupTrials;    
    else
      data=p.NormedPupTrials;
    end
  else 
    if dodetrend
      data=p.DetrendPupilTrials;
    else
      data=p.PupilTrials;
    end
  end
else
  data=p;
  normed=0;
  p.RescaleFactor=1; %62.5;
  p.EventTrials=zeros(size(data));
  p.PupilTrials=data;
  p.TrialSeconds=zeros(size(data,1),1);
end

if nargin < 3, mintrial = 1; end
if nargin < 4, maxtrial = size(data,1); end
if nargin < 5, 
  if isempty (get(gcf,'CurrentAxes'))
    fignum=1;
  else
    fignum=max(findobj('Type','figure'))+1;
  end
end
if nargin < 6, miny=min(min(data(mintrial:maxtrial,:))); end
if nargin < 7, maxy=max(max(data(mintrial:maxtrial,:))); end

if ((maxtrial-mintrial+1) > 20)
  for block=1:ceil(maxtrial/20)
         newmin=(block-1)*20+1;
         newmax=block*20;
         showpupiltrials(p,normed,newmin,newmax,block+fignum-1,miny,maxy);
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
    ploteegsys(data(mintrial:maxtrial,:),0,0, ...
	       miny, maxy, ...
	       p.TrialSeconds,eventscale.*p.EventTrials(mintrial:maxtrial, 1:length(p.TrialSeconds)),...
	       mintrial,'mm'); 
  else
    seconds=0:1./p.RescaleFactor:(1./p.RescaleFactor).*(size(data,2)-1);
    ploteegsys(data(mintrial:maxtrial,:),0,0, ...
	       miny, maxy, ...
	       seconds,eventscale.*p.EventTrials(mintrial:maxtrial,:),mintrial,'mm'); 
  end
end
