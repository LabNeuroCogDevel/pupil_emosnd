all_files = dir('/Volumes/L/bea_res/Data/Tasks/CogEmoSoundsBasic/1*/2*/Raw/EyeData/txt/*.1.data.txt');
means={};
p={};
for i = 1:length(all_files)
    f = all_files(i);
    try
        [ means{i}, p{i} ] = run_pupil( fullfile(f.folder,f.name) );
        close all
    catch
        fprintf('file issue %s', f) 
    end
end