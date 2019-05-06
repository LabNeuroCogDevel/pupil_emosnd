function s=grpsrdiffwavgraph(wavs,group,covariates,samprate,resamprate,alpha,outliers,patchlen,bw)
% graphs group1 vs group2
% and significance of difference for each 1 second interval
% usage: s=grpdiffwavgraph(wavs,group,samprate,resamprate,alpha,outliers,printts)
if nargin<4, samprate=62.5; end
if nargin<5, resamprate=samprate; end
if nargin<6, alpha=.05; end
if nargin<7, outliers=zeros(size(group)); end
if nargin<8, patchlen=17; end
if nargin<9, bw=0; end

samptoavg=round(samprate/resamprate);

groups=unique(group);
if length(groups)~=2 
  fprintf('only works with 2 groups');
  return;
end

grpmeans=pupilcondmeans(wavs,group,unique(group)',outliers);
s=zeros(1,size(wavs,2));
if samprate==resamprate
  for t=1:size(wavs,2)
    mr=mhreg(covariates,group,wavs(:,t),outliers); s(t)=mr.dr.p;
  end
else
  for t=1:samptoavg:size(wavs,2)
    lt=min(size(wavs,2),t+samptoavg-1);
    mr=mhreg(covariates,group,mean(wavs(:,t:lt)),outliers); 
    s(t:lt)=mr.dr.p;
    % if printts, fprintf('%.2f=%.2f ',t,s(t)); end;
  end
end

sa=s.*(s<alpha);
if bw
  pa=patch([1 1:size(wavs,2) size(wavs,2)]./samprate,[0 sa 0],[0.8 0.8 0.8]);
else
  pa=patch([1 1:size(wavs,2) size(wavs,2)]./samprate,[0 sa 0],'y');
end
set(pa,'EdgeColor','none');
if alpha>.05
  sa=s.*(s<.05);
  if bw
    pa=patch([1 1:size(wavs,2) size(wavs,2)]./samprate,[0 sa 0],[0.5 0.5 0.5]);
  else
    pa=patch([1 1:size(wavs,2) size(wavs,2)]./samprate,[0 sa 0],'r');
  end
  set(pa,'EdgeColor','none');
end 
hold on;
if bw
  plot([1:size(wavs,2)]./samprate,grpmeans(1,:)','k');
  plot([1:size(wavs,2)]./samprate,grpmeans(2,:)','k:');
else
  plot([1:size(wavs,2)]./samprate,grpmeans');
end
plot([1:size(wavs,2)]./samprate,zeros(size(s)),'k');
hold off

% now, do significance tests of large patches
sig=0; sigstart=0;
for ct=1:length(s)
  if ((sig==0) & (s(ct)<alpha)), 
    sigstart=ct; 
    sig=1; 
  end
  if (sig & (s(ct)>=alpha)), 
    sig=0; 
    if (ct-sigstart)>=patchlen
      fprintf('%.2f to %.2f: ',sigstart./samprate, ct./samprate');
      gttest(mean(wavs(:,sigstart:ct)')',group,outliers,1);
    end
  end
end
if sig
  if (ct-sigstart)>=patchlen
    fprintf('%.2f to %.2f: ',sigstart./samprate, ct./samprate');
    gttest(mean(wavs(:,sigstart:ct)')',group,outliers,1);
  end
end
