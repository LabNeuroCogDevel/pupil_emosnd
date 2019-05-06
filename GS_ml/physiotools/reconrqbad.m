% to reconstruct bad eeg data
%cd g:\greg\data\rumquest\eeg;

% rqreconbehav('1501.001','15a.lex','15','002');
% rqreconbehav('1501.002','15b.lex','15','002');
% rqreconbehav('1501.003','15.val','15','001');
% rqreconbehav('1501.004','15.sim','15','003');
% rqreconbehav('1601.001','16.lex','16','002');
% rqreconbehav('1601.002','16.val','16','001');
% rqreconbehav('1601.003','16.sim','16','003');

godatapath;
cd pupil;
rqreconbehav('501001.006','5010.sim','5010','003');
