function [s]=getallwaveformts(data,group)
% given a waveform of data for each person
% and which of two groups each person is in,
% does a t-test at each point along the waveform
% and returns the t and p values

g1data=gathercondtrials(1,data,group,unique(group));
g2data=gathercondtrials(2,data,group,unique(group));
Ng1=size(g1data,1); Ng2= size(g2data,1);
s.Mg1=mean(g1data); s.Mg2=mean(g2data); 
sp=sqrt(((Ng1-1).*var(g1data)+(Ng2-1).*var(g2data))./(Ng1+Ng2-2));
s.D=s.Mg1-s.Mg2;
s.d=(s.Mg1-s.Mg2)./sp;
s.ts=s.d.*(1./sqrt((1./Ng1)+(1./Ng2)));
s.df=Ng1+Ng2-2;
s.p=2.*(1-tcdf(abs(s.ts),s.df)); % p values for each row - 2 tailed
