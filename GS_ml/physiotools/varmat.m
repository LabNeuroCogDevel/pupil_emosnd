function varm=varmat(mat)
% takes a 3d matrix and returns the variance along the
% first dimension
% usage: varm=varmat(mat)

for coln=1:size(mat,2)
  varm(coln,:)=var(squeeze(mat(:,coln,:)));
end

  