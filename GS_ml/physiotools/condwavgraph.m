function [s,h]=condwavgraph(condwavs,samprate,resamprate,alpha,outliers,patchlen,bw,pscale,xax)
% graphs conditions vs. each other
% via ANOVA OF ALL N CONDS VIA REPMEAS
% expects 1 3 dimensional matrix:  subjects x conditions x columns
% and significance of difference for each time point
% usage:
% [s,h]=condwavgraph(condwavs,samprate,resamprate,alpha,outliers,patchlen,bw,pscale)
%  condwavgraph(a,60,60,.1,zeros(size(a,1)),17)
if nargin<2, samprate=62.5; end
if nargin<3, resamprate=samprate; end
if nargin<4, alpha=.05; end
if nargin<5, outliers=zeros(size(condwavs,1),1); end
if nargin<6, patchlen=17; end
if nargin<7, bw=0; end
if nargin<8, pscale=10; end

samptoavg=round(samprate/resamprate);
resamppatchlen=floor(patchlen.*(samprate/resamprate));
condmeans=squeeze(mean(condwavs));
wavlen=size(condmeans,2);
wavrange=0:wavlen-1;
s=zeros(1,wavlen);
if nargin<9, 
  xax=[wavrange]./samprate;
end


if samprate==resamprate
  for t=1:wavlen
    stats=repmeas(squeeze(condwavs(:,:,t)),outliers);
    s(t)=stats.p;
  end
else
  for t=1:samptoavg:wavlen
    lt=min(wavlen,t+samptoavg-1);
    stats=repmeas(squeeze(mean(condwavs(:,:,t:lt),3)),outliers);
    s(t:lt)=stats.p;
  end
end

sa=s.*(s<alpha);
if bw
  if pscale<=0
    sa=(s<alpha).*-.05;
    if pscale<0, sa=(sa<0).*pscale; end;
    pa=patch([1 wavrange wavlen]./samprate,[0 sa 0],[0.7 0.7 0.7]);
  else
    pa=patch([1 wavrange wavlen]./samprate,[0 pscale.*sa 0],[0.7 0.7 0.7]);
  end
else
  if pscale<=0
    sa=(s<alpha).*-.05;
    if pscale<0, sa=(sa<0).*pscale; end;
    pa=patch([1 wavrange wavlen]./samprate,[0 sa 0],[1.0 0.7 0.7]);
  else
    pa=patch([1 wavrange wavlen]./samprate,[0 pscale.*sa 0],[1.0 0.7 0.7]);
  end
end
set(pa,'EdgeColor','none');
if alpha>.05
  sa=s.*(s<.05);
  if bw
    if pscale<=0
      sa=(s<.05).*-.05;
      if pscale<0, sa=(sa<0).*pscale; end;
      pa=patch([1 wavrange wavlen]./samprate,[0 sa 0],[0.5 0.5 0.5]);
    else
      pa=patch([1 wavrange wavlen]./samprate,[0 pscale.*sa 0],[0.5 0.5 0.5]);
    end
  else
    if pscale<=0
      sa=(s<.05).*-.05;
      if pscale<0, sa=(sa<0).*pscale; end;
      pa=patch([1 wavrange wavlen]./samprate,[0 sa 0],[1.0 0.5 0.5]);
    else
      pa=patch([1 wavrange wavlen]./samprate,[0 pscale.*sa 0],[1.0 0.5 0.5]);
    end
  end
  set(pa,'EdgeColor','none');
end 
hold on;

if bw
  switch size(condwavs,2)
   case 2, 
     h=plot(xax,squeeze(mean(condwavs(:,1,:))),'k:',xax,squeeze(mean(condwavs(:,2,:))),'k');
     set(h,'LineWidth',3);
   case 3,
     h=plot(xax,squeeze(mean(condwavs(:,1,:))),'k:',xax,squeeze(mean(condwavs(:,2,:))),'k--',xax,squeeze(mean(condwavs(:,3,:))),'k');
     set(h,'LineWidth',3);
   otherwise
    h=plot(xax,squeeze(mean(condwavs))');
    %  plot(xax,condmeans(1,:)','k');
    %  plot(xax,condmeans(2,:)','k:');
    %  if length(wavcond3)>1, plot(xax,condmeans(3,:)','r'); end
  end
else
  h=plot(xax,squeeze(mean(condwavs))');
%  plot(xax,condmeans(1,:)','r');
%  plot(xax,condmeans(2,:)','g');
%  if length(wavcond3)>1, plot(xax,condmeans(3,:)','c'); end
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
      fprintf('%.2f to %.2f: ',sigstart./samprate, ct./samprate');
      repmeas(mean(condwavs(:,:,sigstart:ct),3),outliers,1);
    end
  end
end
if sig
  if (ct-sigstart)>=resamppatchlen
    fprintf('%.2f to %.2f: ',sigstart./samprate, ct./samprate');
    repmeas(mean(condwavs(:,:,sigstart:ct),3),outliers,1);
  end
end
