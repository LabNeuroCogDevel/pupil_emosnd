function [pcastats] = pca(mat,numhifacs)
% performs a PCA with varimax rotation on
% a matrix. The matrix should have a variable in each column
% and a subject in each row.
% Usage: pcastats=pca(mat)
[pcastats.load,pcastats.percvar,pcastats.scores,pcastats.eigvals] = spcacov(mat);
if nargin<2,
  pcastats.numhifacs=length(find(pcastats.eigvals>mean(pcastats.eigvals)));
else
  pcastats.numhifacs=numhifacs;
end

if pcastats.numhifacs>1
  pcastats.rotloadg=varimax2(pcastats.load(:,1:pcastats.numhifacs));
  [pcastats.rotscores, pcastats.rotload, pcastats.ssq,pcastats.rotpercvar,pcastats.newrotvar]= varimax(pcastats.scores(:,1:pcastats.numhifacs), pcastats.load(:,1:pcastats.numhifacs),mat,1);
else
  pcastats.rotloadg=pcastats.load(:,1);
  pcastats.rotload=pcastats.load(:,1);
  pcastats.rotscores=pcastats.scores(:,1);
end


