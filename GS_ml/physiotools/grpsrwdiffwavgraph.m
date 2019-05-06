function s=grpsrwdiffwavgraph(wav1,group,wav2,covariates,samprate,resamprate,alpha,outliers,printts,patches,patchlen)
% graphs within subjects contrast for group1 vs group2
% and significance of difference for each 1 second interval
% usage: s=grpwdiffwavgraph(wav1,group,wav2,samprate,resamprate,alpha,outliers,printts)
if nargin<5, samprate=62.5; end
if nargin<6, resamprate=samprate; end
if nargin<7, alpha=.05; end
if nargin<8, outliers=zeros(size(group)); end
if nargin<9, printts=0; end
if nargin<10, patches=1; end
if nargin<11, patchlen=10; end

samptoavg=round(samprate/resamprate);
wavlen=size(wav1,2);
groups=unique(group);
if length(groups)~=2 
  fprintf('only works with 2 groups');
  return;
end

grpwav1means=pupilcondmeans(wav1,group,unique(group)',outliers);
grpwav2means=pupilcondmeans(wav2,group,unique(group)',outliers);
grpmeans=grpwav2means-grpwav1means;
s=zeros(1,wavlen);
if samprate==resamprate
  for t=1:wavlen
    mr=mhreg([wav1(:,t) covariates],group,wav2(:,t),outliers);
    s(t)=mr.dr.p;
  end
else
  for t=1:samptoavg:wavlen
    lt=min(wavlen,t+samptoavg-1);
    mr=mhreg([mean(wav1(:,t:lt)')' covariates],group,mean(wav2(:,t:lt)')'); 
    s(t:lt)=mr.dr.p;
    if ((mr.dr.p~=0) & printts), fprintf('t:%.2f, p: %.2f\n ',t./samprate,s(t)); end;
  end
end


plot([1:wavlen]./samprate,zeros(size(s)),'k');
hold on;
if patches
  sa=s.*(s<alpha);
  pa=patch([1 1:wavlen wavlen]./samprate,[0 sa 0],'y');
  set(pa,'EdgeColor','none');
  if alpha>.05
    sa=s.*(s<.05);
    pa=patch([1 1:wavlen wavlen]./samprate,[0 sa 0],'r');    
    set(pa,'EdgeColor','none');
  end
else
  s=min(s,.35);
  plot([1:wavlen]./samprate,s,'r');
end
plot([1:wavlen]./samprate,zeros(size(s)),'k');
plot([1:wavlen]./samprate,grpmeans');
%plot([1:wavlen]./samprate,[grpwav2means;grpwav1means]);
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
      mhreg(mean(wav1(:,sigstart:ct)')',group,mean(wav2(:,sigstart:ct)')',zeros(size(group)),1); 
    end
  end
end
if sig
  if (ct-sigstart)>=patchlen
    fprintf('%.2f to %.2f: ',sigstart./samprate, ct./samprate');
      mhreg(mean(wav1(:,sigstart:ct)')',group,mean(wav2(:,sigstart:ct)')',zeros(size(group)),1); 
  end
end

