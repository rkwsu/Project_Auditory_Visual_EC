clear; clc;

rootdir = 'C:\TE_MOVIE';

addpath(fullfile(rootdir, 'Code'));
addpath(fullfile(rootdir, 'Code', 'fieldtrip'));
addpath(fullfile(rootdir, 'Code', 'fieldtrip', 'utilities'));
addpath(fullfile(rootdir, 'Code', 'fieldtrip', 'plotting'));
addpath(fullfile(rootdir, 'Code', 'Combined_TE_M_movie'));

tractlibFile = fullfile(rootdir, 'Track_Data', 'All_ROI2ROI_500k_fa0p05_stepsize0.mat');
load(tractlibFile, 'allTracts');

Method   = 'Raw';
timing   = 'Stim_on';
sn       = 20;
duration = 500;
times    = {[0 500]};

condition       = 'ROI2ROI';
fontsize        = 4;
frame_number    = 3;
Export_Fig      = 0;
amp_color_range = [-1 1];

FIG_WIDTH_PX  = 1600;
FIG_HEIGHT_PX = 900;
BALL_DIAM_PX  = 6;

[~, ftpath] = ft_version;
mesh_lh = load([ftpath filesep 'template/anatomy/surface_pial_left.mat']);
mesh_rh = load([ftpath filesep 'template/anatomy/surface_pial_right.mat']);

combined_root = fullfile(rootdir, 'Combined_movie');

for time = times
    time = cell2mat(time);
    movie_time_range = [time(1) time(2)];

    savedir = fullfile(combined_root, ...
        sprintf('duration%dms', duration), ...
        sprintf('sphere%d', sn), ...
        sprintf('time%d_%d', time(1), time(2)));
    if ~exist(savedir, 'dir'), mkdir(savedir); end

    [TE_Pos, TIME, Sphere_Pos, Tract_Pos, TEname_Pos, header_row] = ...
        load_TE_Sphere_Tract(rootdir, 'Positive_VIS', Method, timing, sn, time);

    [TE_Neg, ~, Sphere_Neg, Tract_Neg, TEname_Neg, ~] = ...
        load_TE_Sphere_Tract(rootdir, 'Negative_VIS', Method, timing, sn, time);

    Export_times_raw = [time(1) time(1)+100 time(1)+100 time(2)];
    Export_times     = Export_times_raw(ismember(Export_times_raw, TIME));
    Timeunit         = mode(diff(TIME));

    Setting.fnum     = size(TE_Pos, 2);
    Setting.Time_all = TIME(:);

    savename = fullfile(savedir, ...
        sprintf('tract_with_TE_Combined_%s_%s_%d_%d', ...
        condition, timing, time(1), time(2)));

    pp = get(0,'ScreenPixelsPerInch');
    ball_pt = (BALL_DIAM_PX * 72) / pp;
    ball_sizedata = ball_pt.^2;

    Generating_movies_DTI_stroop_Combined( ...
        Sphere_Pos, Sphere_Neg, Setting, savename, amp_color_range, ...
        Timeunit, frame_number, movie_time_range, fontsize, timing, ...
        Export_Fig, Export_times, ...
        Tract_Pos, Tract_Neg, mesh_lh, mesh_rh, ...
        TEname_Pos, TEname_Neg, TE_Pos, TE_Neg, header_row, allTracts, ...
        FIG_WIDTH_PX, FIG_HEIGHT_PX, ball_sizedata);
end


function [TE, TIME, Sphere, Tract, TEname, header_row] = load_TE_Sphere_Tract(rootdir, baseDir, Method, timing, sn, time)

    TE_file = fullfile(rootdir, baseDir, 'TE_M_001', timing, 'duration100ms', ...
        'Combined_TE_by_Combination.xlsx');
    raw_cell   = readcell(TE_file);
    header_row = raw_cell(1, :);
    data_rows  = raw_cell(2:end, :);

    TEname          = string(data_rows(:, 1));
    TE_time_headers = header_row(1, 3:end);
    TIME            = str2double(string(TE_time_headers));
    TE_value_cells  = data_rows(:, 3:end);
    TE_values       = cellfun(@(x) str2double(string(x)), TE_value_cells);
    TE              = num2cell(TE_values);

    Sphere_file = fullfile(rootdir, baseDir, 'TE_M_002', timing, 'duration100ms', ...
        sprintf('sphere_position_Combination_%s_%s_transfer_entropy_spacing%d_%d_%d.mat', ...
        Method, timing, sn, time(1), time(2)));
    Sphere = load(Sphere_file);

    if isfield(Sphere, 'Coordinate') && isfield(Sphere.Coordinate, 'Position')
        posCell = Sphere.Coordinate.Position;
    elseif isfield(Sphere, 'Coordinate')
        posCell = Sphere.Coordinate;
    elseif isfield(Sphere, 'Position')
        posCell = Sphere.Position;
    else
        error('Sphere does not contain Position/Coordinate.');
    end

    for i = 1:numel(posCell)
        item = posCell{i};
        if iscell(item), data = item{1}; else, data = item; end
        if ndims(data) == 3
            data = reshape(data, size(data,1), size(data,2), size(data,3), 1);
        end
        posCell{i} = {data};
    end
    Sphere.Coordinate = posCell;

    tractFile = fullfile(rootdir, baseDir, 'TE_M_TractData', 'thres0.05', ...
                         'Tract', timing, 'Tract.mat');
    tmp = load(tractFile);

    if isfield(tmp, 'Data') && isfield(tmp.Data, 'tract_name')
        tract_names = string(tmp.Data.tract_name);
    elseif isfield(tmp, 'tract_name')
        tract_names = string(tmp.tract_name);
    elseif isfield(tmp, 'Tract') && isstruct(tmp.Tract) && isfield(tmp.Tract, 'name')
        tract_names = string({tmp.Tract.name});
    else
        error('tract_name not found.');
    end

    get_allTck = [];
    if isfield(tmp, 'Tract') && isstruct(tmp.Tract) && isfield(tmp.Tract, 'allTck_selected')
        get_allTck = @(idx) tmp.Tract(idx).allTck_selected;
    elseif isfield(tmp, 'allTck_selected')
        if iscell(tmp.allTck_selected)
            get_allTck = @(idx) tmp.allTck_selected{idx};
        else
            get_allTck = @(idx) tmp.allTck_selected(idx);
        end
    else
        error('allTck_selected not found.');
    end

    allTck_selected = cell(size(TEname));
    for i = 1:numel(TEname)
        match_idx = find(tract_names == TEname(i), 1, 'first');
        if ~isempty(match_idx)
            v = get_allTck(match_idx);
            if iscell(v), v = v{1}; end
            allTck_selected{i} = v;
        else
            allTck_selected{i} = [];
        end
    end

    Tract.Tract.allTck_selected = allTck_selected;
    Tract.Data.tract_name = TEname;
    Tract.Data.Alpha      = TE_values;
    Tract.Data.time       = TIME(:);
end
