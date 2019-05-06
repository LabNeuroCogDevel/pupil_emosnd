function [minlen]=gsgutsimsgrpwdifft(Ng1,Ng2,T,sig,ro,numsims)
% Runs simulations for Guthrie and Buchwald (1991) experiment
% using a simulation method developed by Siegle that
% parallels exactly the tests that will be done.
% usage: [minlen]=gsgutsimshierarch(Ng1,Ng2,T,sig,ro,numsims)
% N is the # subjects per group
% T is the length of the sampling interval
% sig is the significance for each test
% auto is the autocorrelation in the data
% minlen is the minimum run length judged significant
%   that is, the minimum run length that occurs in 
%   less than 5% of simulations
if nargin<5, numsims=1000; end

group=[zeros(Ng1,1); ones(Ng2,1)];
for sim=1:numsims
   wav1=zeros(Ng1,T);   wav2=zeros(Ng2,T);
   for ct=1:(Ng1+Ng2)
     wav1(ct,:)=gsrandauto2(T,ro)';
     wav2(ct,:)=gsrandauto2(T,ro)';
   end
   wav1=wav1-repmat(wav1(:,1),1,T);
   wav2=wav2-repmat(wav2(:,1),1,T);
   wav1=wav1(:,2:end);
   wav2=wav2(:,2:end);
   Diffwav=wav2-wav1;
   grp = [ones(Ng1,1); 2.*ones(Ng2,1)];
   [ts,p]=getallwaveformts(Diffwav,grp); % get t-tests along a given permutation

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


