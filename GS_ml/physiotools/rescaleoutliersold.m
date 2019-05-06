function mnew=rescaleoutliers(m,threshold)
% given a matrix rescales each COLUMN
% using the method outlined in Siegle et al (2000).
% That is, outliers, defined as outside threshold*IQR from the median
% are rescaled to slightly (1 std err) outside the maximum in
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

missing=(abs(m)==999);

medm=median(m);
iqrm=iqr(m);

lbm=m<repmat(medm-threshold.*iqr(m),size(m,1),1);
ubm=m>repmat(medm+threshold.*iqr(m),size(m,1),1);

outlier=(lbm | ubm);
mnew=(1-outlier).*m+outlier.*repmat(medm,size(m,1),1);
stderr=std(mnew)./sqrt(size(mnew,1));
maxgood=max(mnew)+stderr;
mingood=min(mnew)-stderr;
mnew=(1-lbm).*m+lbm.*repmat(mingood,size(m,1),1);
mnew=(1-ubm).*mnew+ubm.*repmat(maxgood,size(m,1),1);
mnew=(1-missing).*mnew+missing.*-999;
