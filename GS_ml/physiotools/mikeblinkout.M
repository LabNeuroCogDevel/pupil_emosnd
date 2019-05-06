function right=mikeblinkout(right)

left=right;

%a =  a*1;
if ~exist('a','var')
   a=[];
end
[ng pg] = size(a);

if isempty(a)
   pg  = input('type in the number of seconds per stimulus     ')
   pg = pg * 60;
end

% remove blinks
srd = [];sld = [];
b = []; c = [];d = []; e = [];
[n p ] = size(right);garbr = 1;garbl = 1;
 crd  = []; brd = [];
   nleft=left(1,:); , nright=right(1,:);
   right = nright; left = nleft;
   rd=diff(right); ld=diff(left); rdd  = diff(rd); ldd  = diff(rd);
   w=5;x = 1;
rs=1.0*std(rd);
ls=1.0*std(ld);
rm=mean(rd); , lm=mean(ld);
[n,p]=size(rd);
i =w;

while i < p-15  
   if ((abs(rd(i)-rm)>3.7*rs | abs(rd(i) + rd(i+1)) > 3.7*rs)) & mod(i,pg) > 50 
      
      c = [c i];
             
      if pg-fix(mod(i,pg)) > 41 
         x = i+40;
      else
         x= i + pg-fix(mod(i,pg))-1;
      end
      
      while ( abs(rd(x)-rm) < 2*rs | abs(rd(x) + rd(x-1)) < 2*rs ) & abs(rd(1,x)) < .1 & x > i            
          x = x-1;
      end
       
      b = [b x+1];
 %                   brd   =  [brd x rd(x) rdd(x)];
      x = 0;i = i+40;
                     
   else
      i = i+1;
   end
   i = i+1;
  
end
[n p] = size(c);

for i = 1:p
   if b(i) - c(i) > 40 & rd(i) > .4
      % input('hello')
      % pltblkr
   end
   
   if  isempty(garbr) == 0
      
      if b(i) == c(i) +1
         right(b(i)) = (right(b(i)+1) + right(c(i)))/2;
      else   
   			y1=right(1,c(i)-1) ;
   			y2=right(1,b(i)+1);
   			slope=(y2-y1)/(b(i)+2-c(i));
   			j=c(i):b(i);
     			right(1,j)=y1+(j-c(i))*slope;
           end
        else 
        end
        
           
     garbr = 1;      
   %  end
end


% THIS WILL DO THE LEFT EYE
[n p] = size(left);
i = w;
while i < p-15
   if ((abs(ld(i)-lm)>3.7*ls | abs(ld(i) + ld(i+1)) > 3.7*ls)) & mod(i,pg) > 50
      
      d = [d i];
      
      if pg-fix(mod(i,pg)) > 41 
         x = i+40;
      else
         x= i + pg-fix(mod(i,pg))-1;
      end
      
      while ( abs(ld(1,x)-lm) < 2*ls | abs(ld(x) + ld(x-1)) < 2*ls ) & abs(ld(1,x)) < .1 & x > i
          x = x-1;
       end
       
       e = [e x+1];
 %    	    bld   =  [bld x ld(x) ldd(x)];
       x = 0;i = i+40;              
     else
             i = i+1;
     end
     i = i+1;
  
end
[n p] = size(e);
for i = 1:p
   if e(i) - d(i) > 20 & ld(i) > .4
      %pltblkl
   end
   
   if  isempty(garbl) == 0 
   
   	if e(i) == d(i) +1
      	left(e(i)) = (left(e(i)+1) + left(d(i)))/2;
   	else
      
   		y1=left(1,d(i)-1) ;
   		y2=left(1,e(i)+2);
   		slopel=(y2-y1)/(e(i)+3-d(i));
   		j=d(i):e(i)+1;
      	left(1,j)=y1+(j-d(i)+1)*slopel;
   	end

	end
end

% clear lm ls n   slopel brd c crd d e i j ld ldd
% clear rd rdd p w x y1 y2 w srd slope slope1 sld rs rm b  

clf
plot(nright)
hold
plot(right,'r')
input(' ')
hold
plot(nleft,'k')
hold
plot(left,'g')
input(' ')
hold
