function[avgdata]=dbfilter(data,ptstoaverage,numtimes)
% computes a moving average of the data
% Useage: movingaverage(data,#pts_to_average)

if nargin<3
  numtimes=2;
end

filterindex=fix(ptstoaverage./2);
filter=filterindex+1-abs(-filterindex:filterindex);
filter=filter./sum(filter);

% I think I should be able to do it using filter, e.g.,..
%weights=ones(1,filterindex)./filterindex;
%avgdata=filter(data,filterindex,weights);

% but instead I'll do it manually

avgdata=zeros(1,size(data,2));

for i=1:size(data,2)
   avgdata(i)=mean(data(max(1,i-filterindex):min(i+filterindex,size(data,2))));
end

if numtimes>1
  for ct=1:numtimes-1
    data=avgdata;
    for i=1:size(data,2)
      avgdata(i)=mean(data(max(1,i-filterindex):min(i+filterindex,size(data,2))));
    end
  end
end


%for i=filterindex+1:size(data,2)-filterindex
%   avgdata(i)=dot(data(i-filterindex:i+filterindex),filter);
%end

