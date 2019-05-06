% routines for interacting with pupil data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% go somewhere interesting
cd c:\greg\stulab\
cd c:\greg\papers\rumquest\data\pupil;
cd g:\greg\data\rumquest\pupil;
cd e:\greg\pitt\stulab\eegsys-processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gather relevant data
p=preparepupil('200201.501'); % just stern
p=preparepupil('10501.501'); % GJS atq-stern
p=preparepupil('999501.505'); % AH rt-stern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% describing events
[p.EventCodes;p.EventTimes]'
plot(p.EventTimes,p.EventCodes,'*')
plot(p.AllSeconds,p.EventTrain);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graphing
showpupiltrials(p);
showrelpupiltrials(p); 
showpupiltrial(p,10);
threedpupilgraph(p);
scrollplot([p.NoBlinks;p.EventTrain]');
plot(p.AllSeconds,[p.NoBlinks;p.EventTrain]');
scrollplot(p.Frequencies(1:24));
plotpupilcondmeans(p); % plot per condition averages
plotselectedtrials(p.NormedPupTrials,find(p.TrialTypes==72))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get trial stats
trialstats=pupiltrialstats(p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% per condition statistics
cond1trials=gathercondtrials(1,p);
ploteegsys(cond1trials,0,0,min(min(cond1trials)), max(max(cond1trials)),p.TrialSeconds,min(20,p.EventTrials(:,1:size(p.TrialSeconds,2)))); 

