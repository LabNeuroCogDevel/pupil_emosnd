function pupphaseplotanim(pall,sub)
if nargin<2,sub=15; end
clf; 
for ct=200:1000
  plot(pall(sub).NoBlinks(10000:18000)-pall(sub).NoBlinks(10000+100:18000+100),pall(sub).NoBlinks(10000:18000)-pall(sub).NoBlinks(10000+ct:18000+ct))
  title(ct);
  pause
end
