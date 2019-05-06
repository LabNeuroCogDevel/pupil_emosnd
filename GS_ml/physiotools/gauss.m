function[dist]=gauss(mu,s,steps,lbd,ubd) 
% gives data along a gaussian. 
% Useage: gauss(mu,s,[,#steps,lbd,ubd])
% where mu=center, s=rise/fall
% e.g., plot(gauss(0,1,125))
% defaults to bounds of -6,6
% To use: with bounds of -1,1 & 100 steps, normal dist takes up s
% points on either side of mu for a total of s*2 points.

if nargin < 5, ubd=6; end;
if nargin < 4, lbd=-6; end;
if nargin < 3, steps=100; end;
if nargin < 2, s=1; end;
if nargin < 1, mu=0; end;

x=linspace(lbd,ubd,steps);
dist=(1/(s.*sqrt(2.*pi))).*exp(-.5.*((x-mu)./s).^2);
