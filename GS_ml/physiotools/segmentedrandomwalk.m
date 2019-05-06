function [s,w]=segmentedrandomwalk()
% make 60 trials from a random walk
% useage:  s=segmentedrandomwalk;

w=randomwalk;
tmp=reshape(w,344,60);
s=tmp';


for trial=1:60
  s(trial,:)=s(trial,:)-s(trial,10);
  %s(trial,172:344)=s(trial,172:344)-s(trial,180);
  %s(trial,150:180)=  s(trial,150:180).*([1:31]./31);
end
