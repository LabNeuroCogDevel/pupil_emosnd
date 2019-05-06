function vec=interpmissing (vec,missingvalue)
% linearly interpolates missing values

if nargin<2, missingvalue=-999; end

if length(vec)==0
  fprintf ('vector empty\n'); 
  return; 
end


allmissing=find(vec==missingvalue);
notmissing=find(vec~=missingvalue);

if length(notmissing)==0, 
  fprintf('all values missing\n'); 
  vec=zeros(size(vec));
  return;
end

  
if vec(1)==missingvalue, 
  vec(1:notmissing(1))=vec(notmissing(1)); end
if vec(end)==missingvalue, 
  vec(notmissing(end):end)=vec(notmissing(end)); 
end

allmissing=find(vec==missingvalue);
notmissing=find(vec~=missingvalue);
justmissing=(vec==missingvalue);
if size(vec,1)==1
  missingtrans=[0 (justmissing(2:end)-justmissing(1:(end-1))) 0];
else
  missingtrans=[0; (justmissing(2:end)-justmissing(1:(end-1))); 0];
end

missingstarts=find(missingtrans==1);
missingends=find(missingtrans==-1)-1;

for ct=1:length(missingstarts)
  x1=missingstarts(ct)-1; y1=vec(x1);
  x2=missingends(ct)+1; y2=vec(x2);
  m=(y2-y1)/(x2-x1);
  b=y2-m.*x2;
  vec(x1:x2)=m.*(x1:x2)+b;
end


%for ct=1:length(allmissing)
%  tmp=find(notmissing<allmissing(ct)); prevgood=notmissing(tmp(end));
%  tmp=find(notmissing>allmissing(ct)); nextgood=notmissing(tmp(1));
%  x1=prevgood; y1=vec(prevgood);
%  x2=nextgood; y2=vec(nextgood);
%  m=(y2-y1)/(x2-x1);
%  b=y2-m.*x2;
%  vec(allmissing(ct))=m.*allmissing(ct)+b;
%end

