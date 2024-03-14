% This is script is designed to reproduce basic figures of Nasioulas_2024,
% using basic functions of Matlab (hence, the visual result is more
% primitive, but the essence remains the same)


data = readtable('Nasioulas2024_data.csv');

%--- Figure 1: Dependent(feedback)
dependent = 1; %1: Risky-rate, 2: Optimal-rate



sampleSizes = table(unique(C.EXP), splitapply(@(x) numel(unique(x)), C.EXPID, findgroups(C.EXP)), 'VariableNames', {'EXP', 'NumUniqueEXPID'});

mean_risky_choice = grpstats(C, {'EXP', 'FEEDBACK'}, {'mean'}, 'DataVars', 'RISKY_CHOICE');
mean_risky_choice.mean_RISKY_CHOICE = str2double(strsplit(strip(sprintf("%.2f,", mean_risky_choice.mean_RISKY_CHOICE),','), ',')');


meanCorrect = grpstats(C, {'EXP', 'FEEDBACK'}, {'mean'}, 'DataVars', 'CORRECT_CHOICE');
meanCorrect.mean_CORRECT_CHOICE = str2double(strsplit(strip(sprintf("%.2f,", meanCorrect.mean_CORRECT_CHOICE),','), ',')');


meanRiskyTrial = grpstats(C, {'EXP', 'TRIAL','FEEDBACK'}, {'mean'}, 'DataVars', 'RISKY_CHOICE');
meanRiskyTrial.mean_RISKY_CHOICE = str2double(strsplit(strip(sprintf("%.2f,", meanRiskyTrial.mean_RISKY_CHOICE),','), ',')');


if 0
    if 1
        r = grpstats(C(C.TYPE_FEEDBACK==1 & C.EXP~=7,:), {'P1','FEEDBACK','EXPID' }, {'mean'}, 'DataVars', 'RISKY_CHOICE');
        data = reshape(r.mean_RISKY_CHOICE, height(r)/6,[]);
    elseif 0
        r = grpstats(C(C.EXP==7,:), {'FEEDBACK','EXPID' }, {'mean'}, 'DataVars', 'RISKY_CHOICE');
        data = [r.mean_RISKY_CHOICE(1:height(r)/2), r.mean_RISKY_CHOICE(height(r)/2+1:end)];
    end

    colorsI = [2,3,2,3,2,3];
    figure 
    skylineplot(4,{data', 0},Colors(colorsI),0,1+0.05,NaN,12,NaN,'','',''); %first argument should have the data with each factor/condition in one row    
end
