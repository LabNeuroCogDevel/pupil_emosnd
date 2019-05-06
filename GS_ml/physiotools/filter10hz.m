function filtwav=filter10hz(origwav)
% applies a 10hz low-pass filter to data

load c:\greg\matlab\physiotools\filter10hz.mat
filtwavnoffset=filter(b10,1,origwav);
lastpt = filtwavnoffset(end);
filtwav=[filtwavnoffset(6:end) lastpt lastpt lastpt lastpt lastpt];


