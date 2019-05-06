function mapping=getmapping(list1,list2)
% with 2 vectors, finds the position of every element of list 1 in list 2
% usage: mapping=getmapping(list1,list2)

for ct=1:length(list1)
  mpos=position(list1(ct),list2);
  if isempty(mpos) mapping(ct)=0; else mapping(ct)=mpos; end
end

