function [minlen]=gsgutsimsvconst(N,T,sig,ro,numsims)
% Runs Guthrie and Buchwald (1991) style simulations
% for correlation of a single value per subject with
% a difference waveform using a simulation method 
% developed by Siegle that parallels exactly the tests 
% that will be done.
% usage: [minlen]=gsgutsimsvconst(N,T,sig,auto,numsims)
% N is the # subjects per group
% T is the length of the sampling interval
% sig is the significance for each test
% auto is the autocorrelation in the data
% minlen is the minimum run length judged significant
%   that is, the minimum run length that occurs in 
%   less than 5% of simulations
if nargin<5, numsims=1000; end


for sim=1:numsims
   wav1=zeros(N,T);   wav2=zeros(N,T);
   for ct=1:N
     wav1(ct,:)=randauto(T,ro)';
     wav2(ct,:)=randauto(T,ro)';
   end
   Diffwav=wav2-wav1;
   meas=rand(N,1);
   for ct=1:T
     rs(ct)=r(Diffwav(:,ct),meas);
   end
   tstats=(rs.*sqrt(N-2))./(sqrt(1-rs.*rs));
   p=1-tcdf(abs(tstats),N-2); % p values for each row

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
end
sortlens=sort(maxlen); % empirical distribution for p<sig;
% now get the run length that occurs for  <5% of trials
minlen=sortlens(round(.95.*numsims));


