function p=dopupilextrafancy(p)
% compute fourier and wavelet transforms on pupil p
% note: depends on having sandyblinked p which rescales to my level

p.UnexpectedBursts=compute_details(p.NoBlinks,3,2);


  % make unfiltered p for wavelet transform 
%  p.unfiltered=p.RawPupil.*(1-p.BlinkTimes)+p.NoBlinks.*p.BlinkTimes;
%  [SmoothWavelet,FastWavelet] = dwt(p.unfiltered,'db2');
%  p.SmoothWavelet=resample(SmoothWavelet,length(SmoothWavelet),length(p.NoBlinks));
%  p.FastWavelet=resample(FastWavelet,length(FastWavelet),length(p.NoBlinks));
%  p.Frequencies=abs(fft(p.NoBlinks));

