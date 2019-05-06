function s=rttest(r,n)
% tests the significance of a correlation (r)
% computed on n subjects

s.r=r;
s.n=n;
s.t=(r*sqrt(n-2))./sqrt(1-(r.^2));
s.df=n-2;
s.p=tcdf(s.t,s.df);
s.p=(s.t>=0).*(1-s.p)+(s.t<0).*s.p;
s.p=2.*s.p; % makes it 2-tailed

