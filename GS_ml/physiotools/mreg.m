function [Rsq,B,B0,Ypred]=mreg(X,Y,outlier)
% Usage: [Rsq,B,B0,Ypred]=mreg(X,Y[,outlier]) 
% Performs a multiple regression
%  X is a matrix of column vectors representing 
%    explantory (independent) variables
%  Y is a column vector representing the 
%    response (dependent) variable
%  outlier is an optional column vector the same size as Y 
%    in which entries with zero are used and non-zero entries
%    are censored
% by Greg Siegle

if (nargin<2)
  fprintf(1,'Useage: [Rsq,B,B0,Ypred]=mreg(X,Y)\n');
  return
end

if nargin==3 % restrict X and Y based on outlier
  indices=find(~outlier);
  nx=zeros(size(indices,1),size(X,2));
  ny=zeros(size(indices,1),1);
  for ind=1:size(indices,1)
     nx(ind,:)=X(indices(ind),:);
     ny(ind)=Y(indices(ind));
  end
  X=nx;
  Y=ny;
end


mx=mean(X);
for col=1:size(X,2)
  Xn(:,col)=X(:,col)-mx(col);
end

Yn=Y-mean(Y);
B=inv(Xn'*Xn)*Xn'*Yn;
B0=mean(Y-X*B);
Ypred=X*B+B0;
Rsq=var(Ypred)/var(Yn);


%stdX=(X-mean(X))./std(X);
%stdY=(Y-mean(Y))./std(Y);
%stdB=inv(stdX'*stdX)*stdX'*stdY;
%B0=mean(stdY-stdX*stdB);
%stdYpred=stdX*stdB+B0;
%Rsq=var(stdYpred)/var(stdY);
