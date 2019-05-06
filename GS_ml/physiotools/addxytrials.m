function p=addxytrials(p)

p2=segmentpupiltrials(p,0,10,size(p.ConditionMeans,2),0,round(median(p.StimLatencies)),4,1,p.YmCRYn);
p.YmCRYnTrials=p2.PupilTrials;
p.NormedYnTrials=p2.NormedPupTrials;
p2=segmentpupiltrials(p,0,10,size(p.ConditionMeans,2),0,round(median(p.StimLatencies)),4,1,p.XmCRXn);
p.XmCRXnTrials=p2.PupilTrials;
p.NormedXnTrials=p2.NormedPupTrials;
clear p2;
