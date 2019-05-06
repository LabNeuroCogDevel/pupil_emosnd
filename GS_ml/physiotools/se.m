function stderr=se(X)
% computes the standard error of X
% note: subjects should be in ROWS
% usage: stderr=se(X)
if size(X,1)==1, X=X'; end
stderr=std(X)./sqrt(size(X,1));
