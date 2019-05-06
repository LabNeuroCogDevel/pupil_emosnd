function pupsurf(dilations,trialmin,trialmax,light)
if nargin <4, light=0; end 
if nargin < 3, trialmax=size(dilations,1); end
if nargin < 2, trialmin=1; end

[U,V]=meshgrid(0:.0167:(size(dilations,2)-1).*.0167,trialmin:trialmax);
if light,
  s=surf(U,V,max(-.1,dilations(trialmin:trialmax,1:size(dilations,2))));
  colormap default; 
else
  s=surfl(U,V,max(-.1,dilations(trialmin:trialmax,1:size(dilations,2))));
  colormap copper;
end

shading interp; 
rotate3d on; view(-82,66);
%xlabel('Time (s)   '); ylabel('Trial'); zlabel('mm');

if light,
  set(s,'FaceLighting','phong')
  light('Position',[1 0 0],'Style','infinite');
  light('Position',[0 -2 -1],'Style','infinite');
  light('Position',[-2 0 -1],'Style','infinite');
  light('Position',[2 2 2],'Style','infinite');

  %light('Position',[6 6 2],'Style','infinite');
  %light('Position',[6 -6 2],'Style','infinite');
  %light('Position',[-6 6 2],'Style','infinite');
  %light('Position',[4 250 2],'Style','infinite');
  %light('Position',[250 4 2],'Style','infinite');
  material shiny
  end
view(-85,34);
axis tight;

