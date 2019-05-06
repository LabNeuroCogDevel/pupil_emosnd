function [minlen]=gsgutsims(N,T,sig,ro,numsims)
% Runs simulations for Guthrie and Buchwald (1991) experiment
% using a simulation method developed by Siegle that
% parallels exactly the tests that will be done.
% usage: [minlen]=gsgutsims(N,T,sig,auto,numsims)
% N is the # subjects per group
% T is the length of the sampling interval
%SO: T must be an integer; I believe it is the number of samples per trial
%(aka number of columns in data matrix)
% sig is the significance for each test
% auto is the autocorrelation in the data
% minlen is the minimum run length judged significant
%   that is, the minimum run length that occurs in 
%   less than 5% of simulations
if nargin<5, numsims=1000; end

fprintf('Running gsgutsimbetween(%d,%d,%.2f,%.2f,%d)\n',N,T,sig,ro,numsims);

for sim=1:numsims
   wav1=zeros(N,T);   wav2=zeros(N,T);
   for ct=1:N
     %SO: GS was originally using Randauto but didn't work so I switched
     wav1(ct,:)=gsrandauto2(T,ro)'; % skew-corrected estimates
     wav2(ct,:)=gsrandauto2(T,ro)'; % skew-corrected estimates
     %wav1(ct,:)=gsrandauto(T,ro)'; % my estimates which are sometimes low
     %wav2(ct,:)=gsrandauto(T,ro)';
     % SO: from strauss's website:
     % randauto - random vector of autocorrelated uniform random numbers
     % I googled and saved Randauto.m, but it didn't work, so I deleted if.
     % If needed, it can be found @:
     % http://cuip.net/~dloquinte/researchfiles/downloaded%20matlab%20codes/matlabv5%20library/Res/Randauto.m
     %wav1(ct,:)=Randauto(T,ro)';    % strauss's estimates which are sometimes low
     %wav2(ct,:)=Randauto(T,ro)';
   end
   wav1=wav1-repmat(wav1(:,1),1,T);
   wav2=wav2-repmat(wav2(:,1),1,T);
   Diffwav=wav2-wav1;
   Diffwav(:,1)=Diffwav(:,2);
   tstats=mean(Diffwav)./se(Diffwav); % t statistics for each row
   p=2.*(1-tcdf(abs(tstats),N-2)); % p values for each row - 2 tailed

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
minlen=sortlens(floor(.95.*numsims));


