function filtwav=filter6p73hz(origwav)
% applies a 6.73hz low-pass filter to data
% which is equivalent to a 3-point moving average
% done using dbfilter

load c:\greg\matlab\physiotools\filter6p73hz.mat
filtwavnoffset=filter(b673,1,origwav);
lastpt = filtwavnoffset(end);
filtwav=[filtwavnoffset(7:end) lastpt lastpt lastpt lastpt lastpt lastpt];


