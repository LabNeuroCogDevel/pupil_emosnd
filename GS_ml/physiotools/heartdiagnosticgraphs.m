function heartdiagnosticgraphs(data)
% plots heart diagnostic graphs
% usage: heartdiagnosticgraphs(data,plotdetrend)
if nargin<2, plotdetrend=0; end

figure;

    maxy=max(max(data.Filtered));
    eventscale=maxy./max(max(data.EventTrain));
    plot([data.RescaleData' data.Filtered eventscale.*data.EventTrain]);
    legend('heart','Filtered', 'event');
    axis tight;
    ylabel('_{\mu}V');
    xlabel('tick');
    title (sprintf('%s diagnostic plot',data.FileName));

scrollplot(data.RawHeart);
xlabel('Raw HEART');
ZoomSlider=findobj('Tag','ZoomSlider');
set(ZoomSlider,'value',.01);
zoomslider;

