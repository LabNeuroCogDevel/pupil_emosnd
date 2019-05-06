function zs=z(v)
% returns z scores for vector v
% useage: zs=z(v)

zs=(v-mean(v))./std(v);
