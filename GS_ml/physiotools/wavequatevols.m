function volchg=wavequatevols(scalefac)
% usage volchg=wavequatevols(scalefac)
% shows what percent volumes in wav files should change by
% to equate them all. Note, volumes are logarhythmic so 
% a conversion is needed.

if nargin<1, scalefac=1; end

% cd F:\greg-aux\papers\cbtfmri\software\moodmusic\fullwav

fils=dir('*.wav');
for ct=1:length(fils)
  fname=fils(ct).name;
  [f,s.Fs,s.bits,s.opt_ck]=gswavread(fname);
  if size(f,2)>1
    lefts=std(f(:,1));
    rights=std(f(:,2));
    msd(ct)=(lefts+rights)./2;
  else
    msd(ct)=std(f(:,1));
  end
  fprintf('%s - %.3f\n',fname,msd(ct));
  clear f;
end

mmsd=mean(msd);
volchg=mmsd./msd;



for ct=1:length(fils)
  fname=fils(ct).name;
  fprintf('writing %s\n',fname);
  f=gswavread(fname);
  f=f.*volchg(ct).*scalefac;
  wavwrite(f,s.Fs,s.bits,sprintf('e%s',fname));
  clear f;
end
