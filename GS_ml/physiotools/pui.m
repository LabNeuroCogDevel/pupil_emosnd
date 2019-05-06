function p=pui(p)
% computes pui as in Ludtke et al (1998)
% mean successive differences in 16 samples at 25 Hz
% so takes "rescaledata" and gets mean dilation in .64 seconds
% and calculates differences over successive blocks = p.puiall
% p.puitrials = pui per trial.

numsamp=round(.64.*p.RescaleFactor);

for ct=1:size(p.PupilTrials,1)
  wav=p.PupilTrials(ct,:);
  interv=0;
  for samp=1:numsamp:length(wav)-numsamp;
    interv=interv+1;
    sampmn(interv)=mean(wav(samp:samp+numsamp));
  end
  msd=abs(sampmn(2:end)-sampmn(1:end-1));
  p.puitrials(ct)=mean(msd);
end

interv=0;
sampmn=[];
wav=p.NoBlinks;
for samp=1:numsamp:length(wav)-numsamp;
  interv=interv+1;
  sampmn(interv)=mean(wav(samp:samp+numsamp));
end
p.puiall=abs(sampmn(2:end)-sampmn(1:end-1));


% report in mm/minute