function [normtrials]=pupbasenorm(trials,baselength)
% given a matrix of trials returns a matrix
% in which the mean of the first baselength measurements
% is subtracted from all points, yielding a
% change index
% useage: [normtrials]=pupbasenorm(trials,baselength)

if nargin<2 baselength=10; end;

for i=1:size(trials,1)
    normtrials(i,:)=trials(i,:)-mean(trials(i,1:baselength));
end
