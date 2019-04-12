function data=segmentpupiltrials(data,graphics,baselength,maxgoodlength,extrafancy,onsettime,stdcutoff,usedetrend,specialdata)
% useage: data=segmentpupiltrials(data,graphics,baselength,maxgoodlength,extrafancy,onsettime,stdcutoff,usedetrend,specialdata)
% segments pupil data into trials

if (nargin<2), graphics=0; end
if (nargin<3), baselength=10; end
if nargin<4, maxgoodlength=10000; end
if nargin<5, extrafancy=0; end
if nargin<6, onsettime=1; end
if nargin<7, stdcutoff=3; end
if nargin<8, usedetrend=0; end
if nargin<9, specialdata=[]; end

if ~isempty(specialdata), datatouse=specialdata;
elseif usedetrend, datatouse=data.NoBlinksDetrend;
else datatouse=data.NoBlinks;
end

numtrials=length(data.TrialEnds);
if isfield(data,'TrialLengths')
    trialsizes=data.TrialLengths;
else trialsizes=data.TrialEnds-[0; data.TrialEnds(1:numtrials-1)];
end
maxlen=floor(min(maxgoodlength,max(trialsizes)));


data.PupilTrials=zeros(numtrials,maxlen);
data.EventTrials=zeros(numtrials,maxlen);
data.BlinkTrials=zeros(numtrials,maxlen);
data.DetrendPupilTrials=zeros(numtrials,maxlen);
if extrafancy
    data.WaveletTrials=zeros(numtrials,maxlen);
end

prevtrial=0;
for ct=1:numtrials
  if isfield(data,'TrialStarts')
      starttrial=data.TrialStarts(ct);  
  else
      starttrial=prevtrial+1;
  end
  endtrial=min(data.TrialEnds(ct)-1,starttrial+maxlen-1);
  if starttrial<1
    data.PupilTrials(ct,1:endtrial-starttrial+1)=[zeros(abs(starttrial)+1,1); datatouse(1:endtrial)]';
    if isfield(data,'NoBlinksDetrend')
      data.DetrendPupilTrials(ct,1:endtrial-starttrial+1)=[zeros(abs(starttrial)+1,1); data.NoBlinksDetrend(1:endtrial)]';
    end
    if isfield(data,'EventTrain')
      data.EventTrials(ct,1:endtrial-starttrial+1)=[zeros(abs(starttrial)+1,1); data.EventTrain(1:endtrial)]';
    end
    data.BlinkTrials(ct,1:endtrial-starttrial+1)=[zeros(abs(starttrial)+1,1); data.BlinkTimes(1:endtrial)]';
    if extrafancy
      data.WaveletTrials(ct,1:endtrial-starttrial+1)=[zeros(abs(starttrial),1); data.FastWavelet(1:endtrial)];
    end
    prevtrial=data.TrialEnds(ct);    
  else
    %fprintf('endtrial-starttrial=%d calcend=%d\n',endtrial-starttrial,min(maxlen,trialsizes(ct)));
    data.PupilTrials(ct,1:endtrial-starttrial+1)=datatouse(starttrial:endtrial);
    if isfield(data,'NoBlinksDetrend')
      data.DetrendPupilTrials(ct,1:endtrial-starttrial+1)=data.NoBlinksDetrend(starttrial:endtrial);
    end
    if isfield(data,'EventTrain')
      data.EventTrials(ct,1:endtrial-starttrial+1)=data.EventTrain(starttrial:endtrial);
     end
    data.BlinkTrials(ct,1:endtrial-starttrial+1)=data.BlinkTimes(starttrial:endtrial);
    if extrafancy
      data.WaveletTrials(ct,1:endtrial-starttrial+1)=data.FastWavelet(starttrial:endtrial);
    end
    prevtrial=data.TrialEnds(ct);
  end
end


baseline=repmat(mean(data.PupilTrials(:,0+onsettime:baselength+onsettime)')',1,maxlen);
data.NormedPupTrials=data.PupilTrials-baseline.*(1-(data.PupilTrials==0));
data.NormedDetrendPupTrials=data.DetrendPupilTrials-baseline.*(1-(data.DetrendPupilTrials==0));
if isfield(data,'AllSeconds')
  data.TrialSeconds=data.AllSeconds(1:maxlen)';
end

data.Suspect=max(abs(data.NormedPupTrials)')>stdcutoff.*mean(std(data.NormedPupTrials));

if graphics
  plot(data.TrialSeconds,data.NormedPupTrials');
  axis tight;
  xlabel('Seconds');
  ylabel('mm diameter');
end

