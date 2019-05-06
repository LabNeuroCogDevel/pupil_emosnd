function [etasq,rsq]=getetasqfromf(F,dfnum,dfden)
% etasq=getetasqfromf(F,dfnum,dfden)
etasq=F.*dfnum./((F.*dfnum)+dfden);
rsq=F.*dfnum./((F.*dfnum)+(dfnum+1)*dfden);
