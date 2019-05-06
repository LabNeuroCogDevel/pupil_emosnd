function [medians,sds,numused]=condmedians(conds,arr,outlier)
% given a variable of interest distributed over conditions, 
% and a list of conditions (all column vectors)
% calculates the median & standard deviation for each condition.
%   conds is a column vector
%   arr is a matrix with data to be averaged over in rows
%   returns a row vector one number per condition.
% Useage: [medians sds]=condmedians(conds,arr1)

if nargin<3
   outlier=zeros(size(arr));
end

[b1,b2,goodconds]=find(conds.*(1-outlier));

conditions=unique(goodconds);
for cond=1:size(conditions,1)
  indices=find((conds==conditions(cond)) & (~outlier));
  if size(indices)>0
    narr=zeros(size(indices,1),1);
    for ind=1:size(indices,1)
      narr(ind,:)=arr(indices(ind))';
    end
    medians(cond)=median(narr);
    sds(cond)=std(narr);
    numused(cond)=length(narr);
  else
    medians(cond)=-999;
    sds(cond)=-999;
    numused(cond)=-999;
  end
end
