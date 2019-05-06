function mnew=rescaleoutliers(m,threshold)
% given a matrix Windzorizes each COLUMN
% That is, outliers, defined as outside MD+/-(IQR+threshold*IQR)
% are rescaled to the maximum in the direction they went 
% outside the valid interval.
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
q1=prctile(m,25);
q3=prctile(m,75);

lbm=m<repmat(q1-threshold.*iqr(m),size(m,1),1);
ubm=m>repmat(q3+threshold.*iqr(m),size(m,1),1);

outlier=(lbm | ubm);
mnew=(1-outlier).*m+outlier.*repmat(medm,size(m,1),1);
maxgood=max(mnew);
mingood=min(mnew);
mnew=(1-lbm).*m+lbm.*repmat(mingood,size(m,1),1);
mnew=(1-ubm).*mnew+ubm.*repmat(maxgood,size(m,1),1);
mnew=(1-missing).*mnew+missing.*-999;
