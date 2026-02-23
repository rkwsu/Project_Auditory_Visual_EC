% ===== B: run_single_test.m =====
function run_single_test(fileIdx, j, task, duration, Delay_bins, datadir, outputdir_base)

files = dir(fullfile(datadir, '*.xlsx'));
file_name = files(fileIdx).name;
fullpath = fullfile(datadir, file_name);

tokens = regexp(file_name, '_(\-?\d+)_(\-?\d+)\.xlsx$', 'tokens');
if isempty(tokens)
    return;
end

time_start = str2double(tokens{1}{1});
time_end   = str2double(tokens{1}{2});

table = readtable(fullpath, 'PreserveVariableNames', true);

posi = double(table2array(table(:,2:end)) > 0);
nega = double(table2array(table(:,2:end)) < 0);

savedir = fullfile(outputdir_base, sprintf('%d_%d', time_start, time_end), ['test' num2str(j)]);
if ~exist(savedir,'dir')
    mkdir(savedir)
end

outputFile = fullfile(savedir,[task '_transfer_entropy_test' num2str(j) '.xlsx']);

asdf = SparseToASDF(posi, 1);
[peakTE_posi, ~, ~] = ASDFTE(asdf, 1:Delay_bins);
clear asdf

asdf = SparseToASDF(nega, 1);
[peakTE_nega, ~, ~] = ASDFTE(asdf, 1:Delay_bins);
clear asdf

peakTE = peakTE_posi - peakTE_nega;

ROI = table(:,1);
Result = [ROI, array2table(peakTE)];
writetable(Result, outputFile);

end