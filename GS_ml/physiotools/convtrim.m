function c=convtrim(a,b)
% usage: c=convtrim(a,b)
% convolves a with b and trims to length of a
c=conv(a,b);
c=c(1:length(a));
