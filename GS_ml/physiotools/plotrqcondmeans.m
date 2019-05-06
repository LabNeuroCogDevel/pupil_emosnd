function plotpupilcondmeans(p)

figure(1);
condlabels=num2str(((p.conditions'./8)-1)./2);
plot(p.TrialSeconds,p.condmeans(:,1:780)'); legend(condlabels); % plot cond means

figure(2);
condnums=(((conditions'./8)-1)./2);
hold on
for dim=1:size(conditions,2)
  plot3(p.TrialSeconds,p.TrialSeconds-p.TrialSeconds+condnums(dim),p.condmeans(dim,:),'b');
  plot3(p.TrialSeconds,p.TrialSeconds-p.TrialSeconds+condnums(dim),p.condmeans(dim,:)-condsds(dim,:),'r');  
  plot3(p.TrialSeconds,p.TrialSeconds-p.TrialSeconds+condnums(dim),p.condmeans(dim,:)+condsds(dim,:),'r');
end
hold off
view(34,40);
rotate3d on;
grid on;
