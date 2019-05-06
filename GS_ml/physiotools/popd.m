function [newpath]=popd
% Useage: popd

global CURPATH;

if isempty(CURPATH)
  newpath='no current path to pop.';
  return;
else
  cd(char(CURPATH(length(CURPATH))));
  CURPATH=CURPATH(1:(length(CURPATH)-1));
  if (isempty(CURPATH))
    newpath=(pwd);
  else
    newpath=CURPATH;
  end
end
