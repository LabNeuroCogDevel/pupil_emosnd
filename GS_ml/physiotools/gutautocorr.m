function [acorr,kmin]=gutautocorr(X,k)
% gets autocorrelation with SVD removed
% for Buchwald-Guthrie (1992) style estimation
% of minimum run length for significance
% X is an N x T matrix (difference waveforms
% within one group and pooled over both samples
% for two groups)
% usage: [acorr,kmin]=gutautocorr(X,k)
% where k is the minimum eigan value from the
% svd that should be used. By default, k=5.
% With k=0, all possible k (to #rows in X)
% are used and the minimum available autocorrelation
% is returned.
% With k=-1 no svd is performed.
% Note that choice of k matters: see via:
% for ct=1:100
%  ga(ct)=gutautocorr(Z,ct);
% end
% plot(ga)

% a note on choosing K:
%   They kinda gloss over this in Guthrie et al.
%   k is how many principal components you believe, deep in your heart,
%   will reflect signal in the dataset, because you don't want to penalize
%   for autocorrelation due to signal-related responses.
%     My general approach has been to do a PCA on my data and see how many
%   factors account for about 75% of the variance, and have reasonable
%   looking temporal structure.
%     Oddly, and in general, I've found that 5 is a good number. But that's not
%   a principled answer....
%   The tricky part is that if you take out more components
%    than are really warranted you'll get too short an interval and
%    be subject to type 1 error. But if you take out too few the
%    interval will be too large, and you'll get type 2 error....

if nargin<2, k=5; end

if k>0
  acorr=gtautoatk(X,k);
  kmin=k;
elseif k<0
 for ct=1:size(X,1)
   acorrs(ct)=autocorr(X(ct,:),1);
 end
 acorr=mean(acorrs);
else
  for ct=1:size(X,1)
    acorrs(ct)=gtautoatk(X,ct);
  end
  [acorr,kmin]=min(acorrs);
end



function acorr=gtautoatk(X,k)

Xnomean=X-repmat(mean(X),size(X,1),1);
[L,G,R] = svd(Xnomean,0);
Ls=L(:,1:k); Gs=G(1:k,1:k); Rs=R(:,1:k);
Xs=Ls*Gs*Rs';
Xn=Xnomean-Xs;

for ct=1:size(X,1)
   acorrs(ct)=autocorr(Xn(ct,:),1);
end
acorr=mean(acorrs);
