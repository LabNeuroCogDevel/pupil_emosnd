function newct=justletters(str)
% removes non-letters from str

newct='';
lct=1;
for ct=1:length(str)
  if isletter(str(ct)), newct(lct)=str(ct); lct=lct+1; end
end
