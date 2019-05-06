function avg=getavgr(corr)
% gets an average r value through fisher's r-> transformation
% useage:  avg=getavgr(vec)

zcorr=.5*(log(1+corr)-log(1-corr)); % do fisher's r to z'
avgz=mean(zcorr);
avg=(exp(2*avgz)-1)/(exp(2*avgz)+1); % do fisher's z'->r
