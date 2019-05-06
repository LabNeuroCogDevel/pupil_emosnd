function plotxy(data,skippts,endskip,minv,maxv,xaxis,eventdata,mintrials) 
% plots a data file of the form (trial,2,data) where the first dimension is x and 
% the second is y
% Useage: plotxy(data,skippts,endskip,minv,maxv,xaxis,eventdata,mintrials,ylabeltext) 

if (nargin < 2) skippts=0; end
if (nargin < 3) endskip=0; end
if (nargin < 4) minv=min(min(squeeze(data(:,2,:)))); end
if (nargin < 5) maxv=max(max(squeeze(data(:,2,:)))); end
if (nargin < 6) xaxis=(skippts+1):((size(data,2)-endskip)); end % went to size(data,2)
if (nargin < 7) mintrials=1; end

clf;
numtrials=size(data,1);

%ysize=numtrials; %mod(numtrials,4)+1;
%xsize=1; % round(numtrials./4);

xsize=fix((numtrials+3)./4);
ysize=round(numtrials./xsize);
if (ysize.*xsize)<numtrials
  ysize=ysize+1;
end

for i=1:numtrials
  subplot(ysize,xsize,i);
  plot(squeeze(data(i,1,skippts+1:(size(data,3)-endskip))),squeeze(data(i,2,skippts+1:(size(data,3)-endskip))));
  title(i+mintrials-1);
  xlabel('x');
  ylabel('y');
  if ((nargin<4) | ((minv==0) & (maxv==0))) axis tight;
  else axis([min(min(squeeze(data(:,1,:)))) max(max(squeeze(data(:,1,:)))) minv maxv]); 
  end
end
