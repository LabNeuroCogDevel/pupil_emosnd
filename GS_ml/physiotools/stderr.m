function se=stderr(vec)
% computes the standard error of X
% usage: stderr=se(X)
stderr=std(X)./sqrt(size(X,1));
