function s1 = depreblank(s)
%DEPREBLANK Remove beginning blanks.
%   DEPREBLANK(S) removes beginning blanks from string S.
%
%   DEPREBLANK(C), when C is a cell array of strings, removes the trailing
%   blanks from each element of C.

%   from deblank.m by L. Shure, 6-17-92. Copyright (c) 1984-98 by The MathWorks, Inc.
%   Revision Greg Siegle, 8-28-01

% The cell array implementation is in @cell/deblank.m

if ~isempty(s) & ~isstr(s)
    warning('Input must be a string.')
end

if isempty(s)
    s1 = s([]);
else
  % remove trailing blanks
  [r,c] = find((s ~= ' ') & (s ~= 0) & (s~='	'));
  if isempty(c)
    s1 = s([]);
  else
    s1 = s(:,min(c):end);
  end
end
