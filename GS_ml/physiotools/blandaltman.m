function blandaltman(x,y)
% useage: blandaltman(x,y)
% makes graphs to show absolute relationships between 2 variables
% as in Bland & Altman (1986)
   clf;
   hold on;
   mxy=mean([x;y]);
   plot(mxy,(y-x),'r.');
   bias=mean(y-x);
   biasline=mean(y-x).*(ones(1,size(x,2)));
   plot(mxy,biasline,'b-');
   sdline=std(y-x).*(ones(1,size(x,2)));
   plot(mxy,biasline+sdline,'g-');
   plot(mxy,biasline-sdline,'g-');
   hold off
