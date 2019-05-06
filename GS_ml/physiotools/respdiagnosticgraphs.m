function respdiagnosticgraphs(data)
% plots resp diagnostic graphs
% usage: respdiagnosticgraphs(data)
if nargin<2, plotdetrend=0; end

figure;

    maxy=max(max(data.RescaleData));
    eventscale=maxy./max(max(data.EventTrain));
    plot([data.RescaleData' data.Filtered eventscale.*data.EventTrain data.RespAbs]);
    legend('Raw resp','scaled', 'event','Magnitude');
    axis tight;
    ylabel('_{\mu}V');
    xlabel('tick');
    title (sprintf('%s diagnostic plot',data.FileName));

scrollplot(data.RawResp);
xlabel('Raw RESP');
ZoomSlider=findobj('Tag','ZoomSlider');
set(ZoomSlider,'value',.01);
zoomslider;

