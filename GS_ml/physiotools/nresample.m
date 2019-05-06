function [scaledata]=nresample(data,origHz,newHz)
scaledata=resample(data,origHz,newHz);
s2=sigresample(data,newHz,origHz,40);
scaledata(1:round(.98.*length(scaledata)))=s2(1:round(.98.*length(scaledata)));
