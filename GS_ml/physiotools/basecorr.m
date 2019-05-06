function tsbasecorrreshape=basecorr(ts,scanspertrial,scantonormto)
if nargin<2, scanspertrial=8; end;
if nargin<3, scantonormto=8; end
tsreshape=reshape(ts,scanspertrial,length(ts)./scanspertrial)';
baselinematrix=repmat(tsreshape(:,scantonormto),1,scanspertrial);
tsbasecorr=((tsreshape-baselinematrix)./baselinematrix).*100;
tsbasecorrreshape=reshape(tsbasecorr',length(ts),1);
