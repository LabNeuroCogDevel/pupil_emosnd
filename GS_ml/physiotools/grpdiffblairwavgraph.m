function s=grpdiffblairwavgraph(wavs,group,alpha,outliers,bw,xax,pscalemag,samprate)
% graphs group1 vs group2
% and significance of difference for each 1 second interval
% usage: s=grpdiffblairwavgraph(wavs,group,alpha,outliers,bw,xax,pscalemag)
if nargin<3, alpha=.05; end
if nargin<4, bw=0; end
if nargin<5, pscale=0; end
if nargin<8, samprate=62.5; end
if nargin<6, xax=[1:size(wavs,2)]./samprate; end
if nargin<7, pscalemag=-.05; end

groups=unique(group);
if length(groups)~=2 
  fprintf('only works with 2 groups');
  return;
end

grpmeans=pupilcondmeans(wavs,group,unique(group)');
[tmaxthresh,p05tmaxthresh] = getblairkarniskitmax(wavs,group,alpha)
[tt,s]=getallwaveformts(wavs,group);

sa=-pscalemag.*(tt<tmaxthresh);
if bw
  pa=patch([xax(1) xax xax(end)],[0 sa 0],[0.8 0.8 0.8]);
else
  pa=patch([xax(1) xax xax(end)],[0 sa 0],'y');
end
set(pa,'EdgeColor','none');


sa=-pscalemag.*(tt<p05tmaxthresh);
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

% % now, do significance tests of large patches
% sig=0; sigstart=0;
% for ct=1:length(s)
%   if ((sig==0) & (s(ct)<alpha)), 
%     sigstart=ct; 
%     sig=1; 
%   end
%   if (sig & (s(ct)>=alpha)), 
%     sig=0; 
%     if (ct-sigstart)>=resamppatchlen
%       fprintf('%.2f to %.2f: ',xax(sigstart), xax(ct));
%       gttest(mean(wavs(:,sigstart:ct)')',group,outliers,1);
%       hold on;
%       pl=line([xax(sigstart)  xax(ct)]',[pscalemag pscalemag]');
%       set(pl,'Color',[0 0 0]);
%       hold off;
%     end
%   end
% end
% if sig
%   if (ct-sigstart)>=resamppatchlen
%     fprintf('%.2f to %.2f: ',xax(sigstart),xax(ct));
%     gttest(mean(wavs(:,sigstart:ct)')',group,outliers,1);
%     hold on;
%     pl=line([xax(sigstart)  xax(ct)]',[pscalemag pscalemag]');
%     set(pl,'Color',[0 0 0]);
%     hold off;
%   end
% end
axis tight;
ax=axis; 
if ax(3)==pscalemag, ax(3)=ax(3)-.025; end
axis([xax(1) xax(end) ax(3) ax(4)]);
