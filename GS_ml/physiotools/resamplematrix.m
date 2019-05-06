function[scaledata]=resamplematrix(data,origHz,newHz)
% rescales matrix data from origHz to newHz
% Useage: resample(data,origHz,newHz)

tmpdata=resample(data(1,:),origHz,newHz);
scaledata=zeros(size(data,1),size(tmpdata,2));
scaledata(1,:)=tmpdata;
for ct=2:size(data,1)
     scaledata(ct,:)=resample(data(ct,:),origHz,newHz);
end
