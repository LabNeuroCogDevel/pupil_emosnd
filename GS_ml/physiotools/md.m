function mn = md(x,outlier)
% computes a median
% usage: md(x,outlier)
%  where trials (rows) with outlier=1 are filtered out
% assumes outlier is a COLUMN vector

if nargin==2
  mn=median(x(find(~outlier),:));
%  indices=find(~outlier);
%  narr=zeros(length(indices),size(x,2));
%  for ind=1:size(indices,1)
%     narr(ind,:)=x(indices(ind),:);
%  end
%  mn=median(narr);
else
  mn=median(x);
end
