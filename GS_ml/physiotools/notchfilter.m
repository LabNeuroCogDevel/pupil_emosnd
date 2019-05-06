function filtts=notchfilter(ts,notchfreq,samprate)
% filters a timeseries for a given frequency
% by notching out the frequency and the two points around it in frequency space
% usage: filtts=notchfilter(ts,notchfreq,samprate)
% by Greg Siegle, 7/24/03

if nargin<3, samprate=62.5; end

fn=fft(ts);
npts=length(ts);
pttofilt=round((notchfreq.*npts./2)./((samprate-1)./2))-1;
fn(pttofilt-2:pttofilt+2)=0;
fn((npts-pttofilt)-2:(npts-pttofilt)+2)=0;
filtts=real(ifft(fn));

%figure(1); plot(p.RawPupil); figure(2); plot(p.FiltPupil);
