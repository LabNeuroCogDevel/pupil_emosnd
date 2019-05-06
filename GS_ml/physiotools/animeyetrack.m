function animeyetrack(p,usenormed,makeavi)
if nargin<2, usenormed=0; end
if nargin<3, makeavi=0; end

if usenormed
  pX=p.XmCRXn; pY=p.YmCRYn;
else
  pX=p.X; pY=p.Y;
end

n=length(pX)
clf;

scaler=.5;
t=0:.02:2*pi;
X=cos(t).*scaler;
Y=sin(t).*scaler;

minc=min([min(pX) min(pY)]);%
maxc=max([max(pX) max(pY)]);%
%minc=-10;
%maxc=10;
ax=[min(pX),max(pX),min(pY),max(pY)];
%ax=[scaler.*minc, scaler.*maxc, scaler.*minc, scaler.*maxc];

scaledpup=p.NoBlinks-prctile(p.NoBlinks,10);

if makeavi
  mov=avifile('eyetrack.avi','fps',60);
end

for t=1:n
   if usenormed
     plot(pX(t)+scaledpup(t).*X,pY(t)+scaledpup(t).*Y);
     axis([-1 1 -1 1]);
   else
     plot(pX(t)+p.NoBlinks(t).*X,pY(t)+p.NoBlinks(t).*Y);
     axis(ax);
   end
   drawnow;
   if makeavi
     f=getframe(gca);
     mov=addframe(mov,f);
   end
end

if makeavi
  mov=close(mov);
end


