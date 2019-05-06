function exists=probe(fname)
% Probe examines whether a file exists
% Useage:exists=probe(fname) 
  fid=fopen(fname,'r');
  exists=fid+1;
  if exists
    fclose(fid);
  end
