function showpupiltrial(p,trialnum)
% given a pupil data structure and a trial number
% graphs an overlay plot of the trial
if trialnum>0
  plotmanipulator([p.NormedPupTrials(trialnum,:); 0.05.*min(20,p.EventTrials(trialnum,1:size(p.TrialSeconds,2)))]',p.TrialSeconds);
else 
  plotmanipulator([p.NormedPupTrials; 0.05.*min(20,p.EventTrials(:,1:size(p.TrialSeconds,2)))]',p.TrialSeconds);
end
