function [minlen]=gsgutsimsbetween(Ng1,Ng2,T,sig,ro,numsims)
% Runs simulations for Guthrie and Buchwald (1991) experiment
% using a simulation method developed by Siegle that
% parallels exactly the tests that will be done.
% usage: [minlen]=gsgutsims(N,T,sig,auto,numsims)
% N is the # subjects per group
% T is the length of the sampling interval
% sig is the significance for each test
% auto is the autocorrelation in the data
% minlen is the minimum run length judged significant
%   that is, the minimum run length that occurs in 
%   less than 5% of simulations
if nargin<5, numsims=1000; end

fprintf('Running gsgutsimbetween(%d,%d,%d,%.2f,%.2f,%d)\n',Ng1,Ng2,T,sig,ro,numsims);

for sim=1:numsims
   wav1=zeros(Ng1,T);   wav2=zeros(Ng2,T);
   for ct=1:Ng1
     wav1(ct,:)=gsrandauto2(T,ro)';
   end
   for ct=1:Ng2
     wav2(ct,:)=gsrandauto2(T,ro)';
   end
   wav1=wav1-repmat(wav1(:,1),1,T);
   wav2=wav2-repmat(wav2(:,1),1,T);
   wav1=wav1(:,2:end);
   wav2=wav2(:,2:end);
   
   Mg1=mean(wav1); Mg2=mean(wav2);
   sp=sqrt(((Ng1-1).*var(wav1)+(Ng2-1).*var(wav2))./(Ng1+Ng2-2));
   d=(Mg1-Mg2)./sp;  tstats=d.*(1./sqrt((1./Ng1)+(1./Ng2)));
   tstats(1)=0;
   df=Ng1+Ng2-2;
   p=2.*(1-tcdf(abs(tstats),df)); % p values for each row - 2 tailed

   % now, get maximum sequence of p<sig
   maxlen(sim)=0;
   startct=0; endct=0;
   for ct=1:length(p)
     if p(ct)<sig
       if startct==0;
	 startct=ct;
       else
	 maxlen(sim)=max(maxlen(sim),1+ct-startct);
       end
     else
       startct=0;
     end
   end
   if mod(sim,100)==0, fprintf('.'); end
end
sortlens=sort(maxlen); % empirical distribution for p<sig;
% now get the run length that occurs for  <5% of trials
minlen=sortlens(round(.95.*numsims));
fprintf('\n');


