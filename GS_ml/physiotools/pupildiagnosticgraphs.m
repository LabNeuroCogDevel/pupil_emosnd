function pupildiagnosticgraphs(data,plotdetrend)
% plots pupil diagnostic graphs
% usage: pupildiagnosticgraphs(data,plotdetrend)
if nargin<2, plotdetrend=0; end

figure('Name','Pupil Diagnostic','Tag','PupilDiagnostic');

    maxy=max(max(data.NoBlinks));
    eventscale=maxy./max(max(data.EventTrain));
    if plotdetrend
      plot([data.RescaleData' data.NoBlinks eventscale.*data.EventTrain data.NoBlinksDetrend]);
      legend('pupil','rblnk', 'event','detrend');
    else
      plot([data.RescaleData' data.NoBlinks eventscale.*data.EventTrain]);
      legend('pupil','rblnk', 'event');
    end
    axis tight;
    ylabel('mm diameter');
    xlabel('tick');
    title (sprintf('%s diagnostic plot',data.FileName));
