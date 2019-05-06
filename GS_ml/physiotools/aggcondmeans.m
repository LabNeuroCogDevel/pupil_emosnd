function aggstats=aggcondmeans(data)
fields=fieldnames(data.stats);
aggstats.FileName=data.FileName;
for ct=1:length(fields)
    fieldmean=condmeans(data.TrialTypes',getfield(data.stats,char(fields(ct))),data.drops');
    aggstats=setfield(aggstats,char(fields(ct)),fieldmean);
end
