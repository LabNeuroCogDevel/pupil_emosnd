function threedpupilgraph(p, dodetrend)
% graphs pupil data as a surface

if nargin<2,dodetrend=0;end

figure('Name','3d Pupil Graphs');

subplot(1,2,1);
if dodetrend
  surfl(p.NormedDetrendPupTrials); 
else
  surfl(p.NormedPupTrials); 
end
shading interp; colormap copper; axis tight; xlabel('Time (s)   '); ylabel('Trial'); zlabel('mm'); title('Normed Trials');
subplot(1,2,2);
surfl(makesquare(p.RescaleData)); 
shading interp; colormap copper; axis tight; xlabel('Time (s)   '); ylabel('Time (s)'); zlabel('mm'); title('Raw data');
