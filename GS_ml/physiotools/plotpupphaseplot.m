function plotpupphaseplot(p);

% %%%%%%%%%%%%%%%
% nice on 5111
figure;
clf;
colormap copper;
subplot(2,1,1);
X=[p.NoBlinksUnsmoothed(10001:18000-15) p.NoBlinksUnsmoothed(10016:18000) p.NoBlinksUnsmoothed(10031:18000+15)];
[U,S,V]=svd(X,0);
r=X*V;
curve3(r(:,1),r(:,2),r(:,3))
view(0,90);
title('unsmoothed');

subplot(2,1,2);
X=[p.NoBlinks(10001:18000-15) p.NoBlinks(10016:18000) p.NoBlinks(10031:18000+15)];
[U,S,V]=svd(X,0);
r=X*V;
curve3(r(:,1),r(:,2),r(:,3))
view(0,90);
title('smoothed');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% experiments
%imnum=1;
%for ct=0:5:360
%  view(ct,0);
%  axis tight;
%  axis equal;
%  axis off;
%  drawnow;
%  fr(imnum)=getframe(gcf);
%  imnum=imnum+1;
%end



% X=[p.NoBlinks(1:end-15) p.NoBlinks(16:end)];
% [U,S,V]=svd(X);

% X=[p.NoBlinks(1:end-15) p.NoBlinks(16:end)];
% [U,S,V]=svd(X);

% X=[p.NoBlinks(1:8000-15) p.NoBlinks(16:8000)];
% [U,S,V]=svd(X,0);
% r=X*V;
% plot(r(:,1),r(:,2))


% X=[p.NoBlinks(1:8000-15) p.NoBlinks(16:8000) p.NoBlinks(31:8000+15)];
% [U,S,V]=svd(X,0);
% r=X*V;
% curve3(r(:,1),r(:,2),r(:,3))

% %%%%%%%%%%%%%%%
% % nice on 5111
% X=[p.NoBlinksUnsmoothed(1:8000-15) p.NoBlinksUnsmoothed(16:8000) p.NoBlinksUnsmoothed(31:8000+15)];
% [U,S,V]=svd(X,0);
% r=X*V;
% curve3(r(:,1),r(:,2),r(:,3))
% view(0,90);

X=[p.NoBlinksUnsmoothed(1001:9000-15) p.NoBlinksUnsmoothed(1016:9000) p.NoBlinksUnsmoothed(1031:9000+15)];
[U,S,V]=svd(X,0);
r=X*V;
curve3(r(:,1),r(:,2),r(:,3))
view(0,90);

% X=[p.NoBlinksUnsmoothed(10001:19000-15) p.NoBlinksUnsmoothed(10016:19000) p.NoBlinksUnsmoothed(10031:19000+15)];
% [U,S,V]=svd(X,0);
% r=X*V;
% curve3(r(:,1),r(:,2),r(:,3))
% view(0,90);

% X=[p.NoBlinksUnsmoothed(10001:19000-2) p.NoBlinksUnsmoothed(10003:19000) p.NoBlinksUnsmoothed(10005:19000+2)];
% [U,S,V]=svd(X,0);
% r=X*V;
% curve3(r(:,1),r(:,2),r(:,3))
% view(0,90);



% X=[p.NoBlinks(10001:19000-15) p.NoBlinks(10016:19000) p.NoBlinks(10031:19000+15)];
% [U,S,V]=svd(X,0);
% r=X*V;
% curve3(r(:,1),r(:,2),r(:,3))
% view(0,90);

% %%%% also nice
% X=[p.NoBlinksUnsmoothed(1:8000-25) p.NoBlinksUnsmoothed(26:8000) p.NoBlinksUnsmoothed(51:8000+25)];
% [U,S,V]=svd(X,0);
% r=X*V;
% curve3(r(:,1),r(:,2),r(:,3))
% view(0,90);




% downsample the nice thing
% X=[p.NoBlinksUnsmoothed(1:10:8000-25) p.NoBlinksUnsmoothed(26:10:8000) p.NoBlinksUnsmoothed(51:10:8000+25)];
% [U,S,V]=svd(X,0);
% r=X*V;
% curve3(r(:,1),r(:,2),r(:,3))
% view(0,90);




% plot(autocorr(p.NoBlinksUnsmoothed(1:8015),[1:20]))

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xn=randauto(8000,.9995);
% Xnt=[Xn(1:end-15) Xn(16:end)];
% [U,S,V]=svd(Xnt,0);
% r=Xnt*V;
% plot(r(:,1),r(:,2))

% % smoothed *****************
% Xn=randauto(8015,.9995);
% Xn=dbfilter(Xn',5)';
% Xnt=[Xn(1:8000-15) Xn(16:8000) Xn(31:8000+15)];
% [U,S,V]=svd(Xnt,0);
% rn=Xnt*V;
% curve3(rn(:,1),rn(:,2),rn(:,3))


% % smoothed
% Xn=randauto(8015,.9995);
% Xn=dbfilter(Xn',5)';
% Xnt=[Xn(1:10:8000-15) Xn(16:10:8000) Xn(31:10:8000+15)];
% [U,S,V]=svd(Xnt,0);
% rn=Xnt*V;
% curve3(rn(:,1),rn(:,2),rn(:,3))

% % unsmoothed
% Xn=randauto(8015,.998);
% Xnt=[Xn(1:8:8000-7) Xn(8:8:8000) Xn(15:8:8000+7)];
% [U,S,V]=svd(Xnt,0);
% rn=Xnt*V;
% curve3(rn(:,1),rn(:,2),rn(:,3))
% view(0,90);

