function e=pupiltrialevents(p,trial)

if nargin==2
  [a,b,e]=find(p.EventTrials(trial,:));
else
  for trial=1:length(p.StimTypes)
    [a,b,e]=find(p.EventTrials(trial,:)); 
    fprintf('%d ',e);
    fprintf('\n');
  end
end
