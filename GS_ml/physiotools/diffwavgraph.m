function [s,h]=diffwavgraph(wavcond1,wavcond2,samprate,resamprate,alpha,outliers,patchlen,bw,pscale,wavcond3,pscalemag,xax,linewidth)
% graphs cond1 v. cond2
% expects 2 matrices, each with subjects in rows and wavs in columns
% and significance of difference for each time point
% usage: s=diffwavgraph(wavcond1,wavcond2,samprate,resamprate,alpha,outliers,patchlen,bw,pscale,wavcond3,pscalemag,xax,linewidth)
% 
% wavecond1: this is the matrix of N rows for condition 1
% wavecond2: this is the matrix of N rows for condition 2
% samprate:  the sampling rate, in Hz
% resamprate: The rate at which to resample the data - usually the same as samprate
%   You can leave the samprate and resamprate the same and the routine will
%   run fastest, and in the most principled way. The reason to consider resampling is to
%   decrease the autocorrelation in the data. The more
%   you resample, the "rougher" the data will be, and thus the less points
%   you'll need in a row to get significance. So, in case you play with resampling in
%   getting the autocorrelation, I let you throw that in as a parameter...
% alpha: threshold for significance, usually set to .05 or .1
%   And like Guthrie and Buchwald, I like the .1 threshold. That said,
%   if regions I like are not coming out, I often like to see what the actual significance
%   of patches "would be" so that I can know whether it's a power issue. Towards that end,
%   I'll often play, in the privacy of my darkened office with the door locked, with
%   thresholds of .3 or .5...
% outliers: 
%   This is an easy way to recompute patches with specific
%   people taken out, just to see if things change. By default it should be a vector with N
%   rows and one column of all zeros. If you put ones on any
%   row, those people are not counted in computing mean waveforms or significance tests.
% patchlen: the length of consecutive data points required for sig
%   note: patchlen does NOT account for resamprate.
%   so, even if you downsample to 1hz, a patchlen of 17 refers to 17 points in
%   a row in the original sampled space. Thus you must change it yourself in
%   the calling routine...
% bw: whether or not graphs should be in black and white
%   For display on the screen, set bw=0 and graphs will appear in color. For publications
%   in which color is costly, set bw=1 and it will make your graphs in black and white,
%   with dotted lines as necessary.
% pscale:
%   This should be zero for most applications. That
%   will set the significance bars to a uniform height.
%   If pscalemag is not zero, the significance bars are of the height
%   of the p-value, scaled by pscale.
% wavcond3: 
%  This is an optional 3rd condition, which is plotted but not included
%  in tests. Set it to zero if there is no third condition.
% pscalemag: 
%   This is how large the bars for significance should appear under
%   the x axis (if pscale =0). So if the y axis goes from -10 to 10, you might make pscale
%   = 1. But if the y axis goes from -.1 to .1 you might make pscale = 0.02.
%   making pscalemag negative puts the significance bars below the x axis
% xax: 
%   This is the units you want on the x-axis. By default it puts the x-axis in
%   seconds. But if you want it in ticks, pass a vector which counts from
%   1:wavelen.
% linewidth:
%   This is how wide the lines are on the plots. 0.5 by default
%   If you want to thicken then up, e.g., for a poster, pass in values > 0.5
%
% Function by Greg Siegle, Ph.D.
% cite as Siegle, G. J. (2003) The Pupil Toolkit, Available directly from the author,
% as used in, e.g.,
% Siegle GJ, Steinhauer SR, Carter CS, Ramel W, Thase ME (2003): Do the seconds 
%   turn into hours? Relationships between sustained pupil dilation in response 
%   to emotional information and self-reported rumination. Cognitive Therapy 
%   and Research 27:365-382.



wavlen=size(wavcond1,2);
if nargin<3, samprate=62.5; end
if nargin<4, resamprate=samprate; end
if nargin<5, alpha=.05; end
if nargin<6, outliers=zeros(size(wavcond1,1),1); end
if nargin<7, patchlen=17; end
if nargin<8, bw=0; end
if nargin<9, pscale=10; end
if nargin<10, wavcond3=0; end
if nargin<11, pscalemag=-.05; end
if nargin<12, xax=[1:wavlen]./samprate; end
if nargin<13, linewidth=0.5; end

if length(outliers)==1, outliers=zeros(size(wavcond1,1),1); end

%samprate=62.5; resamprate=62.5; alpha=.1; outliers=[]; patchlen=17; bw=0; pscale=10; wavcond3=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% resample waveforms for number of tests 

samptoavg=round(samprate/resamprate);
c1mean=m(wavcond1,outliers); 
c2mean=m(wavcond2,outliers);
if length(wavcond3)>1, c3mean=m(wavcond3,outliers); end

%c1mean=m(wavcond1); 
%c2mean=m(wavcond2);

if length(wavcond3)>1, condmeans=[c1mean; c2mean; c3mean]; 
else condmeans=[c1mean; c2mean];
end
diffwav=wavcond2-wavcond1;

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot all areas with significant differences
sa=s.*(s<alpha);
if bw
     disp('bw=true')
  if pscale==0
    sa=(s<alpha).*pscalemag;
    pa=patch([xax(1) xax xax(end)],[0 sa 0],[0.58 0.58 0.58]);
  else
    pa=patch([xax(1) xax xax(end)],[0 pscale.*sa 0],[0.58 0.58 0.58]);
  end
else
    disp ('bw=false')
  if pscale==0
      disp('pscale=0')
    sa=(s<alpha).*pscalemag;
    pa=patch([xax(1) xax xax(end)],[0 sa 0],[1.0 0.58 0.58]);
  else
    pa=patch([xax(1) xax xax(end)],[0 pscale.*sa 0],[1.0 0.58 0.58]);
  end
end
set(pa,'EdgeColor','none');
if alpha>.05
  sa=s.*(s<.05);
  if bw
    if pscale==0
      sa=(s<.05).*pscalemag;
      pa=patch([xax(1) xax xax(end)],[0 sa 0],[0.5 0.5 0.5]);
    else
      pa=patch([xax(1) xax xax(end)],[0 pscale.*sa 0],[0.5 0.5 0.5]);
    end
  else
    if pscale==0
      sa=(s<.05).*pscalemag;
      pa=patch([xax(1) xax xax(end)],[0 sa 0],[1.0 0.5 0.5]);
    else
      pa=patch([xax(1) xax xax(end)],[0 pscale.*sa 0],[1.0 0.5 0.5]);
    end
  end
  set(pa,'EdgeColor','none');
end 
hold on;

disp('got toplot all areas w/ sig diff')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the waveforms
if bw
  h1=plot(xax,condmeans(1,:)','k'); set(h1,'LineWidth',linewidth);
  h2=plot(xax,condmeans(2,:)','k:'); set(h2,'LineWidth',linewidth);
  if length(wavcond3)>1, plot([1:wavlen]./samprate,condmeans(3,:)','r'); end
  h=[h1 h2];
else
  h=plot(xax,condmeans'); set(h,'LineWidth',linewidth);
%  plot(xax,condmeans(1,:)','b');
%  plot(xax,condmeans(2,:)','g');
  if length(wavcond3)>1, plot(xax,condmeans(3,:)','c'); end
end
plot(xax,zeros(size(s)),'k');
hold off

disp('got to plot the waveforms')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
      gonesampttest(mean(diffwav(:,sigstart:ct)')',0,outliers,1);
      hold on;
      pl=line([xax(sigstart)  xax(ct)]',[pscalemag pscalemag]');
      set(pl,'Color',[0 0 0]);
      hold off;
    end
  end
end
disp('got to end of first loop')


if sig
  if (ct-sigstart)>=patchlen
    fprintf('%.2f to %.2f: ',xax(sigstart), xax(ct));
    gonesampttest(mean(diffwav(:,sigstart:ct)')',0,outliers,1);
    hold on;
    pl=line([xax(sigstart) xax(ct)]',[pscalemag pscalemag]');
    set(pl,'Color',[0 0 0]);
    hold off;
  end
end
disp('got to end of last loop')
axis tight;
ax=axis; axis([xax(1) xax(end) ax(3) ax(4)]);

