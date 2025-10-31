% This is script is designed to reproduce basic figures of Nasioulas_2024.
%
% There are three basic categories/types of figures. 
%
% You can modify the "modifiable parameters" in order to change the
% specifications of each plot. These parameters include which experiments
% you want to take data from, the dependent variable you want to plot 
% (Risky or Optimal choice rate) and, in Figure 2, the second factor to be 
% included in the analysis (risky/sureBetter or pRisky).
%
% Each figure category is coded within a section so that they can be run
% autonomously, after having loaded the behavioral data ("behData") once

%load behavioral data
behData = readtable('Nasioulas2024_data.csv');


%% xxxxxxxxxxxxxxx  Figure 1: Dependent(feedback) boxplot  xxxxxxxxxxxxxxxx

% --- modifiable parameters
experiment = [1]; %numeric array including any of the values 1,2,...,7
dependent = 1; %1: Risky-rate, 2: Optimal-rate
% ---

% --- compute summary data based on the input parameters

%convert depedent from numeric to string, corresponding to the name of the relevant column
dependentsS = {'RISKY_CHOICE', 'OPTIMAL_CHOICE'};
dependentS = dependentsS{dependent};

x = grpstats(behData(ismember(behData.EXP, experiment),:), {'FEEDBACK','EXPID' }, {'mean'}, 'DataVars', dependentS);
data = reshape(x.("mean_"+dependentS),[],2); %data(:,1)=no-feedback, data(:,2)=feedback; data(i,:)=i-th participant
% ---

% --- plot the data
figure;

% Define colors (blue for no-feedback, green for feedback)
colors = [0.12 0.29 0.36;   % no-feedback
          0.24 0.41 0.12];  % feedback

% Plot violins with paired connections
violinPlot(data, colors, true);

set(gca, 'XTick', [1 2], 'XTickLabels', {'no-feedback', 'feedback'});
ylabel(regexp(dependentS, '([^_]+)', 'match', 'once') + "-rate");

expS = sprintf("Exp %s", strrep(num2str(experiment), '  ', ', '));
meansS = ['[', strjoin(arrayfun(@(x) sprintf('%.2f', x), mean(data), 'UniformOutput', false), ', '), ']'];
title(sprintf('Violin plot with connected data points of individuals\n%s\nmeans: %s', expS, meansS));
ylim([0 1]);
box on
% ---

factors = "FEEDBACK"; 
figName = sprintf('Figure1_%s__%s.jpg', dependentS, factors);
exportgraphics(gcf, figName, 'Resolution', 300);


%% xxxxxxxxxx  Figure 2: Dependent(feedback,factor2) boxplot  xxxxxxxxxxxxx

% --- modifiable parameters
experiment = [3,4,6]; %numeric array including any of the values 1,2,...,7
dependent = 1; %1: Risky-rate, 2: Optimal-rate
factor2 = 2; %1:risky/sureBetter, 2: pRisky
% ---

% --- compute summary data based on the input parameters

%convert depedent and factor2 from numeric to string, corresponding to the
%   name of the relevant column
dependentsS = {'RISKY_CHOICE', 'OPTIMAL_CHOICE'};
dependentS = dependentsS{dependent};
factor2sS = {'RISKYBETTER', 'P1'};
factor2S = factor2sS{factor2};

factor2N = 2 + (factor2 == 2); %number of levels of factor2: 2 for RISKYBETTER, 3 for P1
x = grpstats(behData(ismember(behData.EXP, experiment),:), {factor2S,'FEEDBACK','EXPID' }, {'mean'}, 'DataVars', dependentS);
data = reshape(x.("mean_"+dependentS),[],2*factor2N); 
% ---

% --- plot the data
figure;

% Define colors repeating in pairs: [blue, green, blue, green, ...]
colors = repmat([0.12 0.29 0.36; 0.24 0.41 0.12], factor2N, 1);

% Plot violins with paired connections
violinPlot(data, colors, true);

% X-axis labels
xtickLabels = {
    {'sureBetter & nF', 'sureBetter & F', 'riskyBetter & nF', 'riskyBetter & F'}, ...
    {'p=10 & nF', 'p=10 & F', 'p=50 & nF', 'p=50 & F', 'p=90 & nF', 'p=90 & F'}
};
xtickLabel = xtickLabels{factor2};
set(gca, 'XTick', 1:2*factor2N, 'XTickLabels', xtickLabel);
ylabel(regexp(dependentS, '([^_]+)', 'match', 'once') + "-rate");

expS = sprintf("Exp %s", strrep(num2str(experiment), '  ', ', '));
meansS = ['[', strjoin(arrayfun(@(x) sprintf('%.2f', x), mean(data), 'UniformOutput', false), ', '), ']'];
title(sprintf('Violin plot with connected data points of individuals\n%s\nmeans: %s\nnF=no-feedback, F=feedback', expS, meansS));
ylim([0 1]);
box on
% ---

factors = sprintf('FEEDBACK_%s', factor2S);
figName = sprintf('Figure2_%s__%s.jpg', dependentS, factors);
exportgraphics(gcf, figName, 'Resolution', 300);



%% xxxxxxxxxx  Figure 3: Dependent(feedback,trial) lineplot  xxxxxxxxxxxxxx

% --- modifiable parameters
experiment = [2,4,5,6]; %numeric array including any of the values 1,2,...,7
dependent = 1; %1: Risky-rate, 2: Optimal-rate
% ---

% --- compute summary data based on the input parameters

%convert depedent and factor2 from numeric to string, corresponding to the
%   name of the relevant column
dependentsS = {'RISKY_CHOICE', 'OPTIMAL_CHOICE'};
dependentS = dependentsS{dependent};

x = grpstats(behData(ismember(behData.EXP, experiment),:), {'TRIAL','FEEDBACK','EXPID' }, {'mean'}, 'DataVars', dependentS);
data = reshape(x.("mean_"+dependentS),[],2*10); %columns 1:2:20 are no-feedback & trial=1:10; columns 2:2:20 are feedback & trial=1:10;
% ---


% --- plot the data

% no-feedback 
color{1} = [0.12 0.29 0.36]; %blue
dataMatrix{1} = data(:,1:2:end);

% feeback
color{2} = [0.24 0.41 0.12]; %green
dataMatrix{2} = data(:,2:2:end);

figure;
hold on;

for i = 1:2
    curve= mean(dataMatrix{i},1);
    sem  = std(dataMatrix{i})/sqrt(height(dataMatrix{i}));
    plot(1:10, curve,'B', 'Color',color{i},'LineWidth',2); %mean line
    plot(1:10, curve+sem,'Color',color{i},'LineWidth',1); %mean+sem line
    plot(1:10, curve-sem, 'Color',color{i},'LineWidth',1); %mean-sem line
    
    fill([1:10 fliplr(1:10)],[(curve+sem) fliplr(curve-sem)],'k', 'LineWidth',1, 'FaceColor',color{i}, 'FaceAlpha',0.4); %fill between the lines above
end

%add color legend
yText = .8; %might need to be adjusted if it overlaps with the graphs
text(1, yText, 'no-Feedback', 'Color', color{1}, 'FontSize', 14);
text(1, yText+.05, 'Feedback', 'Color', color{2}, 'FontSize', 14);

hold off;

xlim([0 11])
xlabel("Trial")
set(gca, 'XTick', 1:10, 'XTickLabels', 1:10);
ylabel(regexp(dependentS, '([^_]+)', 'match', 'once')+"-rate");
ylim([0,1])

expS = sprintf("Exp %s",strrep(num2str(experiment), '  ', ', '));
title(sprintf('Line-plot\n%s', expS)) ;
% ---

factors = 'FEEDBACK_TRIAL';
figName = sprintf('Figure3_%s__%s.jpg', depName, factors);
exportgraphics(gcf, figName, 'Resolution', 300);
