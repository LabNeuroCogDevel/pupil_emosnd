function plotpupilcondmeans(p,miny,maxy)
% plots the mean of each pupil condition

if nargin<2
  miny=min(min(p.ConditionMeans));
end
if nargin<3
  maxy=max(max(p.ConditionMeans));
end

fignum=gcf;

figure(fignum);
subplot(2,1,1);
condlabels=num2str(p.Conditions');
plot(p.TrialSeconds,p.ConditionMeans'); legend(condlabels); % plot cond means
axis([min(p.TrialSeconds) max(p.TrialSeconds) miny maxy]);
xlabel('t (s)'); ylabel('mm');


%figure(fignum+1);
subplot(2,1,2);
condnums=(((p.Conditions'./8)-1)./2);
hold on
for dim=1:size(p.Conditions,2)
  plot3(p.TrialSeconds,p.TrialSeconds-p.TrialSeconds+condnums(dim),p.ConditionMeans(dim,:),'b');
  plot3(p.TrialSeconds,p.TrialSeconds-p.TrialSeconds+condnums(dim),p.ConditionMeans(dim,:)-p.ConditionSds(dim,:),'r');  
  plot3(p.TrialSeconds,p.TrialSeconds-p.TrialSeconds+condnums(dim),p.ConditionMeans(dim,:)+p.ConditionSds(dim,:),'r');
end
xlabel('t (s)'); ylabel('condition'); zlabel('mm');
hold off
view(34,40);
rotate3d on;
grid on;
