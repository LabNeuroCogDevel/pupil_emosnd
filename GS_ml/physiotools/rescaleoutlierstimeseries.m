function mnew=rescaleoutlierstimeseries(m,threshold)
% given a matrix rescales each COLUMN
%    that is, assumes each COLUMN is a time-series
%    and rescales data in each COLUMN by interpolating its
%    timeseries through the COLUMN
% like windsorizing but so as not to cause timeseries outliers...
% That is, outliers, defined as outside threshold*IQR from q1 and q3
% are rescaled to the last good value in THIER OWN timeseries
% the direction they went outside the valid interval.
% usage: mnew=rescaleoutliers(m,threshold)
% threshold defaults to 1.5




% test with m=rand(10,4); m(2,2)=17; m(8,3)=10;

if nargin<2
  threshold=1.5;
end

if ((size(m,1)==1) & (size(m,2)>1))
   fprintf('Needs columnar data. Reorienting\n');
   m=m';
end

missing=((abs(m)==999) | (m==inf) | (m==-inf));

medm=median(m);
iqrm=iqr(m);
q1=prctile(m,25);
q3=prctile(m,75);


lbm=m<repmat(q1-threshold.*iqr(m),size(m,1),1);
ubm=m>repmat(q3+threshold.*iqr(m),size(m,1),1);


outlier=(lbm | ubm);
mnew=(1-outlier).*m+outlier.*-999;
for ct=1:size(mnew,2)
  mnew(:,ct)=interpmissing(mnew(:,ct));
end
mnew=(1-missing).*mnew+missing.*-999;
