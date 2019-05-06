function h = hotcold(m)
%HOT    Black-red-yellow-white-white-green-blue-black color map
%   HOT(M) returns an M-by-3 matrix containing a "hot" colormap.

if nargin < 1, m = size(get(gcf,'colormap'),1); end

incr=round(m./7);
%r=[linspace(.1,1,incr)';linspace(1,1,incr)'; linspace(1,1,incr)'; linspace(1,1,incr)';linspace(1,0,incr)';linspace(0,0,incr)';linspace(0,0,incr)'];
%g=[linspace(0,0,incr)'; linspace(0,.5,incr)';linspace(.5,1,incr)';linspace(1,1,incr)';linspace(1,1,incr)';linspace(1,0,incr)';linspace(0,0,incr)'];
%b=[linspace(0,0,incr)'; linspace(0,0,incr)'; linspace(0,1,incr)'; linspace(1,1,incr)';linspace(1,1,incr)';linspace(1,1,incr)';linspace(1,.1,incr)'];

r=[linspace(.1,1,incr)';linspace(1,1,incr)'; linspace(1,1,incr)'; linspace(1,1,incr)';linspace(1,0,incr)';linspace(0,0,incr)';linspace(0,0,incr)'];
g=[linspace(0,0,incr)'; linspace(0,.5,incr)';linspace(.5,1,incr)';linspace(1,1,incr)';linspace(1,1,incr)';linspace(1,0,incr)';linspace(0,0,incr)'];
b=[linspace(0,0,incr)'; linspace(0,0,incr)'; linspace(0,1,incr)'; linspace(1,1,incr)';linspace(1,1,incr)';linspace(1,1,incr)';linspace(1,.1,incr)'];


h=[r g b];

%h=flipud(h(1:m,:));
h=flipud(h);

% a=hotcold; plot(a(:,1),'r'); hold on; plot(a(:,2),'g'); plot(a(:,3),'b');
