
[wave,period,scale,coi] = wavelettk(p.curhrsmooth,1/100,1,.1,1,50);
ps=(abs(wave).^2);
[maxval,maxind]=max(mean(ps,2));
p.coherence=ps(maxind,:);


for ct=2000:10:size(ps-2000,2)
figure(1); plot(ps(:,ct)); axis([0 60 0 40000]);
figure(2); plot(p.curhr((ct-1900):(ct+1900))); axis([0 4000 50 110]);
drawnow;
end
