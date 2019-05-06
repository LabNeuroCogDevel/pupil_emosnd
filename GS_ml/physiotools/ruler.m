function ruler(ncols,fignum,mincol,maxcol)
% plots a colormap in a short, squat rectangle
% usage ruler(ncols,fignum,mincol,maxcol)
% note: fignum=0 makes a new figure
% note: mincol and maxcol are written, but show up offscreen unless
% the figure is resized

cmap=get(gcf,'ColorMap');
if nargin<1, ncols=size(cmap,1); end
if nargin<2, fignum=0; end
if nargin<3, mincol=0; end

%[x,y]=meshgrid(0:ncols+1,0:1);
col=zeros(2,ncols+2);
col(1,1:ncols+1)=[0:ncols];
if fignum, figure(fignum); else figure; end
clf;
pcolor(col);
shading flat;
colormap(cmap);

if mincol,
  set(gca,'YTickLabel',{})
  set(gca,'XTick',[1 ncols]);
  %set(gca,'XTickLabel',[mincol,maxcol]);
  set(gca,'XTickLabel',{sprintf('%.2f',mincol),sprintf('%.2f',maxcol)});
  %set(gcf,'Position',[6 466 406 172]);
  set(gcf,'Position',[6 582 274 56]);
else
 axis off;
 set(gcf,'Position',[6 577 406 61])
end

