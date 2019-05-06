function r2ypy = r2(yp,y,outlier)
% computes a nonlinear r^2 fit
% useage: r2(ypred,y,outlier)
%  where trials with outlier=1 are filtered out


if nargin==3
  indices=find(~outlier);
  nyp=zeros(size(indices,1),1);
  ny=zeros(size(indices,1),1);
  for ind=1:size(indices,1)
     nyp(ind)=yp(indices(ind));
     ny(ind)=y(indices(ind));
  end
else
  nyp=yp; ny=y;
end

modelss=sum(nyp.^2);
residss=sum((ny-nyp).^2);
corrtotss=sum((ny-mean(ny)).^2);
%r2ypy=max(0,1-(residss./corrtotss));
r2ypy=1-(residss./corrtotss);
