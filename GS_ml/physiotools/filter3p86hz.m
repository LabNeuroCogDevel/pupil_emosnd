function filtwav=filter3p86hz(origwav)
% applies a 3.86hz low-pass filter to data
% which is equivalent to a 5-point moving average
% done using dbfilter

load c:\greg\matlab\physiotools\filter3p86hz.mat
filtwavnoffset=filter(b3p86,1,origwav);
lastpt = filtwavnoffset(end);
filtwav=[filtwavnoffset(9:end) lastpt lastpt lastpt lastpt lastpt lastpt lastpt lastpt];


