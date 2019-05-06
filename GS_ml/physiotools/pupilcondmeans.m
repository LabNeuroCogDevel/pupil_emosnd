function [means,sds,ns]=pupilcondmeans(data,trialtypes,conditions,outliers,useharmmean)
% gets the mean pupil dilation waveform for each condition
% useage: [means,sds]=pupilcondmeans(data,trialtypes,conditions,outliers)

if nargin<3, conditions=unique(trialtypes)'; end
if nargin<4,   outliers=0; end
if nargin<5, useharmmean=0; end


%trialtypes=[24 72 24 24 72 24 80 72 24 80 80 72 24 72];
%data=rand(14,80);
%data=p.PupilTrials;
%data=p.NormedPupTrials;
%trialtypes=max(p.EventTrials(1:size(data,1),:)');
%conditions=unique(trialtypes);

% plan: 
% for each condition
%  set rows not matching the condition to zero
%  sort the rows 
%  do unique on them
%  take from the second row on = eliminates the zero row
for condit=1:size(conditions,2)
   if ((length(outliers)>1) | (outliers(1)~=0))
     condtrials=gathercondtrials(condit,data,trialtypes,conditions,outliers);
   else
     condtrials=gathercondtrials(condit,data,trialtypes,conditions);
   end
   if size(condtrials,1)>0
     if (size(condtrials,1)<2)
       means(condit,:)=condtrials;
       sds(condit,:)=condtrials-condtrials;
       ns(condit)=1;
     else 
       if useharmmean, means(condit,:)=harmmean(condtrials);
       else means(condit,:)=mean(condtrials);
       end
       sds(condit,:)=std(condtrials);
       ns(condit)=size(condtrials,1);
     end
   end
end
