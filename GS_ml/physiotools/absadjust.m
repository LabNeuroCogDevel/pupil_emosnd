function [adjusted]=absadjust(noblinks)
% useage: [adjusted]=absadjust(noblinks)
% reigns in anything over 4.2 sd under the mean

lowestlegal=median(noblinks)-4.2.*std(noblinks);
needsadjusting=noblinks<lowestlegal;

adjusted=max(lowestlegal,noblinks);

%good=noblinks(1);
%for count=1:size(noblinks,2)
%  if (noblinks(count)>lowestlegal)
%    good=noblinks(count);
%  end
%  adjusted(count)=good;
%end

