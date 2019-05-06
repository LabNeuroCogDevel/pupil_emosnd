function [mautocorr,acmatrix]=pupilautocorrgraph(p,graphics,normed,dodetrend)
% usage: [mautocorr,acmatrix]=pupilautocorrgraph(p,graphics,normed,dodetrend) 
% plots autocorrelation of pupil data with itself
% mautocorr is the autocorrelation at each second lag
% acmatrix is the correlation of dilation at each second with each
%   other second

if nargin<2, graphics=1; end
if nargin<3, normed=1; end
if nargin<4, dodetrend=1; end

if length(p)>1,
  for sub=1:length(p)
    [submautocorr subacmatrix]=pupilautocorrgraph(p(sub),0,normed,dodetrend);
    if sub==1,
      mautocorr=submautocorr; acmatrix=subacmatrix;
    else
      mautocorr=mautocorr+submautocorr; acmatrix=acmatrix+subacmatrix;
    end
  end
  mautocorr=mautocorr./length(p);
  acmatrix=acmatrix./length(p);
  trialsec=p(1).TrialSeconds;
  numblocks=floor(max(p(1).TrialSeconds));

else
  if normed
    if dodetrend
      data=p.NormedDetrendPupTrials;
    else
      data=p.NormedPupTrials;
    end
  else
    if dodetrend
      data=p.DetrendPupilTrials;
    else
      data=p.PupilTrials;
    end
  end
  
  autocorr=zeros(size(data));
  %%%%%%%%%%%%%%%%%%%%%%%%%
  %XCORR(A,'flag'), XCORR(A,B,'flag') or XCORR(A,B,MAXLAG,'flag') 
  %normalizes the correlation according to 'flag':
  %coeff- normalizes the sequence so correlations at zero lag are identically 1.0
  %XCORR(A,B), where A and B are length M vectors, returns the
  %  length 2*M-1 cross-correlation sequence in a column vector
  %SO note: My data is a 35 x 92 array, so tmp=183 & below reads
  %autocorr(trial,:)=tmp(temp(92:end))
  for trial=1:size(data,1)
    tmp=xcorr(data(trial,:),'coeff');
    autocorr(trial,:)=tmp((length(tmp)+1)./2:end);
  end
  mautocorr=mean(autocorr);

  
  %%%%%%%%%%%%%%%%%%%%%%%%%
  %??my trials are only 1.5168 seconds, so numblocks=1, which prevents
  %Figure 2 from being made
  %SO note: However, if you set numblocks=2, it works!
  numblocks=floor(max(p.TrialSeconds));
  secblocks=zeros(size(data,1),numblocks);
  %??numblocks is 1, but  Useage: resample(data,origHz,newHz) Is newHZ=really supposed to be the floor(length of the trial) aka 1 or 2?
  %Below I filled in values for my data
  %??origHz is 92 - but my dta was collected on 60Hz. Should I change it?
  %SO note: (size(data,1)=36)
  for trial=1:size(data,1)
    secblocks(trial,:)=resample(data(trial,:),size(data,2),numblocks);
  end
  
  %SO note: acmatrix is a matrix of zeros with the length of secondblocks in rows
  %and columns
  %SO note: In my data, (size(secblocks,2)=36)
  acmatrix=zeros(size(secblocks,2));
  for lag1=1:size(secblocks,2)
    for lag2=1:size(secblocks,2)
      acmatrix(lag1,lag2)=r(secblocks(:,lag1),secblocks(:,lag2));
    end
  end
  trialsec=p.TrialSeconds;
end

if graphics
  figure('Name','Pupil Auto Correlation');
  plot(trialsec,mautocorr);
  title('Mean autocorrelation within trials');
  xlabel('lag (seconds)');
  ylabel('r');

  newaxis=resample(trialsec,length(trialsec),numblocks);
  [X,Y]=meshgrid(newaxis,newaxis);
  figure('Name','Pupil Second-by-Second Correlation');
  pcolor(X,Y,acmatrix);
  colormap hot;
  shading interp; % flat
  title('Correlation of mean activity at each second with mean activity at each other second');
  xlabel('second');
  ylabel('second');
  colorbar;
end
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%
%figure(3);
%xcmatrix2=xcorr2(data);
%[X,Y]=meshgrid(linspace(0,25,344),1:60);
%Z=xcmatrix(60:119,344:687)./(max(max(xcmatrix)));
%surfl(X,Y,Z); shading interp;
%plot(X(1,:),Z(1,:));
