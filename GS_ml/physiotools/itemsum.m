function isum=itemsum(items,data,reverse)
% Useage: isum=itemsum(items,data[,reverse])
% Assumes items are not reverse scored
% To reverse score items pass reverse, which is
%   the number from which item scores are subtracted

isum=0;
for item=1:length(items)
  if nargin < 3
    isum=isum+data(items(item));
  else
    isum=isum+(reverse-data(items(item)));
  end
end
