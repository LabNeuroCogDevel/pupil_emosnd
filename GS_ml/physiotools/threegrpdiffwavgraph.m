function [s,h]=threegrpdiffwavgraph(wavs,group,samprate,resamprate,alpha,outliers,patchlen,bw,covar,pscale,xax,pscalemag)
% graphs group1 vs group2 vs group3
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
if nargin<11, xax=[1:size(wavs,2)]./samprate; end
if nargin<12, pscalemag=-.05; end


if ~xax, xax=[1:size(wavs,2)]./samprate; end
samptoavg=round(samprate/resamprate);

groups=unique(group(find(1-outliers)));
if length(groups)~=3 
  fprintf('only works with 3 groups');
  return;
end

grpmeans=pupilcondmeans(wavs,group,unique(group)',outliers);
grpreg1=2.*((group==groups(2))-.5);
grpreg2=2.*((group==groups(3))-.5);
grpregs=[grpreg1 grpreg2];
s=zeros(1,size(wavs,2));
if samprate==resamprate
  for t=1:size(wavs,2)
    if covar
      mr=mhreg(covar(:,t),grpregs,wavs(:,t),outliers);
      s(t)=mr.dr.p; %tt=sqrt(mr.dr.F); 
    else
      mr=mregs(grpregs,wavs(:,t),outliers);
      s(t)=mr.p;
      % [tt,s(t)]=gttest(wavs(:,t),group,outliers);
    end
  end
else
  for t=1:samptoavg:size(wavs,2)
    lt=min(size(wavs,2),t+samptoavg-1);
    if covar
      mr=mhreg(mean(covar(:,t:lt)')',grpregs,mean(wavs(:,t:lt)')',outliers);
      s(t)=mr.dr.p; % tt=sqrt(mr.dr.F); 
    else
      mr=mregs(grpregs,wavs(:,t),outliers);
      s(t:lt)=mr.p;
      %[tt,s(t:lt)]=gttest(mean(wavs(:,t:lt)')',group,outliers);
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
%  plot(xax,grpmeans(1,:)','k');
%  plot(xax,grpmeans(2,:)','k:');
%  plot(xax,grpmeans(3,:)','k--');
  %set(gca,'ColorOrder',[0 0 0; .6 .6 .6; .8 .8 .8]);
  h=plot(xax,grpmeans(1,:),'k:',xax,grpmeans(2,:),'k',xax,grpmeans(3,:),'k--');  
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
    if (ct-sigstart)>=patchlen
      fprintf('%.2f to %.2f: ',xax(sigstart), xax(ct));
      %gttest(mean(wavs(:,sigstart:ct)')',group,outliers,1);
      mr=mregs(grpregs,wavs(:,sigstart:ct),outliers,0,1);
      hold on;
      pl=line([xax(sigstart)  xax(ct)]',[pscalemag pscalemag]');
      set(pl,'Color',[0 0 0]);
      hold off;
    end
  end
end
if sig
  if (ct-sigstart)>=patchlen
    fprintf('%.2f to %.2f: ',xax(sigstart),xax(ct));
    mr=mregs(grpregs,wavs(:,sigstart:ct),outliers,0,1);
    hold on;
    pl=line([xax(sigstart)  xax(ct)]',[pscalemag pscalemag]');
    set(pl,'Color',[0 0 0]);
    hold off;
  end
end
axis tight;
ax=axis; axis([xax(1) xax(end) ax(3) ax(4)]);
