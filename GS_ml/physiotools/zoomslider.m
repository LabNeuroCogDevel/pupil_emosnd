function zoomslider(invert)
% slider for scrollplot
if nargin<1, invert=0; end

axisdata=get(gcf,'UserData');
axes(gca);
range=axisdata(2)-axisdata(1);
RegionSlider=findobj('Tag','RegionSlider');
curpos=get(RegionSlider,'value');
ZoomSlider=findobj('Tag','ZoomSlider');
curzoom=max(get(ZoomSlider,'value'),.00001);
middle=1+curpos.*(range-1);
%lbd=max(1,middle-(range./2)*curzoom);
lbd=middle-(range./2)*curzoom;
ubd=lbd+range.*curzoom;
%ubd=min(size(data,2),lbd+range.*curzoom);
set(gca,'xlim',[lbd ubd]);
axis([lbd ubd axisdata(3) axisdata(4)]);
if invert
  view(0,270);
end
