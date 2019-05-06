function [square]=makesquare(array)
% makes a square matrix out of an array
len=size(array,2);
slen=round(sqrt(len));
square=zeros(slen-1,slen);
for count=0:slen-2
  square(1+count,:)=array((1+count.*slen):((count+1).*slen));
end

