function rxy = r1b(x,y,outlier)
% computes lag 1 cross correlation (r(x(2:n),y(1:n-1)))
% Useage: r1b(x,y[,outlier]) where x & y are column vectors

if (nargin<2) 
  fprintf(1,'Useage: r(x,y)\n');
  return
end

if nargin==3
  rxy=r(x(2:size(x,1)),y(1:(size(x,1)-1)),outlier(2:size(x,1)));
else
  rxy=r(x(2:size(x,1)),y(1:(size(x,1)-1)));
end
