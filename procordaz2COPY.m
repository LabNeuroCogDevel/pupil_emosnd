%DONT USE THIS...USE procordaz2COPYfunction.m instead
%% load the data
%cd C:\greg\papers\ordaz-antisac\GregSiegle_Meeting_2009.07.08\EyeData_Good
%fname='10651_a_P_6'
%fname='10651_a_UP_5'

%cd C:\greg\papers\ordaz-antisac\GregSiegle_Meeting_2009.07.08\EyeData_GoodWBlinks
%fname='10631_a_S_6'

addpath(genpath('/Volumes/L/bea_res/Oxford Eye Experiments/CogEmotStudy_Data/CogEmotStudy_Eye_Data/Pupil Processing_GregSiegle/GregSiegle_Matlab/matlabtoolkit'))
cd ('/Volumes/Zeus/MMY1_EmoSnd/pupil')

%fname='B:/bea_res/Oxford Eye Experiments/CogEmotStudy_Data/CogEmotStudy_Eye_Data/Pupil Processing_GregSiegle/GregSiegle_Meeting_2009.07.08/EyeData_GoodWBlinks/10631_a_S_6'
%fname='B:/BEA_RES/Oxford Eye Experiments/CogEmotStudy_Data/CogEmotStudy_Eye_Data/10631_Eye_Data/pupil_10631/pupil_10631_a_S_6'
%fname='B:/bea_res/Personal/Sarah/fMRI_cogemosounds/10837/10837_EyeData/pupil_10837_run1_S'
fname='/Volumes/L/bea_res/Data/Tasks/CogEmoSoundsBasic/10370/20120918/Raw/EyeData/txt/10370.20120918.1.data.txt'


p=readasltextlunalab(fname,1,1,0,0)
%p.TrialStarts=p.EventTicks(find(p.EventCodes<80));
%SO: need add something that gets rid of starting 250s; sometimes new antis
%will start with 210, 211, 212 AND END W/ 249

%% segment into trials
p.TrialStarts=p.EventTicks(find((p.EventCodes>29)  & (p.EventCodes<91)));
p.TrialEnds=p.EventTicks(find(p.EventCodes>249))+35; % add 
p.StimTypes=p.EventCodes(find((p.EventCodes>101)  & (p.EventCodes<199)));
first=min(p.TrialStarts)
p.TrialEnds=p.TrialEnds(p.TrialEnds>first)
last=max(p.TrialStarts)
i=find(p.TrialEnds>last)
if length(i)>1
    p.TrialEnds=p.TrialEnds(1:i(1))
end
p.StimLatencies=ones(size(p.StimTypes));
p.TrialLengths=p.TrialEnds-p.TrialStarts;
p.NumTrials=size(p.TrialStarts,1);
p=segmentpupiltrials(p,0,5,92,0,1,4);
p.stats.rts=ones(1,size(p.TrialStarts,1));
%SO - Below is link to .m file that drops trials & makes bar graphs (figure 3)
p.drops=dropbadtrials(p,1,-10000,5,4,0,0,.7);
%OR - data,graphics,lowrt,hirt,stdcutoff,dropblinkbaseline,manualbadfilename,blinkpercentfordrop,dodetrend,dropincorrect
%SO - I think me='B:/bthis is how Greg edited out blinks - BLINK FILTER!
%p.drops=dropbadtrials(p,1,-10000,5,4,0,0,.55);
fprintf('dropped %d of %d trials\n',sum(p.drops),p.NumTrials);
p.TrialTypesNoDrops=p.StimTypes;
p.TrialTypes=((1-p.drops').*p.TrialTypesNoDrops)';
p.Conditions=unique(p.TrialTypesNoDrops)';
p=pupaddcondmeans(p,1,0); % works on p.NormedPupTrials
figure(4); clf;
%plot(p.TrialSeconds,p.ConditionMeans')
%%%%%%%%%%%%%
%SO added below to visualize plots - had to break into 4 specifications
%otherwise all 4 lines would be specified color
%SO also added hold off
hold on
plot(p.TrialSeconds,p.ConditionMeans(1,:),'-b')
plot(p.TrialSeconds,p.ConditionMeans(2,:),'-m')
plot(p.TrialSeconds,p.ConditionMeans(3,:),'-y')
plot(p.TrialSeconds,p.ConditionMeans(4,:),'-r')
%%%%%%%%%%%%%%%%%
legend('1','2','3','4')
title('Pupil');

%% make the x-eye-position graphs
%p.X=max(0,p.X);
%p.X=(rescaleoutlierstimeseries(p.X,14)./250).*16-8;
p2=segmentpupiltrials(p,0,5,92,0,1,4,0,p.X);
p2.stats.rts=ones(1,size(p2.TrialStarts,1));
p2.drops=dropbadtrials(p2,1,-10000,5,2.5,0,0,.9);
p.drops=(p.drops | p2.drops)

p.NormedXTrials=p2.NormedPupTrials;
p.XConditionMeans=pupilcondmeans(p.NormedXTrials,p.TrialTypes,p.Conditions,p.drops);
figure(5); clf;
%plot(p.TrialSeconds,p.XConditionMeans')
%%%%%%%%%%%%%
%SO added below to visualize plots - had to break into 4 specifications
%otherwise all 4 lines would be specified color
%SO also added hold off
hold on
plot(p.TrialSeconds,p.XConditionMeans(1,:),'-b')
plot(p.TrialSeconds,p.XConditionMeans(2,:),'-m')
plot(p.TrialSeconds,p.XConditionMeans(3,:),'-y')
plot(p.TrialSeconds,p.XConditionMeans(4,:),'-r')
%%%%%%%%%%%%%%%%%
legend('1','2','3','4')
title('X');
hold off;
%% account for parallax
%eyedegrees =[20.86 27.03 41.68 53.33 59.37];
%eyepos=[-8 -4 0 4 8];
corrfac=([linspace(59.37,53.33,30) linspace(53.33,41.68,30) linspace(41.68,27.03,30) linspace(27.03,20.86,30)]);
%corrfac=(corrfac-min(corrfac))./(max(corrfac)-min(corrfac));
eyeposfac=[linspace(-8,-4,30) linspace(-4,0,30) linspace(0,4,30) linspace(4,8,30)];
eyeposfac=((eyeposfac+8)./16).*250;
xtocorr=zeros(size(p.X)); visang=zeros(size(p.X));
for ct=1:length(p.X)
    xtocorr(ct)=findclosestindex(p.X(ct),eyeposfac);
    visang(ct)=corrfac(xtocorr(ct));
end

%p2=segmentpupiltrials(p,0,5,92,0,1,4,0,visang);
%visangTrials=p2.PupilTrials;
%visangConditionMeans=pupilcondmeans(visangTrials,p.TrialTypes,p.Conditions,p.drops);
%figure(12);
%plot(p.TrialSeconds,visangConditionMeans')
%legend('1','2','3','4')
%title('Visual Angle');

% if visual angle <.5 pupil should get larger
% if visual angle >.5 pupil should get smaller
%pupmult=[visang<.5].*visang+[visang>=0.5].*

%p.PupNoParallax=p.NoBlinks./(1-visang');
%mr=mregs(visang',p.NoBlinks)
% Ypred= 1-.5.*visang'
% so get residual by subtracting Y-Ypred
%p.PupNoParallax=p.NoBlinks-(1-.5.*visang');


p.PupNoParallax=p.NoBlinks./cosd(visang);


p2=segmentpupiltrials(p,0,5,92,0,1,4,0,p.PupNoParallax);
p.NormedNoParallaxTrials=p2.NormedPupTrials;
p.NoParallaxConditionMeans=pupilcondmeans(p.NormedNoParallaxTrials,p.TrialTypes,p.Conditions,p.drops);
figure(7); clf;
%plot(p.TrialSeconds,p.NoParallaxConditionMeans')
%%%%%%%%%%%%%
%SO added below to visualize plots - had to break into 4 specifications
%otherwise all 4 lines would be specified color
%SO also added hold off
hold on
plot(p.TrialSeconds,p.NoParallaxConditionMeans(1,:),'-b')
plot(p.TrialSeconds,p.NoParallaxConditionMeans(2,:),'-m')
plot(p.TrialSeconds,p.NoParallaxConditionMeans(3,:),'-y')
plot(p.TrialSeconds,p.NoParallaxConditionMeans(4,:),'-r')
%%%%%%%%%%%%%%%%%
legend('1','2','3','4')
title('No Parallax');

%%
% SO added to get MEAN TIME SERIES plot
%PROBLEM! p.meanTimeSeries NOT= p.MeanTimeSeriesBetter. The should be the
%same b/c there's no missing data  and they're both averaging the same
%BUT they're diff, and p.meanTimeSeries looks like it has had outliers
%removed from it - find out if this is the case, and ,if so, how the
%outliers were removed.  
%SO I'm going with p.meanTimeSeries.  Better is WORSE!

p.meanTimeSeries=mean(p.NoParallaxConditionMeans)
figure(8); clf;
hold on
plot(p.TrialSeconds,p.meanTimeSeries,'-b')
title('Mean Time Series');

%p.meanTimeSeriesBetter=mean(p.NormedNoParallaxTrials)
%figure(9); clf;
%hold on
%plot(p.TrialSeconds,p.meanTimeSeriesBetter,'-b')
%title('Mean Time Series - Better? No outliers removed');

%%
% SO added to end to get more statistics
%note: p.NoParallaxConditionMeans is a 4 by whatever matrix - one row for
%each of the 4 cue locations
meancue1=mean(p.NoParallaxConditionMeans(1,:));
meancue2=mean(p.NoParallaxConditionMeans(2,:));
meancue3=mean(p.NoParallaxConditionMeans(3,:));
meancue4=mean(p.NoParallaxConditionMeans(4,:));

meancues=[meancue1 meancue2 meancue3 meancue4]








