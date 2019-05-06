function [w]=randomwalk(steps,stepsize)
% randomwalk
% useage: [w]=randomwalk(steps,stepsize) 
if nargin<2
  stepsize=.01;
end
if nargin<1
  steps=344*60;
end

w=zeros(1,steps);
for step=2:steps
  w(step)=w(step-1)+randn*stepsize;
end

