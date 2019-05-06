function plotscalp(scalp)
% plots a head-model from a 5x5 array of electrodes
% as a surface

figure(1);
plotlayer(scalp);
colormap hot;
shading flat;


%figure(2);
% sphere
%[U,V]=meshgrid(linspace(pi/2,pi,6),linspace(-pi,pi,6));
%X=cos(U).*sin(V);
%Y=cos(U).*cos(V);
%Z=sin(U);
%surf(X,Y,Z,padlr(scalp'));
%shading faceted;
%colormap(hot);
%view(132,76)
