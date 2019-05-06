function found=stringinset(str,strset)
% says whether any of the strset is in str
found=0;
for ct=1:length(strset)
  strprobe=char(strset(ct));
  if findstr(strprobe,str), found=1; return;
  end
end
