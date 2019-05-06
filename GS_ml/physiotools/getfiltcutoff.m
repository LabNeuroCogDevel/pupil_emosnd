function cutoff=getfiltcutoff(origwav,filtwav,samprate)
% usage: cutoff=getfiltcutoff(origwav,filtwav,samprate)
% returns the corner frequency for the filtered waveform
% i.e., the frequency above which data is not well represented
% says for example that filtwav is an n-Hz low-pass filter of origwav
% Now... to make a better-controlled version go into the 
% signal processing toolbox and make that filter explicitly 
% as an FIR window filter with Fs of samprate and filter order of the
% maximum number of points I'm willing to sacrifice with 
% fc= whatever it takes to make the graph have -3 db come
% out at the cutoff Hz I'm looking for (hint, should start
% looking with fc=cutoff and work from there). Scale passband
% shold be checked and beta=1.
% Use file->export to save it to a matlab workspace, and
% apply it with filter as in filter10hz.m
[ipxx w]=psd(origwav,1024,samprate);
[opxx w]=psd(filtwav,1024,samprate);
im=abs(ipxx);
om=abs(opxx);
h=om./im;
hdb=10*log10(h);
plot(w,hdb)
ylabel('gain (db)'); 
xlabel('hz');
%[mn cutoffind]=min(hdb+3);
%cutoff=w(cutoffind);

[mn inx]=min(abs(abs(hdb)-3));
cutoff=w(inx);
