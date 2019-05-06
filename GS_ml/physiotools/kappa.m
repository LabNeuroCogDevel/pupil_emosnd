function k=kappa (rat1,rat2)
% Cohen's kappa is (agreement-agreebychance)/(1-agreebychance)
% usage: k=kappa(rat1,rat2)
% where rat1 and rat2 are discrete columnar rating vectors
% rat1=[1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2]';
% rat2=[1 1 1 1 1 1 1 2 2 2 2 2 2 2 1 1]';
% 

classes=union(unique(rat1),unique(rat2));

N=length(rat1);
for m=1:length(classes)
  agree(m)=sum((rat1==classes(m)) & (rat2==classes(m)));
  chance(m)=sum(rat1==classes(m)).*sum(rat2==classes(m));
end
propagree=sum(agree)./N;
%propagree=sum(rat1==rat2)./N;
propexpected=sum(chance)./(N.*N);
k=(propagree-propexpected)./(1-propexpected);
