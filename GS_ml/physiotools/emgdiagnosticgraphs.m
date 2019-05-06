function emgdiagnosticgraphs(data,plotdetrend)
% plots emg diagnostic graphs
% usage: emgdiagnosticgraphs(data,plotdetrend)
if nargin<2, plotdetrend=0; end

figure;

    maxy=max(max(data.NoBlinks));
    eventscale=maxy./max(max(data.EventTrain));
    if plotdetrend
      plot([data.RescaleData' data.NoBlinks eventscale.*data.EventTrain data.NoBlinksDetrend]);
      legend('emg','rms', 'event','detrend rms');
    else
      plot([data.RescaleData' data.NoBlinks eventscale.*data.EventTrain]);
      legend('emg','rms', 'event');
    end
    axis tight;
    ylabel('_{\mu}V');
    xlabel('tick');
    title (sprintf('%s diagnostic plot',data.FileName));

scrollplot(data.RawEmg);
xlabel('Raw EMG');
ZoomSlider=findobj('Tag','ZoomSlider');
set(ZoomSlider,'value',.01);
zoomslider;

