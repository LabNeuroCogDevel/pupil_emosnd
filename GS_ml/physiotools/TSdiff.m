% Type III TAYLOR SERIES (MAXFLAT) FIR low pass Differentiating Filter.
% Author: Alejandro Fernandez-Villa
% eMail:  alexfv@optonline.net
% 
% $Date: 04/21/2006 all rights reserved.$ 
% References: Maximum Flat Digital Differentiator.  Electronic Letters 11th
%             April 1991;27:675-677
% ***********************************************************************
% prefilter3 : Prefilter Included, FIR - Nutall WINDOW.
% Inputs
% y  : input signal.
% fs : Sampling Frequency.
% fc : (Approximated) CutOff Frequency.
% tfc: true cutoff frequency.
% messag: compute the true cutoff frequency
% plotresp: Plot the differentiators response
% Outputs
% dy: derivative
% fy: filtered version of y.
% tfc: true cut off frequency ( 3dB).
% forder: filter Order.
% FORMAT: [dy,fy,tfc,b]=TSdiff(y,fs,N,fc,forder,plotresp)
% USAGE : Recommend N=50 fc=100 forder=50;

function [dy,fy,tfc,b]=TSdiff(y,fs,N,fc,forder,messag,plotresp)
if nargin<2, fs=60; end % Greg defaults for 60Hz 
if nargin<3, N=8; end
if nargin<4, fc=26; end
if nargin<5, forder=8; end

if nargin<6, messag=0;   end
if nargin<7, plotresp=0; end
dy=[];Amp=[];tfc=0;b=0; fy=y;

% Check Cutoff frequency
if fc>(.5*fs)-4
    disp('Cutoff frequency too close to the frequency band limit')
    return
end

% Prefilter
if fc~=0
    bf = fir2(forder,[0 (fc*2)/fs (fc*2)/fs 1],[1 1 0 0],nuttallwin(forder+1));
    bf=bf./sum(bf);
    fy=filter(bf,1,y);
    fy=fy(round((length(bf)-1)/2)+1:end);
    if messag==1
        [hf w]=freqz(bf,1,1024,fs);
        hf=(abs(hf)).^2;
        [mn indx]=min(abs(hf-.5));
        tfc=w(indx);
        disp(['True Cut off Frequency: ' num2str(tfc) 'Hz']);
    end
end

% Differentiators Coefficients.
b=[];
b(1)=2*N/(N+1);
for m=1:N-1
    b(m+1)=-m*(N-m)*b(m)/((m+1)*(N+m+1));
end
b=.5*[fliplr(b) 0 -(b)];
[h w]=freqz(b,1,1024);h=abs(h)/pi;w=w/pi;

% Plot responses.
if plotresp==1
    figure();
    plot(w,h.*(hf.^.5)); hold all ; plot(w,w);
    title(['Gain Response FILTER+DIFF, Order' num2str(N)])
    xlabel('Normalized Frequency (\omega/\pi)')
    ylabel('|H(j\omega)|')
    figure();
    warning off
    plot(w*fs*.5,20*log10((h.*(hf.^.5))./w))
    title(['Low Pass Filter Response, Order' num2str(N)])
    warning on
    xlabel('Frequency (Hz)')
    ylabel('Power Spectral Density (dB)')
end

% Apply Differentiator.
len=length(b);
dy=filter(b,1,fy)*fs;
dy=dy(1+((len-1)/2):end);
return