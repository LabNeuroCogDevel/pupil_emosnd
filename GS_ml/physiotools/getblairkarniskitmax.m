function [tmaxthresh,p05tmax] = getblairkarniskitmax(data,group,sigthresh)
% gets tmax threshold for a given statistical threshold
% via R.C. Blair & W. Karniski (1993) "An alternative method
%   for significance testing of waveform difference potentials"
%   Psychophysiology, 30, 518-524.
% This routine generates all permutations of data to conditions
%   and for each permutation does a t-test at each time-point.
%   tmax maximum t-test from any time-point for a given permutation.
% We then select the tmax for which 95% (or other threshold) of the 
%   permutations are rejected, such that 95% of the permutations
%   have NO significant t-tests.
% We then apply that threshold to the successive t-tests in our
%   waveform of interest.
% usage: tmaxthresh = getblairkarniskitmax(data,group,sigthresh)
%   where data has the mean waveform for each subject and grpnum says
%   which group each subject is in.

if nargin<3, sigthresh = .05; end

numperms=min(100,factorial(length(group)));

for permnum=1:numperms
  grpperm=rowpermute(group);
  [ts]=getallwaveformts(data,grpperm); % get t-tests along a given permutation
  maxt(permnum)=max(abs(ts));
end
sortts=sort(maxt);
ind=floor((1-sigthresh).*length(sortts));
tmaxthresh=sortts(ind);
p05tmax=sortts(floor(.95.*length(sortts)));
