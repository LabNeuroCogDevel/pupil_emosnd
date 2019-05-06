function [slopeval]=slope(y)
% returns the slope of a row vector y
% or a matrix of row vectors y
% Useage: slope(y)

% slope = corr(x,y)*(sy/sx)

if size(y,1)~=1
   %fprintf(1,'input must be a row vector. Reorienting.\n');
   y=y';
end

x=(1:size(y,2));
%corr=corrcoef(y,x);
%slopeval=corr(1,2).*(std(y)./std(x));
%slopeval=regress(y', (1:size(y,2))');

for ct=1:size(y,1)
  corr=corrcoef(y(ct,:),x);
  slopeval(ct)=corr(1,2).*(std(y(ct,:))./std(x));
end
