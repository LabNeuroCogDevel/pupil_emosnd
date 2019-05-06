function s=corrwavgraph(corrsraw,samprate,resamprate,alpha,outliers,patchlen,bw,covar,pscale,xax,pscalemag)
% graphs mean correlation from each subject's correlations,
% and significance of difference for each 1 second interval
% usage: s=corrwavgraph(wavs,group,samprate,resamprate,alpha,outliers,patchlen,bw,covar)
if nargin<2, samprate=62.5; end
if nargin<3, resamprate=samprate; end
if nargin<4, alpha=.05; end
if nargin<5, outliers=zeros(size(corrsraw,1),1); end
if nargin<6, patchlen=17; end
if nargin<7, bw=0; end
if nargin<8, covar=0; end
if nargin<9, pscale=0; end
if nargin<10, xax=[1:size(corrsraw,2)]./samprate; end
if nargin<11, pscalemag=-.05; end

%samprate=60; resamprate=60; alpha=.1; outliers=zeros(size(corrs,1),1); patchlen=17; bw=0; covar=0; pscale=.05; xax=[1:size(corrs,2)]./samprate; pscalemag=-0.05;

samptoavg=round(samprate/resamprate);
resamppatchlen=floor(patchlen.*(samprate/resamprate));

corrs=corrsraw(find(1-outliers),:);
corrsz=fisherz(corrs);

grpmeans=mean(corrs);
s=zeros(1,size(corrs,2));
if samprate==resamprate
  [tt,s]=gonesampttest(corrsz,0);
else
  for t=1:samptoavg:size(corrs,2)
    lt=min(size(corrs,2),t+samptoavg-1);
    [tt,s(t:lt)]=gonesampttest(mean(corrsz(:,t:lt)')',0);
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
  plot(xax,grpmeans(1,:)','k');
  plot(xax,grpmeans(2,:)','k:');
else
  plot(xax,grpmeans');
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
      fprintf('%.2f to %.2f: ',xax(sigstart), xax(ct));
      gonesampttest(mean(corrsz(:,sigstart:ct)')',0,zeros(size(corrsz,1),1),1);
      hold on;
      pl=line([xax(sigstart)  xax(ct)]',[pscalemag pscalemag]');
      set(pl,'Color',[0 0 0]);
      hold off;
    end
  end
end
if sig
  if (ct-sigstart)>=resamppatchlen
    fprintf('%.2f to %.2f: ',xax(sigstart),xax(ct));
    gttest(mean(corrs(:,sigstart:ct)')',0,zeros(size(corrs),1));
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
