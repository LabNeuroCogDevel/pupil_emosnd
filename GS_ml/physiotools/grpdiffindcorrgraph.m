function [s,h]=grpdiffindcorrgraph(wavs,n1,n2,samprate,resamprate,alpha,patchlen,bw,pscale,xax,pscalemag,thirdgrp)
% graphs group1 vs group2
% note: unlike all the other difference testing procedures this graphs
%  differences along 2 correlation waveforms - so wavs is 2 rows long - one for each group
% and significance of difference for each 1 second interval
% usage: [s,h]=grpdiffindcorrgraph(wavs,n1,n2,samprate,resamprate,alpha,patchlen,bw,pscale,xax,pscalemag,thirdgrp)
if nargin<4, samprate=62.5; end
if nargin<5, resamprate=samprate; end
if nargin<6, alpha=.05; end
if nargin<7, patchlen=17; end
if nargin<8, bw=0; end
if nargin<9, pscale=0.05; end
if ((nargin<10) | (isempty(xax))), xax=[1:size(wavs,2)]./samprate; end
if nargin<11, pscalemag=-.05; end
if nargin<12, thirdgrp=0; end

samptoavg=round(samprate/resamprate);
resamppatchlen=floor(patchlen.*(samprate/resamprate));

if size(prod(thirdgrp),2)>1,
  fprintf('Found third group and plotting it but not using it in calculations');
  grpmeans=[wavs;thirdgrp];
else
  grpmeans=wavs;
end


zp1=fisherz(wavs(1,:));
zp2=fisherz(wavs(2,:));



s=zeros(1,size(wavs,2));
if samprate==resamprate
  z=(zp1-zp2)./sqrt((1./(n1-3))+(1./(n2-3)));
  s=2.*(.5-abs(.5-(normcdf(z))));
else
  for t=1:samptoavg:size(wavs,2)
    lt=min(size(wavs,2),t+samptoavg-1);
    if lt-t
      z=(zp1(t:lt)-zp2(t:lt))./sqrt((1./(n1-3))+(1./(n2-3)));
      s(t:lt)=2.*(.5-abs(.5-(normcdf(z))));
    else
      tt=0; s(t)=1;
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
      zn=(zp1(sigstart:ct)-zp2(sigstart:ct))./sqrt((1./(n1-3))+(1./(n2-3)));
      sn=2.*(.5-abs(.5-(normcdf(zn))));
      fprintf('Z=%.2f, p=%.2f\n',mean(zn),mean(sn));
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
    zn=(zp1(sigstart:ct)-zp2(sigstart:ct))./sqrt((1./(n1-3))+(1./(n2-3)));
    sn=2.*(.5-abs(.5-(normcdf(zn))));
    fprintf('Z=%.2f, p=%.2f\n',mean(zn),mean(sn));
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
