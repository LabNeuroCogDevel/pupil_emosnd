function sdp=sdpooled(s1,s2,n1,n2,doaspaired)
% returns the pooled standard deviation
% usage: sdp=sdpooled(s1,s2,n1,n2)
%   OR   sdp=sdpooled(dat) where dat is 2 columns

if nargin<5, doaspaired=0;

if nargin<2
  dat=s1;
  s1=std(dat(:,1)); s2=std(dat(:,2)); n1=size(dat,1); n2=size(dat,1);
  sdp=sdpooled(s1,s2,n1,n2);
else
  if doaspaired
    % NOTE: THIS IS NOT RIGHT. Should account for correlation of s1 and s2
    sdp=sqrt(((n1-1).*s1.^2+(n2-1).*s2.^2)/(n1+n2-2)); 
  else
    sdp=sqrt(((n1-1).*s1.^2+(n2-1).*s2.^2)/(n1+n2-2));
  end
end
