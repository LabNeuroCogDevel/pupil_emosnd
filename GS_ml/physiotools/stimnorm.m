function [normtrials]=basenorm(eventtrials,puptrials,baselength)
% given a matrix of trials returns a matrix
% in which the mean of the first baselength measurements
% is subtracted from all points, yielding a
% change index

if nargin<3 baselength=10; end;

for i=1:size(puptrials,1)
    [stimtype,onsettime]=max(eventtrials(i,:));
%    normtrials(i,:)=puptrials(i,:)-mean(puptrials(i,onsettime:onsettime+10));
    normtrials(i,:)=puptrials(i,:)-mean(puptrials(i,1:onsettime));
end
