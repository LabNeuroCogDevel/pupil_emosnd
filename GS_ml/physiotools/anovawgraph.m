function s=anovawavgraph(wavmat,samprate,resamprate,alpha,outliers,patchlen,bw)
% NOTE: THIS FUNCTION IS NOT YET WRITTEN. IT IS JUST THE DIFFWGRAPH CODE.
% graphs all conditions and significance of difference for each time point
% expects a matrix, with subject as the first column, cond as the 2nd column 
%   and data wavs in columns
% usage: s=anovawavgraph(wavs,group,samprate,resamprate,alpha,outliers,printts)
if nargin<2, samprate=62.5; end
if nargin<3, resamprate=samprate; end
if nargin<4, alpha=.05; end
if nargin<5, outliers=zeros(size(wavcond1,1)); end
if nargin<6, patchlen=17; end
if nargin<7, bw=0; end

samptoavg=round(samprate/resamprate);

c1mean=m(wavcond1,outliers); 
c2mean=m(wavcond2,outliers);

%c1mean=m(wavcond1); 
%c2mean=m(wavcond2);

condmeans=[c1mean; c2mean];
diffwav=wavcond2-wavcond1;
wavlen=size(wavcond1,2);

s=zeros(1,wavlen);

if samprate==resamprate
  for t=1:wavlen
    [tt,s(t)]=gonesampttest(diffwav(:,t),0,outliers); % note: doesn't yet do outliers
  end
else
  for t=1:samptoavg:wavlen
    lt=min(wavlen,t+samptoavg-1);
    [tt,s(t:lt)]=gonesampttest(mean(diffwav(:,t:lt)')',0,outliers);
  end
end

sa=s.*(s<alpha);
if bw
  pa=patch([1 1:wavlen wavlen]./samprate,[0 sa 0],[0.8 0.8 0.8]);
else
  pa=patch([1 1:wavlen wavlen]./samprate,[0 10.*sa 0],'y');
end
set(pa,'EdgeColor','none');
if alpha>.05
  sa=s.*(s<.05);
  if bw
    pa=patch([1 1:wavlen wavlen]./samprate,[0 sa 0],[0.5 0.5 0.5]);
  else
    pa=patch([1 1:wavlen wavlen]./samprate,[0 10.*sa 0],'r');
  end
  set(pa,'EdgeColor','none');
end 
hold on;

if bw
  plot([1:wavlen]./samprate,condmeans(1,:)','k');
  plot([1:wavlen]./samprate,condmeans(2,:)','k:');
else
  plot([1:wavlen]./samprate,condmeans');
end
plot([1:wavlen]./samprate,zeros(size(s)),'k');
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
      gonesampttest(mean(diffwav(:,sigstart:ct)')',0,outliers,1);
    end
  end
end
if sig
  if (ct-sigstart)>=patchlen
    fprintf('%.2f to %.2f: ',sigstart./samprate, ct./samprate');
    gonesampttest(mean(diffwav(:,sigstart:ct)')',0,outliers,1);
  end
end
