function b=readeprime(fname,procname,offsets,breaksevery)
% reads an e-prime file 
% for each occurrance of procname
%   finds values at each of the offsets and stores them
% returns
%   b.data=all data
%   b.numdata= numeric data in a matrix
% input arguments:
%    offsets: vector containing line number offsets of desired
%        field from procedure line (can be negative)
%    note: a field is defined as a line with a ':' so
%    lines specifying logframes should NOT count towards the total
%   in a matrix of size #trials x #variables
% usage: b=readeprime(fname,procname,offsets,breaksevery)

if nargin<4
  breaksevery=0;
end



b.fname=fname;
b.offsets=offsets;

% read the raw text file 
rawtxt=textread(fname,'%s','delimiter',':\n','whitespace','\n');

% strip out non-fields
index=1;
for ct=1:length(rawtxt)
  if isempty(findstr('***',char(rawtxt(ct))))
    txt(index)=rawtxt(ct); index=index+1;
  end
end

% get lines on which the correct procedure occurs
index=0;
proclines=0;
for ct=1:length(txt)-1
  if (findstr('Procedure',char(txt(ct))) & findstr(procname,char(txt(ct+1))))
     index=index+1;
     proclines(index)=ct;
  end
end

numblocks=floor(index./breaksevery);
b.data=cell(index-numblocks,length(offsets));
b.numdata=zeros(index-numblocks,length(offsets))-999;
line=0;
for ind=1:index
  if ((breaksevery==0) | (mod(ind,breaksevery+1)~=1))
    line=line+1;
    for offset=1:length(offsets)
      b.data(line,offset)=txt(proclines(ind)+offsets(offset).*2+1);
      numval=str2num(char(b.data(line,offset)));
      if ~isempty(numval)
	b.numdata(line,offset)=numval;
      end
    end
  end
end
