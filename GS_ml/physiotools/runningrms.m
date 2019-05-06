function trms=runningrms(data,width)
% each point becomes the rms of the points around it
% usage: trms=runningrms(data,width)

if nargin<2, width=20; end

n=length(data);
kernal=(ones(1,width))./width;
trms=sqrt(conv(data.^2,kernal));
trms=trms(1:n);


%%%% old slow way: ****
% for t=1:length(data)
%   if ((t>width) & (t<n-width)) lb=t-width; ub=t+width;
%   elseif (t>width) lb=t-width; ub=n;
%   else lb=1; ub=t+width;
%   end
%   trms(t)=sqrt(mean(data(lb:ub).^2));
% end
