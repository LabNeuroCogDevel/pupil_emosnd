function plotselectedtrials(alltrials,triallist,fignum)
% plots selected trials from a list
% Useage:plotselectedtrials(p,triallist[,fignum])

if nargin<3 fignum=gcf; end
figure(fignum);
clf;
newarr=zeros(size(triallist,2),size(alltrials,2));
for trl=1:size(triallist,2)
  newarr(trl,:)=alltrials(triallist(trl),:);
end
plot(newarr');
legend(num2str(triallist'));
hold off;
