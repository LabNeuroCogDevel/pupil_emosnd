function [m]=readbehav(fname)
% reads a behavioral file from the rumquest experiment
fp=fopen(fname,'r');
a=fscanf(fp,'%s\t%s',[8,inf]);
fclose(fp);


