function s=gttests(data,group,outliers,printoutput,doaspaired,getstd)
% usage: s=gttest(data,group,outliers,printoutput,doaspaired,getstd,testvzero)
% where s is a struct containing [t,p,d,df,D,M1,M2]
% if doaspaired, it assumes there is a 1:1 ordered correspondence
% between elements of each group, (e.g., 1 2 1 2 or 1 1 1 2 2 2)
% and does a paired t-test between them.
% with just one group tests all data versus zero
if nargin<2, group = ones(1,size(data,1)); end
if ((nargin<3) | length(outliers==1)), outliers=zeros(size(group)); end
if nargin<4,  printoutput=0; end
if nargin<5, doaspaired=0; end
if nargin<6, getstd=0; end

groups=unique(group);

switch length(groups)
 case 2,
   g1data=gathercondtrials(1,data,group,unique(group),outliers);
   g2data=gathercondtrials(2,data,group,unique(group),outliers);
   Mg1=mean(g1data); Mg2=mean(g2data);
   if doaspaired
     diff=g2data-g1data;
     mdiff=mean(diff); stddiff=std(diff);
     D=mdiff;
     d=mdiff./stddiff;
     t=mdiff./(stddiff./sqrt(length(diff)));
     df=length(diff)-1;
   else
     Ng1=length(g1data); Ng2=length(g2data);
     sp=sqrt(((Ng1-1).*var(g1data)+(Ng2-1).*var(g2data))./(Ng1+Ng2-2));
     D=Mg2-Mg1;
     d=(Mg2-Mg1)./sp;
     t=d.*(1./sqrt((1./Ng1)+(1./Ng2)));
     df=Ng1+Ng2-2;
   end
 case 1,
  g1data=gathercondtrials(1,data,group,1,outliers);
  Mg1=mean(g1data); 
  diff=g1data;
  mdiff=mean(diff); stddiff=std(diff);
  D=mdiff;
  d=mdiff./stddiff;
  t=mdiff./(stddiff./sqrt(length(diff)));
  df=length(diff)-1;
  t=mdiff./(stddiff./sqrt(length(diff)));
  df=length(diff)-1;
 otherwise,
  fprintf('only works with 1 or 2 groups');
  return;
end


p=tcdf(t,df);
p=(t>=0).*(1-p)+(t<0).*p;
%if t>=0, p=1-p; end
p=2.*p; % makes it 2-tailed

if printoutput
   fprintf(1,'t(%d)=%.2f, p=%.2f, D=%.2f, d=%.2f\n',df,t,p,D,d);
end

s.t=t; s.p=p; s.d=d; s.df=df; s.M1=Mg1; 
if length(groups)==2, s.D=D; s.M2=Mg2; end
if getstd, 
  s.SD1=std(g1data);  s.N1=length(g1data);
  if length(groups)==2, s.SD2=std(g2data);   s.SDdiff=sp; s.N2=length(g2data); end
end
