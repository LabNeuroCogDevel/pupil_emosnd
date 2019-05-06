function [newrows]=selectrows(rownums,matrix)
% selects rows from a matrix
% useage selectrows(rownums,matrix)

newrows=matrix;
for trial=1:size(matrix,1)
  if (~ismember(trial,rownums))
    newrows(trial,:)=zeros(1,size(matrix,2))-Inf;
  end
end
[newrows,indices,reconstruct]=unique(newrows,'rows');
newrows=newrows(2:size(newrows,1),:);
indices=indices(2:size(indices,1));
newrows=sortrows([indices,newrows],1);
newrows=newrows(:,2:(size(newrows,2)));

