function [minlen]=gsgutsims3conds(N,T,sig,ro,numsims)
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

fprintf('Running gsgutsims3conds(%d,%d,%.2f,%.2f,%d)\n',N,T,sig,ro,numsims);

for sim=1:numsims
   wav1=zeros(N,T);   wav2=zeros(N,T);
   for ct=1:N
     %wav1(ct,:)=gsrandauto2(T,ro)'; % skew-corrected estimates
     %wav2(ct,:)=gsrandauto2(T,ro)'; % skew-corrected estimates
     %wav1(ct,:)=gsrandauto(T,ro)'; % my estimates which are sometimes low
     %wav2(ct,:)=gsrandauto(T,ro)';
     wav1(ct,:)=randauto(T,ro)';    % strauss's estimates which are sometimes low
     wav2(ct,:)=randauto(T,ro)';
     wav3(ct,:)=randauto(T,ro)';     
   end
   wav1=wav1-repmat(wav1(:,1),1,T);
   wav2=wav2-repmat(wav2(:,1),1,T);
   wav3=wav3-repmat(wav3(:,1),1,T);
   

   condwavs(:,1,:)=wav1;
   condwavs(:,2,:)=wav2;
   condwavs(:,3,:)=wav3;
   
   for t=1:T
     stats=repmeas(squeeze(condwavs(:,:,t)));
     p(t)=stats.p;
   end

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


