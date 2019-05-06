function [R2]=setcorr(X,Y)
  R2=1-(det(corrcoef([X Y]))./(det(corrcoef([X])).*det(corrcoef([Y]))));

