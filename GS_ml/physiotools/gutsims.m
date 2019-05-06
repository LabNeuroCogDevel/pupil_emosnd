function [minlen]=gutsims(N,T,sig,ro,numsims)
% Runs simulations for Guthrie and Buchwald (1991) experiment
% The text of comments in this routine is taken directly from
%    Guthrie and Buchwald (1991)
% usage: [minlen]=gutsims(N,T,sig,auto)
% N is the # subjects per group
% T is the length of the sampling interval
% sig is the significance for each test
% auto is the autocorrelation in the data
% minlen is the minimum run length judged significant
%   that is, the minimum run length that occurs in 
%   less than 5% of simulations
% NOTE: THIS DOESN'T SEEM TO WORK. USE GSGUTSIMS FOR NOW.
if nargin<5, numsims=1000; end

% first generate the autocorrelation matrix
R=eye(T); % let R designate a TxT matrix with 1 on the diagonal
for k=1:T %   with ro^k in the kth position removed from the diagonal
  R(k,k)=1-ro.^(T-k+1); % (was ro^k...)
end       % now R is the correlation matrix of a first-order
          % autoregressive series with autocorrelation ro
A=sqrtm(R); % R=AA'

%Y=normrnd(0,1,T,1);
% AY is a Tx1 random normal vector whose components have
% a correlation matrix given by R
% PROBLEM? - AY has low autocorrelation

for sim=1:numsims      % do 1000 simulations
   Y=normrnd(0,1,T,N); % normal random matrix
   Y=Y+abs(min(min(Y)));
   X=A*Y;              % vectors whose components have correlation matrix R
   tstats=mean(X')./se(X'); % t statistics for each row
   p=1-tcdf(abs(tstats),N); % p values for each row

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

function stderr=se(X)
% computes the standard error of X
% usage: stderr=ste(X)
stderr=std(X)./sqrt(size(X,1));
