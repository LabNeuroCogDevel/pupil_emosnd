function indwav=findclosestindex(wav,inds)
% usage: indwav=findclosestindex(wav,inds)
% given a waveform and a set of indices, maps the waveform
% to the position of the closest indices.
% note: wav and inds MUST be row vectors

indsmat=repmat(inds', 1,length(wav));
wavmat=repmat(wav,length(inds),1);

[val,indwav]=min(abs(wavmat-indsmat));


