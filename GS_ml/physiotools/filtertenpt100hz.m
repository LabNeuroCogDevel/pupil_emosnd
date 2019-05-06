function filtwav=filtertenpt100hz(origwav)
% applies a 10 point moving average low-pass filter to data
% got through Fs=100, Fc=3.8, FIR Window filter in sig proc toolbox filter construction
% see getfiltcutoff for details on how to construct these


%SO: adjusted this line 11/15/09 - make sure to open this mat file (will
%not disrupt existing workspace - just add one file)
%load c:\greg\matlab\physiotools\filtertenpt100hzfilt.mat
filtwavnoffset=filter(tenpt100hzfilt,1,origwav);
lastpt = filtwavnoffset(end);
filtwav=[filtwavnoffset(9:end) lastpt lastpt lastpt lastpt lastpt lastpt lastpt lastpt];
%filtwav=filtwav+(origwav(50)-filtwav(50));
