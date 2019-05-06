function avgsq=getavgrsq(vec)
% gets an average rsquared value via fisher's r-> transformation
% useage:  avg=getavgrsq(vec)

corr=sqrt(vec);
zcorr=.5*(log(1+corr)-log(1-corr)); % do fisher's r to z'
avgz=mean(zcorr);
avg=(exp(2*avgz)-1)/(exp(2*avgz)+1); % do fisher's z'->r
avgsq=avg.*avg;
