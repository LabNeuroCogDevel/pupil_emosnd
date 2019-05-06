function narr=padneg(arr,newlen)
% pads an array to newlen by adding -999's at the end
% useage: narr=padneg(arr,newlen)
len=size(arr,2);
narr=-999.*ones(1,newlen);
narr(1,1:len)=arr;
