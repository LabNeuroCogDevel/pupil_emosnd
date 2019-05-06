function[scaledata]=mresample(data,origHz,newHz)
% rescales matrix data from origHz to newHz
% Useage: mresample(data,origHz,newHz)

if (newHz>origHz)
  fprintf(1,'newHz must not exceed origHz\n');
  return;
end


downscalefactor=newHz./origHz;
ptstoskip=round (1./downscalefactor);
newlen=round(size(data,2)./ptstoskip);
filterindex=fix( (1./downscalefactor)./2)-1;
scaledata=zeros(size(data,1),newlen);

for lnum=1:size(data,1)
     for i=1:newlen
       scaledata(lnum,i)=mean(data(lnum,min(size(data,2),max(1,i*ptstoskip-filterindex)):min(i*ptstoskip+filterindex,size(data,2))));
     end
end

