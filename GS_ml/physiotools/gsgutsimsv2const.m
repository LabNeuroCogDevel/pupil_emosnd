function [alphas]=gsgutsimsv2const(N,T,sig,ro,numsims,minlen,qmatrix)
% Runs Guthrie and Buchwald (1991) style simulations
% for correlation of a single value per subject with
% a difference waveform using a simulation method 
% developed by Siegle that parallels exactly the tests 
% that will be done.
% usage: [minlen]=gutsims(N,T,sig,auto,numsims)
% N is the # subjects per group
% T is the length of the sampling interval
% sig is the significance for each test
% auto is the autocorrelation in the data
% minlen is the minimum run length judged significant
%   that is, the minimum run length that occurs in 
%   less than 5% of simulations
% alpha2 is the proportion of time 2 sequences were both
% significant
% alpha1 is the proportion of times 1 sequence was significant
if nargin<5, numsims=1000; end
if nargin<6, dosims=1; 
else dosims=0;
end
if nargin<7,qmatrix=0; end
if dosims
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
end

for sim=1:numsims
   wav1=zeros(N,T);   wav2=zeros(N,T);
   for ct=1:N
     wav1(ct,:)=randauto(T,ro)';
     wav2(ct,:)=randauto(T,ro)';
   end
   Diffwav=wav2-wav1;
   if qmatrix
     people=randperm(size(qmatrix,1));
     people=people(1:N);
     for quesnum=1:size(qmatrix,2)
       for ct=1:T
	 rs(ct,quesnum)=r(Diffwav(:,ct),qmatrix(people,quesnum));
       end
     end
     tstats=(rs.*sqrt(N-2))./(sqrt(1-rs.^2));
     p=1-tcdf(abs(tstats),N-2); % p values for each row
   
     % now, get maximum sequence of p<sig
     numseqs(sim)=0; num2seqs(sim)=0; num3seqs(sim)=0; num4seqs(sim)=0;
     inseq=0; in2seq=0; in3seq=0; in4seq=0;
     for ct=1:(length(p)-minlen)
       maxps=sort(max(p(ct:ct+minlen,:)));
       if maxps(1)<sig
	 if inseq==0
	   inseq=1;
	   numseqs(sim)=1; %numseqs(sim)+1;
	 else
	   inseq=0;
	 end
       end
       if ((maxps(1)<sig) & (maxps(2)<sig))
	 if in2seq==0
	   in2seq=1;
	   num2seqs(sim)=1; %num2seqs(sim)+1;
	 else
	   in2seq=0;
	 end
       end
       if ((maxps(1)<sig) & (maxps(2)<sig) & maxps(3)<sig)
	 if in3seq==0
	   in3seq=1;
	   num3seqs(sim)=1; 
	 else
	   in3seq=0;
	 end
       end
       if ((maxps(1)<sig) & (maxps(2)<sig) & (maxps(3)<sig) & maxps(4)<sig)
	 if in4seq==0
	   in4seq=1;
	   num4seqs(sim)=1; 
	 else
	   in4seq=0;
	 end
       end
     end
   alpha1=mean(numseqs);
   alpha2=mean(num2seqs);
   alpha3=mean(num3seqs);
   alpha4=mean(num4seqs);
   alphas=[alpha1 alpha2 alpha3 alpha4];
   else
     meas=rand(N,1);    meas2=rand(N,1);
     for ct=1:T
       rs(ct)=r(Diffwav(:,ct),meas);
       rs2(ct)=r(Diffwav(:,ct),meas2);
     end
     tstats=(rs.*sqrt(N-2))./(sqrt(1-rs.*rs));
     p=1-tcdf(abs(tstats),N-2); % p values for each row
     tstats2=(rs2.*sqrt(N-2))./(sqrt(1-rs2.*rs2));
     p2=1-tcdf(abs(tstats2),N-2); % p values for each row

     % now, get maximum sequence of p<sig
     numseqs(sim)=0;
     num2seqs(sim)=0;
     inseq=0; in2seq=0;
     for ct=1:(length(p)-minlen)
       if max(p(ct:ct+minlen))<sig
	 if inseq==0
	   inseq=1;
	   numseqs(sim)=1; %numseqs(sim)+1;
	 else
	   inseq=0;
	 end
       end
       if ((max(p(ct:ct+minlen))<sig) & (max(p2(ct:ct+minlen))<sig))
	 if in2seq==0
	   in2seq=1;
	   num2seqs(sim)=1; %num2seqs(sim)+1;
	 else
	   in2seq=0;
	 end
       end
     end
     alpha1=mean(numseqs);
     alpha2=mean(num2seqs);
     alphas=[alpha1 alpha2 ];
   end
end
