function [medians,sds]=pupilcondmedians(data,trialtypes,conditions,outliers)
% gets the median pupil dilation waveform for each condition

if nargin<4
  outliers=0;
end


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
   if nargin==4
     condtrials=gathercondtrials(condit,data,trialtypes,conditions,outliers);
   else
     condtrials=gathercondtrials(condit,data,trialtypes,conditions);
   end
   if size(condtrials,1)==0,
     medians(condit,:)=0;
     sds(condit,:)=0;
   elseif (size(condtrials,1)==1)
      medians(condit,:)=condtrials;
      sds(condit,:)=condtrials-condtrials;
   else 
     medians(condit,:)=median(condtrials);
     sds(condit,:)=std(condtrials);
   end
end
