function plotpupiltrialmatrix(p,dosort,maxx)
% useage: plotpupiltrialmatrix(data,sort)
% with sort: plots a sejnowski-lab style trial matrix
%   in which pupil values are plotted in color
%   for each trial, and rt's are plotted as black.
%   Trials are ordered by rt.
%MODS: 
%8/20/09 - SO - Changed all instances of p.NormedPupTrials to p.NormedNoParallaxTrials
%8/20/09 - SO - Changed pcolor(padlr(data)); from padlr to fliplr (b/c no
%padlr)

if nargin<2, dosort=0; end

if nargin<3, maxx=size(p.NormedNoParallaxTrials,2); end
%if nargin<3, maxx=size(p.NormedPupTrials,2); end

data=p.NormedNoParallaxTrials(:,1:maxx);
%data=p.NormedPupTrials(:,1:maxx);
%data=p.PupilTrials;

if dosort

  tmatrix=data;
  [U,V]=meshgrid(p.TrialSeconds(1:maxx),1:size(data,1));
  minval=min(min(data));
  
  for ct=1:size(tmatrix,1)
    tmatrix(ct,p.stats.rttick(ct))=minval; % rt
  end
  figure(1);
  pcolor(U,V,tmatrix);
  shading flat;
  colorbar;
  title('not sorted');
  xlabel('seconds');
  ylabel('trial');
  %colormap copper;

  tmatrix=data;
  stmatrix=sortrows([tmatrix p.stats.rttick'],size(tmatrix,2)+1);
  sortedrts=stmatrix(:,size(tmatrix,2)+1);
  for ct=1:size(tmatrix,1)
    stmatrix(ct,sortedrts(ct,1))=minval; % rt
%    stmatrix(ct,sortedrts(ct,1))=minval; % sternberg rt
  end
  stmatrix=stmatrix(:,1:size(tmatrix,2));
  figure(2);
  pcolor(U,V,stmatrix);
  xlabel('seconds');
  ylabel('sorted trials');
  shading flat;
  colorbar;

  
else
  pcolor(fliplr(data)); shading flat  
  %pcolor(padlr(data)); shading flat
  colormap copper;
  title('Normed pupil trials');
  xlabel('tick');
  ylabel('trial');
end


