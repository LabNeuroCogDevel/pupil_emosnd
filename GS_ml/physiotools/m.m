function mn = m(x,outlier)
% computes a mean
% usage: r(x,outlier)
%  where trials (rows) with outlier=1 are filtered out
% assumes outlier is a COLUMN vector

if nargin==2
  mn=mean(x(find(~outlier),:));
  %indices=find(~outlier);
  %narr=zeros(length(indices),size(x,2));
  %for ind=1:size(indices,1)
  %   narr(ind,:)=x(indices(ind),:);
  %end
  %mn=mean(narr);
else
  mn=mean(x);
end
