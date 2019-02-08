function [s,t,e, codes] = align_events(p)

s = p.TrialStarts;
t = p.TrialStim;
e = p.TrialEnds;

%% remove impossibles
% no target or end before first start
first=min(s);
e=e(e>first); t=t(t>first);
% no end before first target
e=e(e>min(t));
% only one end greater than the last target
i=find(e>max(t));
if length(i)>1, e=e(1:i(1)); end

t=t(t<max(e)); % no target after the last stop
s=s(s<max(t)); % no start after the last target

%% find best match (naive -- todo needleman welch?)
% all values in a cell (for indexing)
c={s, t, e};

% how short is the shortest, which is it
[shorest_len,shortest_i] = min(cellfun(@length, c));
% all the values of the shortest
shortest_val=c{shortest_i}; 

idx=nan(shorest_len,3);
dst=nan(shorest_len,3);
% for each of the shortests compute how far it is from the others
for col_num = 1:3
    col_vals = c{col_num};
    for i=1:shorest_len
        pos_or_neg = shortest_i - col_num ; % e.g short=2, looking=1; want neg
        diff = shortest_val(i) - col_vals;
        diff(pos_or_neg < 0 & diff > 0) = Inf; % want best lower; clear higher
        diff(pos_or_neg > 0 & diff < 0) = Inf; % want best higher; clear lower
        [dst(i,col_num), idx(i,col_num)] = min(abs(diff));
    end
    c{col_num} = col_vals(idx(:,col_num)); % reset values to best matches
    % TODO: what if best match is same for two indexes!?
end

s=c{1};
t=c{2};
e=c{3};
% stim codes from same index as target
codes = p.StimTypes(idx(:,2));



end

