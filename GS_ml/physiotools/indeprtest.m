function [irt]=indeprtest(r1,r2,n1,n2)
% computes a z-test of independent r's 
% as described in Walker, H. & Lev, J. (1953). Statistical Inference, NY: Holt & Co.
% p. 256.
% usage: [irt]=indeprtest(r1,r2,n1,n2)

irt.z=(fisherz(r2)-fisherz(r1))./(sqrt((1./(n1-3))+(1./(n2-3))));
if (irt.z<0), irt.p = normcdf(irt.z); end
if (irt.z>0), irt.p = 1-normcdf(irt.z); end
if (irt.z==0), irt.p=0; end

irt.p=irt.p./2; % makes it 2-tailed

