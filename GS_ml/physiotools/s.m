function st = s(x,outlier)
% computes a stdev
% usage: s(x,outlier)
%  where trials (rows) with outlier=1 are filtered out
% assumes outlier is a COLUMN vector

if nargin==2
  indices=find(~outlier);
  narr=zeros(length(indices),size(x,2));
  for ind=1:size(indices,1)
     narr(ind,:)=x(indices(ind),:);
  end
  st=std(narr);
else
  st=std(x);
end
