function leg=legendskipfirsttwo(varargin)


numargs=length(varargin);

%set(l.objecth(7),'Xdata',[0;0;0;0])
[leg.h,leg.objecth,leg.ploth,leg.textstrh] = legend(varargin);
