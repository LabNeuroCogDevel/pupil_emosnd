function nrand=gsrandauto(T,ro)
% gets T random numbers with autocorrelation ro

startrand=rand(1,T)-.5; nrand=startrand;
au=autocorr(startrand);
convbound=.005; ccg=10;

convlen=round(T./2);
nrand=conv(startrand,ones(1,convlen)./convlen);
nrand=nrand(round(convlen./2):round(convlen./2)+T-1);
au=autocorr(nrand); 
if au>ro, minc=1; maxc=convlen;
else minc=convlen; maxc=T; 
end

while ((abs(au-ro)>convbound) & (ccg>1))
  nconvlen=round((minc+maxc)./2);
  nrand=conv(startrand,ones(1,convlen)./convlen);
  nrand=nrand(round(convlen./2):round(convlen./2)+T-1);
  au=autocorr(nrand); 
  %fprintf('Convlen = %d. Autocorr=%.3f\n', convlen, au);
  if (au-ro)>0, 
    maxc=nconvlen;
  else 
    minc=nconvlen;
  end
  ccg=abs(convlen-nconvlen); convlen=nconvlen;
end
nrand=nrand';

