function [s,h]=grpdiffwavgraph(wavs,group,samprate,resamprate,alpha,outliers,patchlen,bw,covar,pscale,xax,pscalemag,thirdgrp,zprimetransf)
% graphs group1 vs group2
% and significance of difference for each 1 second interval
% usage: s=grpdiffwavgraph(wavs,group,samprate,resamprate,alpha,outliers,patchlen,bw,covar)
if nargin<3, samprate=62.5; end
if nargin<4, resamprate=samprate; end
if nargin<5, alpha=.05; end
if nargin<6, outliers=zeros(size(group)); end
if nargin<7, patchlen=17; end
if nargin<8, bw=0; end
if nargin<9, covar=0; end
if nargin<10, pscale=0; end
if ((nargin<11) | (isempty(xax))), xax=[1:size(wavs,2)]./samprate; end
if nargin<12, pscalemag=-.05; end
if nargin<13, thirdgrp=0; end
if nargin<14, zprimetransf=0; end

if length(outliers)==1, outliers=zeros(size(group)); end

samptoavg=round(samprate/resamprate);
resamppatchlen=floor(patchlen.*(samprate/resamprate));

groups=unique(group(find(1-outliers)));
if length(groups)~=2 
  fprintf('needs exactly 2 groups');
  return;
end
if size(prod(thirdgrp),2)>1,
  fprintf('Found third group and plotting it but not using it in calculations');
  grpmeans=pupilcondmeans([wavs; thirdgrp],[group; 3.*ones(size(thirdgrp,1),1)],[groups; 3]',[outliers zeros(1,size(thirdgrp,1))]);
else
  grpmeans=pupilcondmeans(wavs,group,unique(group)',outliers);
end

fprintf('Ngrp1=%d, Ngrp2=%d\n',length(find(group(find(1-outliers))==groups(1))),length(find(group(find(1-outliers))==groups(2))));
s=zeros(1,size(wavs,2));
if samprate==resamprate
  for t=1:size(wavs,2)
    if covar
      mr=mhreg(covar(:,t),group,wavs(:,t),outliers);
      tt=sqrt(mr.dr.F); s(t)=mr.dr.p;
    else
      if zprimetransf
	[tt,s(t)]=gttest(fisherz(wavs(:,t)),group,outliers);
      else
	[tt,s(t)]=gttest(wavs(:,t),group,outliers);
      end      
    end
  end
else
  for t=1:samptoavg:size(wavs,2)
    lt=min(size(wavs,2),t+samptoavg-1);
    if covar
      mr=mhreg(mean(covar(:,t:lt)')',group,mean(wavs(:,t:lt)')',outliers);
      tt=sqrt(mr.dr.F); s(t)=mr.dr.p;
    else
      if zprimetransf
	[tt,s(t:lt)]=gttest(mean(fisherz(wavs(:,t:lt))')',group,outliers);
      else
	if lt-t
	  [tt,s(t:lt)]=gttest(mean(wavs(:,t:lt)')',group,outliers);
	else
	  tt=0; s(t)=1;
	end
      end
    end
  end
end

if pscale
   sa=-pscale.*(s<alpha);
else
   sa=s.*(s<alpha);
end
if bw
  pa=patch([xax(1) xax xax(end)],[0 sa 0],[0.8 0.8 0.8]);
else
  pa=patch([xax(1) xax xax(end)],[0 sa 0],'y');
end
set(pa,'EdgeColor','none');
if pscale
  sa=-pscale.*(s<.05);
else
  sa=s.*(s<.05);
end
if bw
  pa=patch([xax(1) xax xax(end)],[0 sa 0],[0.5 0.5 0.5]);
else
  pa=patch([xax(1) xax xax(end)],[0 sa 0],'r');
end
set(pa,'EdgeColor','none');
hold on;
if bw
  if size(grpmeans,1)==3
    h=plot(xax,grpmeans(1,:),'k:',xax,grpmeans(2,:),'k',xax,grpmeans(3,:),'k--');
  else
    h=plot(xax,grpmeans(1,:),'k:',xax,grpmeans(2,:),'k');
  end
  
  set(h,'LineWidth',3);
else
  h=plot(xax,grpmeans');
end
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
      fprintf('%.2f to %.2fs: ',xax(sigstart), xax(ct));
      if zprimetransf
	gttest(mean(fisherz(wavs(:,sigstart:ct))')',group,outliers,1);
      else
	gttest(mean(wavs(:,sigstart:ct)')',group,outliers,1);
      end
      hold on;
      pl=line([xax(sigstart)  xax(ct)]',[pscalemag pscalemag]');
      set(pl,'Color',[0 0 0]);
      hold off;
    end
  end
end
if sig
  if (ct-sigstart)>=resamppatchlen
    fprintf('%.2f to %.2fs: ',xax(sigstart),xax(ct));
    if zprimetransf
      gttest(mean(fisherz(wavs(:,sigstart:ct))')',group,outliers,1);
    else
      gttest(mean(wavs(:,sigstart:ct)')',group,outliers,1);    
    end
    hold on;
    pl=line([xax(sigstart)  xax(ct)]',[pscalemag pscalemag]');
    set(pl,'Color',[0 0 0]);
    hold off;
  end
end
axis tight;
ax=axis; 
if ax(3)==pscalemag, ax(3)=ax(3)-.025; end
axis([xax(1) xax(end) ax(3) ax(4)]);
