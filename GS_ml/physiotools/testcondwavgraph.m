function testcondwavgraph()

% make a sin wave
sw1=sin(linspace(0,10.*pi,1000));
% add some noisy subjects
sw1manysubs=repmat(sw1,15,1)+rand(15,1000);
% make another sin wav
sw2=sin(1+linspace(0,10.*pi,1000));
% add some noisy subjects
sw2manysubs=repmat(sw2,15,1)+rand(15,1000);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% making a within-subjects graph:
figure(1);
% to make a within-subjects graph of the different
% conditions we have to have one matrix:
allwavs(:,1,:)=sw1manysubs;
allwavs(:,2,:)=sw2manysubs;
% allwavs is now 15 subjects x 2 conditions x 1000 time points

% make a graph of allwavs assuming it was sampled at 60hz,
% using p<.1 as a threshold, no outliers, and a patch of 17
% points for significance
[s,h]=condwavgraph(allwavs,60,60,.1,zeros(15,1),17,0,-.05);
legend(h,'Cond 1','Cond 2');
title('Within subjects graph');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% making a between-subjects graph;

figure(2);
% to make a between-subjects graph we have to have one matrix
% with all the subjects
allsubs=[sw1manysubs; sw2manysubs];
% allsubs is now 30 subjects x 1000 time points

% make a graph of allsubs assuming it was sampled at 60hz,
% identifying subjects as belonging to 2 groups
% using p<.1 as a threshold, no outliers, and a patch of 17
% points for significance
[s,h]=grpdiffwavgraph(allsubs,[ones(15,1); (1+ones(15,1))],60,60,.1,zeros(30,1),17,0,0,.05);
legend(h,'Group 1','Group 2');
title('Between subjects graph');

