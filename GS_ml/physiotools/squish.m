function vecn=squish (vec)
% makes a vector fit between 0 and 1
% usage: vecn=squish (vec)

vecn=(vec-min(vec))./(max(vec)-min(vec));
