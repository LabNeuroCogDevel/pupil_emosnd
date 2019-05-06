function showpupiltrials(p,normed,mintrial,maxtrial,fignum)
% given a pupil data structure
% graphs an overlay plot of all trials with different axes per trial
% USEAGE: showpupiltrials(p [,normed,mintrial,maxtrial,fignum])
if nargin < 2 
  normed = 1;
end
if normed==1 data=p.NormedPupTrials;
else data=p.PupilTrials;
end
if nargin < 3
  mintrial = 1;
end
if nargin < 4 
  maxtrial = size(p.PupilTrials,1);
end
if nargin < 5
  fignum=gcf;
end
showpupiltrials(p,normed,mintrial,maxtrial,fignum,0,0);
