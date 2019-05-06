function mc=trimmean(x,perc)
% computes the perc trimmed mean
% defaults to 95%
% if x is a matrix we take the mean of each COLUMN
if nargin<2, perc=95, end

if size(x,2)==1, x=x'; end

startrow=round(size(x,1).*(((100-perc)./2)/100));
if startrow==0, startrow=1; end
endrow=size(x,1)-startrow;
for col=1:size(x,2)
  vec=x(col,:);
  mc(col)=mean(sort(x(startrow:endrow,col)));
end
