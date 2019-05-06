function[exg]=exgauss(mu,s,tau,steps,lbd,ubd) 
% gives data along an exgaussian. 
% Useage: exgauss(mu,s,tau [,#steps,lbd,ubd])
% where mu=center, s=rise, tau=fall
% e.g., plot(exgauss(0,1,2,125))

if nargin < 5, ubd=3*pi; end;
if nargin < 4, steps=125; end;
if nargin < 3, tau=3.03; end;
if nargin < 2, s=1; end;
if nargin < 1, mu=0; end;

lbd=-pi;
inc=(ubd-lbd)./(steps-1);

exg=zeros(1,size(lbd:inc:ubd,2));
count=1;


for t=lbd:inc:ubd-inc,
  count=count+1;
  y=-10:.1:(((t-mu)/s)-(s/tau));
  inty=sum(exp(-(y.^2)/2));
  exg(count)=exp(-((t-mu)/tau)+s^2/(2*tau^2))/(tau*sqrt(2*pi)).*inty;
end


