function p=pupaddcondmeans(p,usedrops,extrafancy);
if nargin<3, extrafancy=1; end

if usedrops
 [p.ConditionMeans,p.ConditionSds]=pupilcondmeans(p.NormedPupTrials,p.TrialTypes,p.Conditions,p.drops);
 if extrafancy
   [p.ConditionMedians,p.ConditionSds]=pupilcondmedians(p.NormedPupTrials,p.TrialTypes,p.Conditions,p.drops);
   [p.ConditionDetrendMeans,p.ConditionDetrendSds]=pupilcondmeans(p.NormedDetrendPupTrials,p.TrialTypes,p.Conditions,p.drops);
   [p.ConditionDetrendMedians]=pupilcondmedians(p.NormedDetrendPupTrials,p.TrialTypes,p.Conditions,p.drops); 
   
   p.RtAlignPupTrials=vfrtalign(p);
   p.RtAlignConditionMeans=pupilcondmeans(p.RtAlignPupTrials,p.TrialTypes,p.Conditions);
   
   [p.RawConditionMeans]=pupilcondmeans(p.PupilTrials,p.TrialTypes,p.Conditions,p.drops);
   [p.RawConditionMedians]=pupilcondmedians(p.PupilTrials,p.TrialTypes,p.Conditions,p.drops);
   [p.RawConditionDetrendMeans]=pupilcondmeans(p.DetrendPupilTrials,p.TrialTypes,p.Conditions,p.drops);
   [p.RawConditionDetrendMedians]=pupilcondmedians(p.DetrendPupilTrials,p.TrialTypes,p.Conditions,p.drops); 
 end
else
 [p.ConditionMeans,p.ConditionSds]=pupilcondmeans(p.NormedPupTrials,p.TrialTypes,p.Conditions);
 if extrafancy
   [p.ConditionMedians]=pupilcondmedians(p.NormedPupTrials,p.TrialTypes,p.Conditions);
   [p.ConditionDetrendMeans,p.ConditionDetrendSds]=pupilcondmeans(p.NormedDetrendPupTrials,p.TrialTypes,p.Conditions);
   [p.ConditionDetrendMedians]=pupilcondmedians(p.NormedDetrendPupTrials,p.TrialTypes,p.Conditions); 
   
   [p.RawConditionMeans]=pupilcondmeans(p.PupilTrials,p.TrialTypes,p.Conditions);
   [p.RawConditionMedians]=pupilcondmedians(p.PupilTrials,p.TrialTypes,p.Conditions);
   [p.RawConditionDetrendMeans]=pupilcondmeans(p.DetrendPupilTrials,p.TrialTypes,p.Conditions);
   [p.RawConditionDetrendMedians]=pupilcondmedians(p.DetrendPupilTrials,p.TrialTypes,p.Conditions); 
 end
end
