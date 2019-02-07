function data=readasltextlunalab(fname,graphics,dorblinks,extrafancy,convert,flipevents)
%SO: NOTE!  Put back in rows 70-74 when running trial-by-trial data.   
%reads an asl .txt file
% usage: readasl(fname_root)
%   where fname_root does NOT have an extension
% should allow detrending by events that are negative

if (nargin < 1)
    fprintf(1, '\nUsage: readasl(file_root)\n'); 
    data = -1;
    return;
end

if nargin<2,  graphics=1; end
if nargin<3,  dorblinks=1; end
if nargin<4,  extrafancy=0; end
if nargin<5,  convert=1; end
if nargin<6, flipevents=0; end
% 
% %fname=sprintf('%s.txt',fnameroot);  commented out by David 09032009
% %because he hates the auto append techinque for file extentions...it is
% %lame
% 
% fname = fnameroot;
% 
rawdata=dlmread(fname,'\t',1,0);
%SO 11/10/09: replaced: rawdata=dlmread(fname,'\t',16,4);


fprintf(1,'found %d records in data\n',size(rawdata,1)); 
xdat=rawdata(:,1);
  if flipevents
    xdat=max(xdat(1:end-1))-xdat;
  end
  RawPupil=rawdata(:,2);
  X=max(-300,min(300,rawdata(:,3)));
  Y=max(-300,min(300,rawdata(:,4)));
% 
 data.RescaleData=rawdata(:,3)'; % this is where you'd do resampling
%    % note: RescaleData is also oriented the opposite way from all
%    % other data elements. This is for compatibility with older routines

% Michael Spezio's code should be better...
% fname=sprintf('%s.eyd',fnameroot);
% t=mtlrasl('read_asl_file',fname);
% data.RescaleData=double(t.asl_data.pupil_diameter');
% RawPupil=double(t.asl_data.pupil_diameter);
% X=double(t.asl_data.horz_eye_pos); Y=double(t.asl_data.vert_eye_pos);
% xdatdata=double(t.asl_data.xdat_value);
% xdat=mod(max(-1,xdatdata-median(xdatdata)),1024);

data.FileName=fname;
numpts=length(data.RescaleData);



if dorblinks
  % this code would do it Eric's way
  %  avgdata=dbfilter(data.RescaleData,5)'; % smooth 
  %  avgdata=avgdata(1:numpts);
  %  data.NoBlinks=rblinks(avgdata,.3,.2,1.0,10,7)'; % 
  %  data.BlinkTimes=avgdata~=data.NoBlinks;
  
  % this does it my way, with a second pass
  data=puppreprocess(data,.3,.2,1.0,10,7);
  unscalednoblinks=data.NoBlinks;

  % get 95% trimmed mean
 %%SO removed double %s below on 11/10/09
 %%SO: PUT BACK FOR TRIAL BY TRIAL ANALYSES! This RESCALES data
 %%sw=sort(data.NoBlinks);
 %%minsw=sw(round(.05.*length(sw))); 
 %%maxsw=sw(round(.95.*length(sw)));
 %%data.NoBlinks=(data.NoBlinks-minsw)./(maxsw-minsw);
 %%data.RescaleData=(data.RescaleData-minsw)./(maxsw-minsw);
else
  data.NoBlinks=data.RescaleData';
  %SO added below line 11/10/09
  unscalednoblinks=data.NoBlinks;
  %data.NoBlinksASL=unscalednoblinks
end


% create detrend data
% data.NoBlinksDetrend=zeros(size(data.NoBlinks));
% blockends=[find(data.EventTrain==255); length(data.NoBlinks)];
% for ct=2:length(blockends)
%    if ct==2, blockstarttick=1;
%    else blockstarttick=blockends(ct-2);
%    end
%    blockendtick=blockends(ct);
%    data.NoBlinksDetrend(blockstarttick:blockendtick)=detrend(data.NoBlinks(blockstarttick:blockendtick));
% end

data.NoBlinksDetrend=detrend(data.NoBlinks);

if extrafancy
  data=pupilextrafancy(data);
end


% convert from area to diameter
%data.RawPupil=areatodiam(data.RawPupil);
%data.RescaleData=areatodiam(data.RescaleData);
%data.NoBlinks=areatodiam(data.NoBlinks);

% get event markers
xdatevents=xdat.*(xdat~=[0; xdat(1:numpts-1)]);
data.EventTrain=xdatevents;

data.EventTrain=data.EventTrain.*(data.EventTrain>-1).*(data.EventTrain<255);
[data.EventTicks,j,data.EventCodes]=find(data.EventTrain);

data.RescaleFactor=60; % shouldn't hard wire this. 
%SO: above: GS had set to 60; this affects X axis vis data.AllSeconds

data.EventTimes=data.EventTicks.*(1/data.RescaleFactor);

% get timing data
data.AllSeconds=linspace(0,(1/data.RescaleFactor).*numpts,numpts)';
data.X=X;

data2=data;
data2.xdat=xdat;
data2.NoBlinksUnscaled=unscalednoblinks;
data2.X=X;
data2.Y=Y;
data2.RawPupil=RawPupil;
%SO added next 3 lines so I could see all output

%data2.AllSeconds=data.AllSeconds
%data2.NoBlinks=data.NoBlinks
%data2.NoBlinksDetrend=data.NoBlinksDetrend

if graphics
  asldiagnosticgraphs(data2,graphics);
end

