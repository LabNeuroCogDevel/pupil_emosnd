function pall=addbaselinestopall(pall)
% gets each person's baseline as the mean of
% the 10 samples at the beginning of each trial
for ct=1:length(pall)
    for samp=1:10
      pall(ct).TrialStarts=max(1,pall(ct).TrialStarts);
      s(samp)=mean(pall(ct).NoBlinks(pall(ct).TrialStarts(1:end)+samp));
    end
    pall(ct).baseln=mean(s);
end
