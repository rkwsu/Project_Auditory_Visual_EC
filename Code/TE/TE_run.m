% ===== A: TE_run.m =====
clear

tasks      = {'Stim_off','Stim_on','Resp_on'};
duration   = 100;
Delay_bins = 3;
test       = 1:2;

script_folder = 'G:\For_Github_EC\Code\TE';
progress_file = 'progress_positive.mat';

N_required = 2;

if exist(progress_file,'file')
    S = load(progress_file);
    startTaskIdx = getv(S,'startTaskIdx',1);
    startFileIdx = getv(S,'startFileIdx',1);
    startTestIdx = getv(S,'startTestIdx',1);
else
    startTaskIdx = 1; startFileIdx = 1; startTestIdx = 1;
end

for taskIdx = startTaskIdx:numel(tasks)

    task = tasks{taskIdx};

    datadir = ['G:\For_Github_EC\Positive_AUD\TE1\' task '\duration' num2str(duration) 'ms\'];
    outputdir_base = ['G:\For_Github_EC\Positive_AUD\TE2\' task '\duration' num2str(duration) 'ms\'];

    tmp_root = fullfile('G:\T', sprintf('d%d', duration), ['t' lower(task(1))]);

    ensure(datadir); ensure(outputdir_base); ensure(tmp_root);

    files = dir(fullfile(datadir,'*.xlsx'));
    fileStart = max(1,(taskIdx==startTaskIdx)*startFileIdx + (taskIdx~=startTaskIdx));

    for fileIdx = fileStart:numel(files)

        tmp_base = fullfile(tmp_root,sprintf('f%04d',fileIdx));
        rmdir_safe(tmp_base);
        ensure(tmp_base);

        for j = startTestIdx:length(test)

            succ = 0;
            attempt = 0;

            % "前のエクセル"を保持する場所（1回目成功分）
            stage_dir = fullfile(tmp_base, sprintf('j%02d_stage', j));
            rmdir_safe(stage_dir);
            ensure(stage_dir);
            stage_file = fullfile(stage_dir, 'stage_transfer_entropy.xlsx');

            while succ < N_required

                attempt = attempt + 1;

                tmp_attempt = fullfile(tmp_base,sprintf('j%02d_a%06d',j,attempt));
                rmdir_safe(tmp_attempt);
                ensure(tmp_attempt);

                status = run_once(script_folder,j,fileIdx,task,duration,...
                                  Delay_bins,datadir,tmp_attempt);

                if status~=0 || ~valid_TE(tmp_attempt)
                    % クラッシュ/失敗：その前のエクセル（stage）も消してカウントを0に戻す
                    rmdir_safe(tmp_attempt);
                    if exist(stage_file,'file'); delete(stage_file); end
                    succ = 0;
                    continue
                end

                % 成功：tmp_attempt 内の xlsx を取得
                cur = find_xlsx(tmp_attempt,'*transfer_entropy*.xlsx');
                if isempty(cur)
                    rmdir_safe(tmp_attempt);
                    if exist(stage_file,'file'); delete(stage_file); end
                    succ = 0;
                    continue
                end
                curfile = cur{1};

                if succ == 0
                    copyfile(curfile, stage_file, 'f');
                    succ = 1;
                    rmdir_safe(tmp_attempt);
                    continue
                end

                % 2回目成功：一致確認（不一致なら"前のエクセル"消してやり直し）
                if ~same_xlsx(stage_file, curfile)
                    rmdir_safe(tmp_attempt);
                    if exist(stage_file,'file'); delete(stage_file); end
                    succ = 0;
                    continue
                end

                % 規定数に達した：2回目の結果を最終出力へ
                move_all(tmp_attempt, outputdir_base);
                rmdir_safe(tmp_attempt);
                if exist(stage_file,'file'); delete(stage_file); end
                succ = 2;
            end

            % progress
            startTaskIdx = taskIdx;
            startFileIdx = fileIdx;
            startTestIdx = j+1;
            save(progress_file,'startTaskIdx','startFileIdx','startTestIdx');
        end

        startTestIdx = 1;
        startFileIdx = fileIdx+1;
        startTaskIdx = taskIdx;
        save(progress_file,'startTaskIdx','startFileIdx','startTestIdx');

        rmdir_safe(tmp_base);
    end

    startFileIdx = 1; startTestIdx = 1;
    startTaskIdx = taskIdx+1;
    save(progress_file,'startTaskIdx','startFileIdx','startTestIdx');
end

if exist(progress_file,'file'); delete(progress_file); end
disp('Done');

function v = getv(S,n,d)
if isfield(S,n), v=S.(n); else, v=d; end
end

function ensure(p)
if ~exist(p,'dir'), mkdir(p); end
end

function rmdir_safe(p)
if exist(p,'dir')
    try, rmdir(p,'s'); catch, end
end
end

function move_all(src,dst)
ensure(dst);
d=dir(src);
for k=1:numel(d)
    n=d(k).name;
    if strcmp(n,'.')||strcmp(n,'..'), continue; end
    movefile(fullfile(src,n),dst,'f');
end
end

function status = run_once(folder,j,fileIdx,task,dur,db,data,out)
body = sprintf( ...
    "try; cd('%s'); j=%d; run_single_test(%d,j,'%s',%d,%d,'%s','%s'); exit(0); catch; exit(1); end;", ...
    folder,j,fileIdx,task,dur,db,data,out);

cmd = sprintf('matlab -batch "%s" > NUL 2>&1', body);
status = system(cmd);

if status ~= 0
    disp('CRASH');
end
end

function ok = valid_TE(root)
ok = ~isempty(find_xlsx(root,'*transfer_entropy*.xlsx'));
end

function list=find_xlsx(root,pat)
list={};
d=dir(root);
for k=1:numel(d)
    if strcmp(d(k).name,'.')||strcmp(d(k).name,'..'), continue; end
    p=fullfile(root,d(k).name);
    if d(k).isdir
        list=[list find_xlsx(p,pat)];
    elseif ~isempty(regexpi(d(k).name,regexptranslate('wildcard',pat)))
        list{end+1}=p;
    end
end
end

function same = same_xlsx(f1,f2)
same = false;
try
    s1 = sheetnames(f1);
    s2 = sheetnames(f2);
    if numel(s1)~=numel(s2), return; end
    for i=1:numel(s1)
        if ~strcmp(s1{i},s2{i}), return; end
        T1 = readtable(f1,'Sheet',s1{i},'PreserveVariableNames',true);
        T2 = readtable(f2,'Sheet',s2{i},'PreserveVariableNames',true);
        if ~isequal(T1.Properties.VariableNames, T2.Properties.VariableNames), return; end
        A1 = table2array(T1(:,vartype('numeric')));
        A2 = table2array(T2(:,vartype('numeric')));
        if ~isequaln(A1,A2), return; end
    end
    same = true;
catch
    same = false;
end
end