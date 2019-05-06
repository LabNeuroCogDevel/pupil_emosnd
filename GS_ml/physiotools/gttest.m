function [t,p,d,df,D]=gttest(data,group,outliers,printoutput)
% usage: [t,p,d,df,D]=gttest(data,group,outliers,printoutput)
if nargin<3
  outliers=zeros(size(group));
end
if nargin<4
   printoutput=0;
end
groups=unique(group);
if length(groups)~=2 
  fprintf('only works with 2 groups');
  return;
end
g1data=gathercondtrials(1,data,group,unique(group),outliers);
g2data=gathercondtrials(2,data,group,unique(group),outliers);
Mg1=mean(g1data); Mg2=mean(g2data);
Ng1=length(g1data); Ng2=length(g2data);
sp=sqrt(((Ng1-1).*var(g1data)+(Ng2-1).*var(g2data))./(Ng1+Ng2-2));
D=Mg1-Mg2;
d=(Mg1-Mg2)./sp;
t=d.*(1./sqrt((1./Ng1)+(1./Ng2)));
df=Ng1+Ng2-2;
if t>-Inf
  p=tcdf(t,df); 
else
  p=1;
end
if t>=0
  p=1-p;
end

p=p.*2; % note: change made it 2-tailed

if printoutput
   fprintf(1,'t(%d)=%.2f, p=%.2f, D=%.2f, d=%.2f\n',df,t,p,D,d);
end
