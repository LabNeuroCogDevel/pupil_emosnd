function [s,h]=grpwdifftwavgraph4lines(wav1,group,wav2,samprate,resamprate,alpha,outliers,printts,patches,patchlen,xax,showlegend,pscalemag)
% graphs within subjects contrast for group1 vs group2
% and significance of difference for each 1 second interval
% usage: s=grpwdiffwavgraph(wav1,group,wav2,samprate,resamprate,alpha,outliers,printts)
wavlen=size(wav1,2);
if nargin<4, samprate=62.5; end
if nargin<5, resamprate=samprate; end
if nargin<6, alpha=.05; end
if nargin<7, outliers=zeros(size(group)); end
if nargin<8, printts=0; end
if nargin<9, patches=1; end
if nargin<10, patchlen=10; end
if nargin<11, xax=[1:wavlen]./samprate; end
if nargin<12, showlegend=1; end
if nargin<13, pscalemag=-.05; end

samptoavg=round(samprate/resamprate);
resamppatchlen=floor(patchlen.*(samprate/resamprate));
groups=unique(group);
if length(groups)~=2 
  fprintf('only works with 2 groups');
  return;
end

grpwav1means=pupilcondmeans(wav1,group,unique(group)',outliers);
grpwav2means=pupilcondmeans(wav2,group,unique(group)',outliers);
grpdiffmeans=grpwav2means-grpwav1means;
grpdiffwavs=wav2-wav1;
s=zeros(1,wavlen);
if samprate==resamprate
  for t=1:wavlen
    [tt,s(t)]=gttest(grpdiffwavs(:,t),group,outliers);
  end
else
  for t=1:samptoavg:wavlen
    lt=min(wavlen,t+samptoavg-1);
    [tt,s(t)]=gttest(mean(grpdiffwavs(:,t:lt)')',group,outliers);
    %if ((mr.dr.p~=0) & printts), fprintf('t:%.2f, p: %.2f\n ',t./samprate,s(t)); end;
  end
end

hold on;
if patches
  %sa=s.*(s<alpha);
  sa=pscalemag.*(s<alpha);
  pa=patch([xax(1) xax xax(end)],[0 sa 0],'y');
  set(pa,'EdgeColor','none');
  if alpha>.05
    %sa=s.*(s<.05);
    sa=pscalemag.*(s<.05);
    pa=patch([xax(1) xax xax(end)],[0 sa 0],'r');    
    set(pa,'EdgeColor','none');
  end
else
  s=min(s,.35);
  plot(xax,s,'r');
end
%plot([1:wavlen]./samprate,grpmeans');
%[h]=plot(xax,[grpwav1means;grpwav2means]); set(h,'LineWidth',3);
%[h]=plot(xax,grpwav1means); set(h,'LineWidth',2);
%[h]=plot(xax,grpwav2means,':'); set(h,'LineWidth',3);
%h=plot(xax,grpwav1means,'-',xax,grpwav2means,':'); set(h,'LineWidth',3);

h=plot(xax,grpwav1means(1,:),'b-',xax,grpwav1means(2,:),'g-',xax,grpwav2means(1,:),'b:',xax,grpwav2means(2,:),'g:'); set(h,'LineWidth',3);
if showlegend, legend(h,'Cond1 Group1','Cond1 Group2','Cond2 Group1','Cond2 Group2'); end
plot(xax,zeros(size(s)),'k');
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
    if (ct-sigstart)>=resamppatchlen
      fprintf('%.2f to %.2f: ',xax(sigstart), xax(ct));
      gttest(mean(grpdiffwavs(:,sigstart:ct)')',group,outliers,1);
      % mhreg(mean(wav1(:,sigstart:ct)')',group,mean(wav2(:,sigstart:ct)')',zeros(size(group)),1); 
      hold on;
      pl=line([xax(sigstart)  xax(ct)]',[pscalemag pscalemag]');
      set(pl,'Color',[0 0 0]);
      hold off;
     end
  end
end
if sig
  if (ct-sigstart)>=resamppatchlen
    fprintf('%.2f to %.2f: ',xax(sigstart), xax(ct));
    gttest(mean(grpdiffwavs(:,sigstart:ct)')',group,outliers,1);
      %mhreg(mean(wav1(:,sigstart:ct)')',group,mean(wav2(:,sigstart:ct)')',zeros(size(group)),1); 
  end
end

axis tight;
ax=axis; axis([xax(1) xax(end) ax(3) ax(4)]);
