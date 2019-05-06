function [mr]=mregs(X,Y,outlier,getts,prettyprint)
% performs a multiple regression
% where X is a matrix of column vectors and Y is a column vector
% Useage: [mr]=mregs(X,Y[,outlier]) 
% where mr is a structure with relevant values
%  including Rsq,B,B0,Ypred,dfr,dff,F,p

if nargin<3, outlier=zeros(size(Y)); end; 
if nargin<4, getts=0; end
if nargin<5, prettyprint=0; end

[mr.Rsq,mr.B,mr.B0,mr.Ypred]=mreg(X,Y,outlier);
Er=1; 
Ef=1-mr.Rsq;
mr.dfr=size(X,1)-length(find(outlier))        -1;
mr.dff=size(X,1)-length(find(outlier))-size(X,2)-1;
mr.F=((Er-Ef)./(mr.dfr-mr.dff))./(Ef./mr.dff);
mr.p=1-fcdf(mr.F,mr.dfr-mr.dff,mr.dff);

ncols=size(X,2);
if (getts & (ncols>1))
  if ncols==2
    rsqs(1)=mr.Rsq-mreg(X(:,2),Y,outlier);
    rsqs(2)=mr.Rsq-mreg(X(:,1),Y,outlier);
  else
    for ct=1:ncols
      mincol=1; if ct==1, mincol=2; end
      maxcol=ncols; if ct==ncols, maxcol=ncols-1; end
      Xs=[X(:,mincol:ct-1) X(:,ct+1:maxcol)];
      rsqs(ct)=mr.Rsq-mreg(Xs,Y,outlier);
    end
  end
  denom=sqrt((1-mr.Rsq)./mr.dff);
  for ct=1:ncols
    mr.t(ct)=rsqs(ct)./denom;
    mr.tp(ct)=1-tcdf(mr.t(ct),mr.dff);
  end
end
if prettyprint
  fprintf(1,'Rsq = %.3f, F(%d,%d)=%.3f, p=%.3f\n',mr.Rsq, mr.dfr-mr.dff,mr.dfr,mr.F,mr.p);
end

    
