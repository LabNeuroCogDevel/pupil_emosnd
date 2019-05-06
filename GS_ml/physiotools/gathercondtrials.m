function [condtrials,events]=gathercondtrials(condition,p,TrialTypes,Conditions,outliers)
% gathers all trials of type condition 
% Useage: gathercondtrials(condition,p) where p is a pupil data array
%      or gathercondtrials(condition,data,trialtypes[,conditions,outliers]);

if isstruct(p)
  data=p.NormedPupTrials;
  TrialTypes=p.TrialTypes;
  Conditions=p.Conditions;
else data=p;
end

if nargin<5
  outliers=zeros(size(data,1),1);
end
if ((nargin<4) & (~isstruct(p)))
  Conditions=unique(TrialTypes);
end


if condition>length(Conditions)
  condtrials=0; events=0;
else
  
  if (size(TrialTypes,1)==size(outliers,1))
    indices=find((TrialTypes==Conditions(condition)) & (~outliers));
  else
    indices=find((TrialTypes==Conditions(condition)) & (~outliers'));
  end
  
  condtrials=zeros(length(indices),size(data,2));
  for ct=1:length(indices)
    condtrials(ct,:)=data(indices(ct),:);
  end



  % condtrials=data;
  % for trial=1:min(size(data,1),size(TrialTypes,2))
  %   if ((TrialTypes(trial)~=Conditions(condition)) | outliers(trial))
  %     condtrials(trial,:)=zeros(1,size(data,2))-10000;
  %   end
  % end
  % % condtrials=unique(sortrows(condtrials),'rows');
  % [condtrials,indices,reconstruct]=unique(condtrials,'rows');
  % condtrials=condtrials(2:size(condtrials,1),:);
  % indices=indices(2:size(indices,1));
  % condtrials=sortrows([indices,condtrials],1);
  % condtrials=condtrials(:,2:(size(condtrials,2)));
  
  if isstruct(p)
    events=selectrows(indices,p.EventTrials);
  else events=0;
  end
end
