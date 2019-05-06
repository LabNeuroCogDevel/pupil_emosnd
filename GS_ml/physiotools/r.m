function [xy,p] = r(x,y,outlier)
% computes a zero order correlation
% useage: r(x,y,outlier)
%  where trials with outlier=1 are filtered out


if nargin==3
  indices=find(~outlier);
  xy=corrcoef(x(indices),y(indices));
else
  xy=corrcoef(x,y);
end

xy=xy(1,2);

if nargout>1
  df=length(x)-2;
  t=xy./sqrt((1-xy.^2)./df);
  p=tcdf(t,df);
  p=(t>=0).*(1-p)+(t<0).*p;
  %if t>=0, p=1-p; end
  p=2.*p; % makes it 2-tailed
end


%c = cov(x,y);
%d = diag(c);
%xy = c./sqrt(d*d');
%xy=xy(1,2);
