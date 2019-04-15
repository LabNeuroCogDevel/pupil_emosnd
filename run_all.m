addpath(genpath('/Volumes/L/bea_res/Oxford Eye Experiments/CogEmotStudy_Data/CogEmotStudy_Eye_Data/Pupil Processing_GregSiegle/GregSiegle_Matlab/matlabtoolkit'))
cd ('/Volumes/Zeus/MMY1_EmoSnd/pupil')

all_files = dir('/Volumes/L/bea_res/Data/Tasks/CogEmoSoundsBasic/1*/2*/Raw/EyeData/txt/*.data.txt');
m={};
p={};
b={};
for i = 1:length(all_files)
    f = all_files(i);
    fname = fullfile(f.folder,f.name);
    try
        [ m{i}, p{i} ] = run_pupil( fname );
        close all
    catch
        fprintf('file issue %s\n', fname) 
        b{i}=fname;
    end
end

fid=fopen('pupil_means.txt','w')

for i=1:length(all_files)
    if i>length(m) || isempty(m(i)) || length(m{i})<5, continue, end
    fprintf(fid,'%s\t', all_files(i).name)
    fprintf(fid,'%.04f\t',m{i})
    fprintf(fid,'%d', nnz(p{i}.drops));
    fprintf(fid,'\n')
end
fclose(fid)

