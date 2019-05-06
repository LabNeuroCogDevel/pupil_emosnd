function h=regplot(x,y,group,seplines,plotrsq,outliers,smallboxes)
% plots a regression line through points.
% usage: h=regplot(x,y,group,seplines,plotrsq,outliers,smallboxes)
% where h is the axis for use with legend

if nargin<3, group=0; end
if nargin<4, seplines=0; end
if nargin<5, plotrsq=0; end
if nargin<6, outliers=zeros(size(x)); end
if nargin<7, smallboxes=0; end

%group=0; seplines=0; plotrsq=0'; outliers=zeros(size(x));


x=x(find(1-outliers));
y=y(find(1-outliers));
if length(group)>1
  group=group(find(1-outliers));
end

gcoltable=[0.9    0.2    0.6
	   0.4    0.6    1
	   0    1.0    0
	   1.0    0.2    0.5
	   1.0    1.0    0
	   0      0      0];

	   

% generates a scatter plot regression with the best fit line
% usage: regplot(x,y,group,seplines,plotrsq)
% where group is categorical, seplines is separate lines per group

if length(group)>1
  cols=gcoltable;
  if smallboxes
    sex=abs(se(x))./5; sey=abs(se(y))./5;
  else
    sex=abs(se(x)); sey=abs(se(y));
  end
  
  for ct=1:length(group)
    a=patch([x(ct)-sex/2 x(ct)-sex/2 x(ct)+sex/2 x(ct)+sex/2],[y(ct)-sey/2 y(ct)+sey/2 y(ct)+sey/2 y(ct)-sey/2], [group(ct) group(ct) group(ct) group(ct)]);
    set(a,'EdgeColor',cols(group(ct),:));
    set(a,'FaceColor',cols(group(ct),:));
  end
else
 plot(x,y,'.');
end
hold on;
fprintf('All data: ');
s=mregs(x,y,zeros(size(y)),0,1);
minx=min(x); maxx=max(x);
miny=s.B.*minx+s.B0;
maxy=s.B.*maxx+s.B0;
h=plot([minx; maxx],[miny maxy],'k');
if plotrsq
 legend(h,sprintf('R^2=%.2f',s.Rsq));
end

if seplines
  grpmem=unique(group);
  for ct=1:length(grpmem)
    inds=find(group==grpmem(ct));
    fprintf('Group %d: ',ct);
    s=mregs(x(inds),y(inds),zeros(size(y(inds))),0,1);
    minx=min(x); maxx=max(x);
    miny=s.B.*minx+s.B0;
    maxy=s.B.*maxx+s.B0;
    h(ct)=line([minx; maxx],[miny maxy]);
    set(h(ct),'Color',cols(ct,:));
    %if plotrsq
    %  legend(sprintf('R^2=%.2f',s.Rsq));
    %end
  end
end

axis tight;
hold off;
