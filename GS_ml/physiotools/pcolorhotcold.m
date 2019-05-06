function pcolorhotcold(mat,drawruler)
% usage: pcolorhotcold(mat,drawruler)
% draws every square of matrix (flipped so 1,1 is the top left)
% colored so positive numbers are in hot metal
% and negative numbers are black->blue
% note: the y axis label is reversed and should not be used.

if nargin<2, drawruler=1; end

pcolor(padlr(flipud(mat)));
matinorder=sort(reshape(mat,1,prod(size(mat))));
numneg=length(find(matinorder<0));
numpos=length(matinorder)-numneg;
cmap=[blackblue(numneg);hot(numpos)];
colormap(cmap);
shading flat;
axis off;

if drawruler
  ruler(numpos+numneg,3,matinorder(1),matinorder(end));
end
