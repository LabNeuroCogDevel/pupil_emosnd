cd c:\greg\stulab\
pupildata=preparepupil('10501.501');
showpupiltrials(pupildata);
graphtrial(pupildata,10);
graphtrial(pupildata,0);
threedpupilgraph(pupildata);
scrollplot(pupildata.Frequencies(1:24));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get trial stats
trialstats=rqtrialstats(pupildata);
