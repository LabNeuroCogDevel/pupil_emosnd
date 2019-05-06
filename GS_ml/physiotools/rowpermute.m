function randrows=rowpermute(data)
% randomly permutes the rows in data
% usage: randrows=rowpermute(data)

if size(data,1)==1, data=data'; end

tmp=sortrows([randperm(size(data,1))' data]);
randrows=tmp(:,2:end);
