function [s,h]=reg1persubwavgraph(selfrepindepmeas,wavvals,selfreptopred,samprate,resamprate,alpha,outliers,patchlen,bw,covar,pscale,xax,pscalemag)
% graphs regression R^2 of a 1-per-subject self-report measure with
% a waveform from each subject.
% NOTE: INCLUDES interaction of measure with waveform
% with significance of the correlation marked 
% usage: s=corr1persubwavgraph(selfrepindepmeas,wavvals,selfreptopred,wavvals,samprate,resamprate,alpha,outliers,patchlen,bw,covar,pscale,xax,pscalemag)
if nargin<4, samprate=62.5; end
if nargin<5, resamprate=samprate; end
if nargin<6, alpha=.05; end
if nargin<7, outliers=zeros(size(selfrepmeas,1),1); end
if nargin<8, patchlen=17; end
if nargin<9, bw=0; end
if nargin<10, covar=0; end
if nargin<11, pscale=0; end
if nargin<12, xax=[1:size(wavvals,2)]./samprate; end
if ((length(xax)==1) & (xax==0)), xax=[1:size(wavvals,2)]./samprate; end
if nargin<13, pscalemag=-.05; end



samptoavg=round(samprate/resamprate);
resamppatchlen=floor(patchlen.*(samprate/resamprate));

s=zeros(1,size(wavvals,2));
if samprate==resamprate
  for pt=1:length(wavvals)
    mr=mregs([selfrepindepmeas wavvals(:,pt) (selfrepindepmeas-mean(selfrepindepmeas)).*(wavvals(:,pt)-mean(wavvals(:,pt)))],selfreptopred,outliers);
    rcorr(pt)=r(mr.Ypred,selfreptopred,outliers);
    s(pt)=mr.p;
  end
else
  for t=1:samptoavg:size(corrs,2)
    lt=min(size(corrs,2),t+samptoavg-1);
    curdat=mean(wavvals(:,(t:lt)),2)
    mr=mregs([selfrepindepmeas curdat (selfrepindepmeas-mean(selfrepindepmeas)).*(curdat-mean(curdat))],selfreptopred,outliers);    
    rcorr(t:lt)=r(mr.Ypred,selfreptopred,outliers);
    s(t:lt)=mr.p;
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
  h=plot(xax,rcorr,'k');
else
  h=plot(xax,rcorr);
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
      curdat=mean(wavvals(:,(sigstart:ct)),2);
      mr=mregs([selfrepindepmeas curdat (selfrepindepmeas-mean(selfrepindepmeas)).*(curdat-mean(curdat))],selfreptopred,outliers,0,1);
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
    curdat=mean(wavvals(:,(sigstart:ct)),2);
    mr=mregs([selfrepindepmeas curdat (selfrepindepmeas-mean(selfrepindepmeas)).*(curdat-mean(curdat))],selfreptopred,outliers,0,1);
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
