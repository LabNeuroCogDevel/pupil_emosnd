function [CURPATH]=pushd(newpath)
% Useage: pushd(newpath)
global CURPATH
if isempty(CURPATH)
  CURPATH=cell(1);
  CURPATH(1)={pwd};  
else
  CURPATH(length(CURPATH)+1)={pwd};
end

cd(newpath);
