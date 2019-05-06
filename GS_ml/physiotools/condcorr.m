function [corrs]=condcorr(conds,arr1,arr2,outlier)
% given two variables of interest distributed over conditions, 
% and a list of conditions (all column vectors)
% calculates the correlation for each condition.
% Useage: rqcondcorr(conds,arr1,arr2)

if nargin<4
   outlier=zeros(size(arr1));
end

conditions=unique(conds);
for cond=1:size(conditions,1)
  indices=find((conds==conditions(cond)) & (~outlier));
  narr=zeros(size(indices,1),2);
  for ind=1:size(indices,1)
    narr(ind,:)=[arr1(indices(ind))' arr2(indices(ind))'];
  end
  thiscorr=corrcoef(narr);
  corrs(cond)=thiscorr(1,2);
end
