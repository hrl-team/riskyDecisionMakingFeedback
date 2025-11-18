function generate_figure(figID, dataFile)
% generate_paper_figure(figID, dataFile)
%
% Examples:
%   generate_paper_figure('Figure5A', 'Nasioulas2024_data.csv');

    if nargin < 2 || isempty(dataFile)
        dataFile = 'Nasioulas2024_data.csv';
    end

    % ---- Load once
    behData = readtable(dataFile);

    % Determine dataset type automatically
    if contains(dataFile, 'Erev', 'IgnoreCase', true)
        pRiskyVar = 'P_RISKY_CAT';
    else
        pRiskyVar = 'P_RISKY';
    end

    switch upper(strtrim(figID))

        % ===== Exp 1 =====
        case 'FIGURE2A'
            fig_feedback_violin(behData, 1, 'RISKY_CHOICE', figID);

        case 'FIGURE2B'
            fig_feedback_factor2_violin(behData, 1, 'OPTIMAL_CHOICE', 'RISKYBETTER', figID);

        case 'FIGURE2C'
            fig_feedback_trial_line(behData, 1, 'RISKY_CHOICE', figID);

        % ===== Exp 2 =====
        case 'FIGURE2D'
            fig_feedback_violin(behData, 2, 'RISKY_CHOICE', figID);

        case 'FIGURE2E'
            fig_feedback_factor2_violin(behData, 2, 'OPTIMAL_CHOICE', 'RISKYBETTER', figID);

        case 'FIGURE2F'
            fig_feedback_trial_line(behData, 2, 'RISKY_CHOICE', figID);

        % ===== Figure 3 =====
        case 'FIGURE3A'
            fig_feedback_trial_line(behData, 3, 'RISKY_CHOICE', figID);

        case 'FIGURE3B'
            fig_feedback_trial_line(behData, 4, 'RISKY_CHOICE', figID);

        case 'FIGURE3C'
            fig_feedback_factor2_violin(behData, [1 2], 'RISKY_CHOICE', pRiskyVar, figID);

        case 'FIGURE3D'
            fig_feedback_factor2_violin(behData, [3 4], 'RISKY_CHOICE', pRiskyVar, figID);

        % ===== Figure 4 =====
        case 'FIGURE4A'
            fig_feedback_trial_line(behData, [1 3], 'RISKY_CHOICE', figID);

        case 'FIGURE4B'
            fig_feedback_trial_line(behData, [2 4 5 6], 'RISKY_CHOICE', figID);

        case 'FIGURE4C'
            fig_feedback_factor2_violin(behData, [1 2 5], 'RISKY_CHOICE', pRiskyVar, figID);

        case 'FIGURE4D'
            fig_feedback_factor2_violin(behData, [3 4 6], 'RISKY_CHOICE', pRiskyVar, figID);

        % ===== Figure 5 =====
        case 'FIGURE5A'
            fig_feedback_factor2_violin(behData, [1 3], 'RISKY_CHOICE', 'PREVIOUS_RISKY_CHOICE', figID, true);

        case 'FIGURE5B'
            fig_feedback_factor2_violin(behData, [1 3], 'RISKY_CHOICE', 'PREVIOUS_OUT_POS', figID, true);

        case 'FIGURE5F'
            fig_prevRisky_pRisky_violin(behData, 1:6, 'REPEAT_RISKY', pRiskyVar, figID);

        % ===== Figure 6 (Erev2017_data.csv) =====
        case 'FIGURE6A'
            fig_feedback_violin(behData, 8, 'OPTIMAL_CHOICE', figID);

        case 'FIGURE6B'
            fig_feedback_factor2_violin(behData, 8, 'RISKY_CHOICE', pRiskyVar, figID);

        case 'FIGURE6D'
            fig_prevRisky_pRisky_violin(behData, 8, 'REPEAT_RISKY', pRiskyVar, figID);

        % ===== Supplementary Figure S1 =====
        case 'FIGURES1A'
            fig_feedback_trial_line(behData, 5, 'RISKY_CHOICE', figID);

        case 'FIGURES1B'
            fig_feedback_trial_line(behData, 6, 'RISKY_CHOICE', figID);

        case 'FIGURES1C'
            fig_feedback_factor2_violin(behData, 5, 'RISKY_CHOICE', pRiskyVar, figID);

        case 'FIGURES1D'
            fig_feedback_factor2_violin(behData, 6, 'RISKY_CHOICE', pRiskyVar, figID);

        % ===== Supplementary Figure S2 (Erev2017_data.csv) =====
        case 'FIGURES2A'
            fig_feedback_trial_line(behData(behData.CONDITION == "byProb", :), 8, 'RISKY_CHOICE', figID);

        case 'FIGURES2B'
            fig_feedback_trial_line(behData(behData.CONDITION == "byFeed", :), 8, 'RISKY_CHOICE', figID);

        % ===== Supplementary Figure S3 =====
        case 'FIGURES3B'
            fig_feedback_violin(behData, 7, 'RISKY_CHOICE', figID);

        case 'FIGURES3C'
            fig_feedback_factor2_violin(behData, 7, 'RISKY_CHOICE', 'VALENCE', figID);

        case 'FIGURES3D'
            fig_feedback_trial_line(behData, 7, 'RISKY_CHOICE', figID);

        otherwise
            error('Unknown figure ID: %s', figID);
    end
end


% ======================================================================
% =                          PLOT FUNCTIONS                            =
% ======================================================================

function fig_feedback_violin(behData, experiment, dependentS, figID)
    idx = ismember(behData.EXP, experiment);
    T = behData(idx, :);

    G = grpstats(T, {'FEEDBACK','EXPID'}, {'mean'}, 'DataVars', dependentS);
    G = sortrows(G, {'FEEDBACK','EXPID'});
    data = reshape(G.("mean_"+dependentS), [], 2);

    figure('Color','w');
    colors = [0.12 0.29 0.36; 0.24 0.41 0.12];
    violinPlot(data, colors, true);

    set(gca,'XTick',[1 2],'XTickLabels',{'no-feedback','feedback'});
    ylabel(regexprep(dependentS,'_.*$','') + "-rate");
    expS = sprintf('Exp %s', strrep(num2str(experiment), '  ', ', '));
    title(sprintf('%s', expS));
    ylim([0 1]); box on;

    exportgraphics(gcf, [figID '.jpg'], 'Resolution', 300);
end


function fig_feedback_factor2_violin(behData, experiment, dependentS, factor2S, figID, varargin)
    restrictTrial2 = (nargin > 5) && varargin{1};
    idx = ismember(behData.EXP, experiment);
    T = behData(idx, :);

    if restrictTrial2
        T = T(T.TRIAL == 2, :);
    end

    if ismember(factor2S, {'RISKYBETTER','PREVIOUS_RISKY_CHOICE','PREVIOUS_OUT_POS', 'VALENCE'})
        factor2N = 2;
    elseif ismember(factor2S, {'P_RISKY','P_RISKY_CAT'})
        factor2N = 3;
    else
        error('Unsupported factor2: %s', factor2S);
    end

    G = grpstats(T, {factor2S,'FEEDBACK','EXPID'}, {'mean'}, 'DataVars', dependentS);
    allSubs = unique(G.EXPID);
    allLevels = unique(G.(factor2S));
    allFb = unique(G.FEEDBACK);
    [A,B,C] = ndgrid(allLevels, allFb, allSubs);
    fullTable = table(A(:), B(:), C(:), 'VariableNames', {factor2S,'FEEDBACK','EXPID'});
    G = outerjoin(fullTable, G, 'Keys',{'FEEDBACK','EXPID',factor2S}, 'MergeKeys',true, 'Type','left');
    G = sortrows(G, {factor2S,'FEEDBACK','EXPID'});

    try
        data = reshape(G.("mean_"+dependentS), [], 2*factor2N);
    catch
        tmp = reshape(padarray(G.("mean_"+dependentS), ...
            mod(-numel(G.("mean_"+dependentS)),2*factor2N), NaN, 'post'), [], 2*factor2N);
        data = tmp(~any(isnan(tmp),2),:);
    end

    switch factor2S
        case 'RISKYBETTER'
            xtickLabel = {'sureBetter & nF','sureBetter & F','riskyBetter & nF','riskyBetter & F'};
        case {'P_RISKY','P_RISKY_CAT'}
            if strcmp(factor2S, 'P_RISKY')
                xtickLabel = {'p=10 & nF','p=10 & F','p=50 & nF','p=50 & F','p=90 & nF','p=90 & F'};
            else
                xtickLabel = {'lowPr & nF','lowPr & F','mediumPr & nF','mediumPr & F','highPr & nF','highPr & F'};
            end
        case 'PREVIOUS_RISKY_CHOICE'            
            xtickLabel = {'prev Safe & nF','prev Safe & F','prev Risky & nF','prev Risky & F'};            
            if isequal(figID,'Figure5A')
                xtickLabel = strrep(xtickLabel,'prev ','Choice_{t=1}=');
            end
        case 'PREVIOUS_OUT_POS'
            xtickLabel = {'prev =0 & nF','prev =0 & F','prev >0 & nF','prev >0 & F'};
            if isequal(figID,'Figure5B')
                xtickLabel = strrep(xtickLabel,'prev ','Out_{t=1}');
            end
        case 'VALENCE'
            xtickLabel = {'negative & nF','negative & F','positive & nF','positive & F'};
    end

    figure('Color','w');
    colors = repmat([0.12 0.29 0.36; 0.24 0.41 0.12], factor2N, 1);
    violinPlot(data, colors, true);

    ylabelSuffix = "-rate";
    if ismember(figID, {'Figure5A','Figure5B'})
        ylabelSuffix = ylabelSuffix+ "(t=2)";      
    end
    set(gca,'XTick',1:2*factor2N,'XTickLabels',xtickLabel);
    ylabel(regexprep(dependentS,'_.*$','') + ylabelSuffix);
    expS = sprintf('Exp %s', strrep(num2str(experiment), '  ', ', '));
    title(sprintf('%s', expS));
    ylim([0 1]); box on;

    exportgraphics(gcf, [figID '.jpg'], 'Resolution', 300);
end


function fig_feedback_trial_line(behData, experiment, dependentS, figID)
    idx = ismember(behData.EXP, experiment);
    T = behData(idx, :);
    if isempty(T)
        warning('No data found for Exp %s', num2str(experiment));
        return;
    end

    color{1} = [0.12 0.29 0.36];
    color{2} = [0.24 0.41 0.12];

    G = grpstats(T, {'TRIAL','FEEDBACK','EXPID'}, {'mean'}, 'DataVars', dependentS);
    trials = unique(G.TRIAL);
    fbLevels = unique(G.FEEDBACK);

    figure('Color','w'); hold on;
    Alpha = 0.3; LineW = 2; Yinf = 0; Ysup = 1; Font = 12;

    for iF = 1:numel(fbLevels)
        fbVal = fbLevels(iF);
        subT = G(G.FEEDBACK == fbVal, :);
        allSubs = unique(subT.EXPID);
        allTrials = unique(subT.TRIAL);
        dataMatrix = NaN(numel(allTrials), numel(allSubs));
        for s = 1:numel(allSubs)
            subData = subT(subT.EXPID == allSubs(s), :);
            [~, loc] = ismember(subData.TRIAL, allTrials);
            dataMatrix(loc, s) = subData.("mean_" + dependentS);
        end
        curve = mean(dataMatrix, 2, 'omitnan');
        sem = std(dataMatrix, 0, 2, 'omitnan') ./ sqrt(sum(~isnan(dataMatrix), 2));
        validI = find(~isnan(curve))';
        if isempty(validI), continue; end
        curveSup = curve(validI) + sem(validI);
        curveInf = curve(validI) - sem(validI);
        xVals = allTrials(validI);

        fill([xVals; flipud(xVals)], [curveSup; flipud(curveInf)], color{iF}, ...
             'FaceAlpha', Alpha, 'EdgeColor', 'none');
        plot(xVals, curve(validI), 'Color', color{iF}, 'LineWidth', LineW);
        if fbVal == 0
            label = 'no-Feedback';
        else
            label = 'Feedback';
        end
        text(xVals(1), 0.82 + 0.03*iF, label, 'Color', color{iF}, 'FontSize', Font);
    end

    xlabel('Trial');
    ylabel(regexprep(dependentS, '_.*$', '') + "-rate");
    ylim([Yinf Ysup]);
    box on; grid on;
    xticks(unique(G.TRIAL));
    xlim([min(G.TRIAL)-0.5, max(G.TRIAL)+0.5]);
    expS = sprintf('Exp %s', strrep(num2str(experiment), '  ', ', '));
    title(sprintf('%s', expS));

    exportgraphics(gcf, [figID '.jpg'], 'Resolution', 300);
end


function fig_prevRisky_pRisky_violin(behData, experiment, dependentS, pRiskyVar, figID)
    if nargin < 4
        pRiskyVar = 'P_RISKY';
    end
    idx = ismember(behData.EXP, experiment) & behData.FEEDBACK == 1 & ~isnan(behData.(dependentS));
    if experiment == 8 & strcmp(dependentS, 'REPEAT_RISKY')%Erev & repeatRisky
        %because each block starts with the no-feedback trials and
        %continues with the feedbback trials, we have to exclude the first 
        %feedback trial, namely TRIAL=6, because REPEAT_RISKY is not NaN
        %here
        idx = idx & behData.TRIAL ~= 6;
    end

    T = behData(idx, :);
    if isempty(T)
        error('No valid rows found for %s (check FEEDBACK==1 and non-NaN data).', dependentS);
    end
    factorA = 'PREVIOUS_RISKY_OUT_MAX';
    factorB = pRiskyVar;
    levelsA = unique(T.(factorA));
    levelsB = unique(T.(factorB));
    nA = numel(levelsA);
    nB = numel(levelsB);
    G = grpstats(T, {factorA, factorB, 'EXPID'}, {'mean'}, 'DataVars', dependentS);
    allSubs = unique(G.EXPID);
    [A,B,C] = ndgrid(levelsA, levelsB, allSubs);
    fullTable = table(A(:), B(:), C(:), 'VariableNames', {factorA, factorB, 'EXPID'});
    G = outerjoin(fullTable, G, 'Keys', {'EXPID', factorA, factorB}, 'MergeKeys', true, 'Type', 'left');
    G = sortrows(G, {factorB, factorA, 'EXPID'});
    nCols = nA * nB;
    vals = G.("mean_" + dependentS);
    try
        data = reshape(vals, [], nCols);
    catch
        pad = mod(-numel(vals), nCols);
        tmp = reshape(padarray(vals, pad, NaN, 'post'), [], nCols);
        data = tmp(~any(isnan(tmp), 2), :);
    end
    if strcmpi(pRiskyVar, 'P_RISKY')
        xtickLabel = {'p=10 / prev-Min','p=10 / prev-Max','p=50 / prev-Min','p=50 / prev-Max','p=90 / prev-Min','p=90 / prev-Max'};
    else
        xtickLabel = {'lowPr / prev-Min','lowPr / prev-Max','mediumPr / prev-Min','mediumPr / prev-Max','highPr / prev-Min','highPr / prev-Max'};
    end
    colorA = [0.8500 0.3250 0.0980];
    colorB = [0.9290 0.6940 0.1250];
    colors = repmat([colorA; colorB], nB, 1);
    figure('Color', 'w');
    violinPlot(data, colors, true);
    set(gca, 'XTick', 1:nCols, 'XTickLabels', xtickLabel);
    ylabel(regexprep(dependentS, '_.*$', '') + "-rate");
    expS = sprintf('Exp %s', strrep(num2str(experiment), '  ', ', '));
    title(sprintf('%s', expS));
    ylim([0 1]); box on;
    exportgraphics(gcf, [figID '.jpg'], 'Resolution', 300);
end
