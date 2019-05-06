function writecondmeanstext(pall,fname)
% Usage: writecondmeanstext(pall,fname)
% where pall is an array of subjects and
% fname is a filename to be written
% 
% Given an array of subjects, each of whom
% has a ConditionMeans field representing pupil
% dilation collected at Hz stored in a RescaleFactor
% field, this function writes a tab-delimited text 
% file with 0.25 second averages for each condition
% for each participant. The resulting file 
% should be readable in excel, SPSS, etc.
%
% Note: it uses the minimum number of conditions
% for any subject, so if some subjects 
% are missing conditions, the resulting file
% will be impoverished

if nargin<2
  fprintf('Usage: writecondmeanstext(pall,fname)\n');
end

nsubs=length(pall);

for ct=1:length(pall)
  nconds(ct)=size(pall(ct).ConditionMeans,1);
  nsamps(ct)=size(pall(ct).ConditionMeans,2);
end
ncondst=min(nconds);
nsampst=min(nsamps);

fp=fopen(fname,'w');
fprintf(fp,'ID\tCond');
for ct=1:length(gsresample(pall(1).ConditionMeans(1,:),pall(1).RescaleFactor,4))
  fprintf(fp,'\ts%d',(ct-1).*250);
end
fprintf(fp,'\n');
for ct=1:length(pall)
  for condnum=1:ncondst
    wav=gsresample(pall(ct).ConditionMeans(condnum,:),pall(1).RescaleFactor,4);
    fprintf(fp,'%d\t%d',pall(ct).id,condnum);
    for snum=1:length(wav)
      fprintf(fp,'\t%.3f',wav(snum));
    end
    fprintf(fp,'\n');
  end
end
fclose(fp);
fprintf('Output written to %s\n',fname);
