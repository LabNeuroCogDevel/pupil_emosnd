function makeblocksfrommrphys(fname,nthresh)
% finds areas in fname in which there are
% triggers and separates them into files for
% further processing
% usage: makeblocksfrommrphys(fname,nthresh)

% noise threshold 
if nargin<2, nthresh=20; end

if ~probe(fname)
  fprintf(1,'physio data not found for %s\n',fname); return;
end

fprintf('Breaking %s into blocks...',fname);

dat=load(fname);

blockind=abs(dat(:,1))>nthresh;
smb=conv(blockind,[1 1 1 1 1 1 1 1 1 1]);
smb=smb(1:length(blockind))>0;
% plot(smb); axis([0 length(smb) -.2 1.2])

[blocktrans,bog,bval]=find([smb; 0]-[0; smb]);

%blockstarts=blocktrans(1:2:length(blocktrans));
%blockends=blocktrans(2:2:length(blocktrans));
%blocklens=blockends-blockstarts;

%for ct=1:length(blocktrans)-1; fprintf('%d %d  %.3f\n',ct,blocktrans(ct),abs(std(dat(max(0,blocktrans(ct)-20):min(length(smb),10+blocktrans(ct)),1)))); end
goodmarker=ones(size(blocktrans));
for ct=1:length(blocktrans)-1
  if ((ct>1) | ((ct==1) & blocktrans(ct)>10)) & (abs(std(dat(max(1,blocktrans(ct)-20):min(length(smb),10+blocktrans(ct)),1)))<100)
   goodmarker(ct)=0;
  end
end

%clf; plot([dat(:,1) 100.*smb(:,1)]); hold on; for ct=1:length(blocktrans); plot(blocktrans(ct),1,'.r'); end

blocktrans=blocktrans(find(goodmarker));
goodmarker=ones(size(blocktrans));


% enforce that blocks must be at least 15 samples long
for ct=1:length(blocktrans)-1
  if abs((blocktrans(ct+1)-blocktrans(ct))<15) 
    %goodmarker(ct)=0; 
    goodmarker(ct+1)=0; 
    ct=ct+1;
  end
end
blocktrans=blocktrans(find(goodmarker));
if mod(length(blocktrans),2)==1, blocktrans=blocktrans(1:end-1); end


blocknum=1;
for ct=1:2:length(blocktrans)
  blockdata=dat(blocktrans(ct):blocktrans(ct+1),:);
  save(sprintf('%s%d.mat',fname,blocknum),'blockdata');
  %gdlmwrite(sprintf('%s%d',fname,blocknum),dat(blocktrans(ct):blocktrans(ct+1),:),' ');
  blocknum=blocknum+1;
end

fprintf('Done\n');
