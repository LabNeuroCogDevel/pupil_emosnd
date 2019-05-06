function b=readeprime(fname,procname,fields,breaksevery,startoffset,endoffset,badprocname,altprocname)
% reads an e-prime file 
% for each occurrance of procname
%   finds values at each of the offsets and stores them
% returns
%   data=all data
%   numdata= numeric data in a matrix
% usage: b=readeprime(fname,procname,fields,breaksevery,startoffset,endoffset)
%  input arguments:
%    fields is a cell array of field names
%    startoffset and endoffset are the number of lines around a
%    procedure name to check for relevant data
%     note: a field is defined as a line with a ':' so
%     lines specifying logframes should NOT count towards the total
% In English:
%  To use it you must specify a filename, the procedure in which your
%  variables of interest occur, the variables of interest, 
%  how many trials there are between blocks (if the eprime code 
%  accounts for blocks by doing something wierd), as well as 
%  offsets specifying the window in which your variables of interest
%  are likely to occur relative to the beginning of the trial.
%    If you want to read variables that occur in two different
%  procedures (e.g., you have an alternating task design that
%  alternates between cue and probe trials and want to read stuff
%  about each of them), just call readeprime twice.
% example call:
%   b=readeprime(fname,'TrialProc',{'Condition','numstim', ...
%	      'Probe.RT','Probe.RESP','Probe.CRESP'},18,-3,17);


if nargin<4, breaksevery=0; end
if nargin<5, startoffset=-4; end
if nargin<6, endoffset=17; end
if nargin<7, badprocname='bogusproc'; end
if nargin<8, altprocname='notaproc'; end

if (~probe(fname)), fprintf('%s not found - erroring out...\n',fname); end

b.fname=fname;

% read the raw text file 
rawtxt=textread(fname,'%s','delimiter',':\n','whitespace',''); % had whitespace be \n

% strip out non-fields
index=1;
for ct=1:length(rawtxt)
  if (isempty(findstr('***',char(rawtxt(ct)))) & (length(char(rawtxt(ct)))))
    txt(index)=rawtxt(ct); index=index+1;
  end
end

% get lines on which the correct procedure occurs
index=0;
proclines=0;
for ct=1:length(txt)-1
if (findstr('Procedure',char(txt(ct))) & findstr(lower(procname),lower(char(txt(ct+1)))) & (isempty(findstr(lower(badprocname),lower(char(txt(ct+1))))))) | (findstr('Procedure',char(txt(ct))) & findstr(lower(altprocname),lower(char(txt(ct+1)))) & (isempty(findstr(lower(badprocname),lower(char(txt(ct+1)))))))
    index=index+1; proclines(index)=ct;
  end
end

if breaksevery==0, 
  numblocks=0;
else
  numblocks=floor(index./breaksevery);
end

data=cell(index-numblocks,length(fields));
numdata=zeros(index-numblocks,length(fields))-999;
line=0;
for ind=1:index
  if ((breaksevery==0) | (mod(ind,breaksevery+1)~=1))
    line=line+1;
    for field=1:length(fields)
     unfound=1;
     for candidate=proclines(ind)+2.*startoffset:proclines(ind)+2.*endoffset;
      if (unfound & (strcmp(char(fields(field)),depreblank(char(txt(candidate))))))
	unfound=0;
        data(line,field)=txt(candidate+1);
	%if ~isempty(which(justletters(char(data(line,field)))))
	if (stringinset(char(data(line,field)),{'pretty','shower','gray','home','spring','cool','bench','white','light','waterfall','true','today','tree','clock','summer','winter','fall','down','write','float'}))
	  numval=[];
        else
  	  numval=str2double(char(data(line,field)));
	  if isnan(numval), numval=[]; end
        end
	%if field==1, fprintf('line=%d, data=%s\n',line,char(data(line,field))); end
	if (~isempty(numval))
	  numdata(line,field)=numval;
	  %fprintf('line=%d,field=%d, data=%s, numval=%d\n',line,field,char(data(line,field)),numval);
	else
	  numdata(line,field)=-999;
	end
      end
     end
    end
  end
end

if cellfun('isempty',data(end,1))
  data=data(1:end-1,:);
  numdata=numdata(1:end-1,:);
end

for ct=1:length(fields)
  if max(numdata(:,ct))==-999
    curdata=data(:,ct);
  else
    curdata=numdata(:,ct);
  end
  fldname=strrep(char(fields(ct)),'.','_');
  
  b=setfield(b,fldname,curdata);
end
