function tmpwav=gsrandauto2 (T,ro)
% restricts the timeseries returned by
% randauto to one with an autocorrelation in
% the desired range

acorr=0;
while ((acorr<ro-.05) | (acorr>ro+.05))
  %tmpwav=randauto(T,ro); % was gsrandauto
  tmpwav=gsrandauto(T,ro); 
  %SO: added above line - replaced randauto with gsrandauto b/c I don't have randauto
  acorr=autocorr(tmpwav);
end



