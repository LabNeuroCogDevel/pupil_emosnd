function [t,p,df,M]=gonesampttest(data,k,outliers,printoutput)
% usage: [t,p,df,M]=gonesampttest(data,k,outliers,printoutput)
% assumes outliers coded 0 and 1
if nargin<2, k=0; end
if nargin<3, outliers=zeros(size(data,2),1); end
if nargin<4, printoutput=0; end

%SO: aka if there are no outliers
if length(unique(outliers))==1
  gooddata=data;
else
  gooddata=gathercondtrials(2,data,outliers);
end

Mgd=mean(gooddata); 
if min(size(gooddata))>1, 
  Ng=size(gooddata,1);
else
  Ng=length(gooddata);
end

df=Ng-1;
D=Mgd-k;
d=0;
if length(unique(data))==1
  t=0; p=1;
else  
  ser = std(gooddata) ./ sqrt(Ng);
  d=D./std(gooddata);
  t = (Mgd - k) ./ ser;
  nans=find(isnan(t));
  t(nans)=0;
  p = tcdf(t,df);
  p=(t<0).*p + (t>=0).*(1-p);
end

p=p.*2; % for 2-sample ttest

if printoutput
   fprintf(1,'t(%d)=%.2f, p=%.2f, D=%.2f, d=%.2f\n',df,t,p,D,d);
end


%   p=2.*(1-tcdf(abs(tstats),N-2)); % p values for each row - 2 tailed
