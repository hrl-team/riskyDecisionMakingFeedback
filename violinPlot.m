function violinPlot(data, colors, connectLines)
%
% Usage:
%   simpleViolinPlot(data, colors, connectLines)
%
% Features:
%   • Odd columns → violin on the LEFT, data points slightly to the RIGHT
%   • Even columns → violin on the RIGHT, data points slightly to the LEFT
%   • Mean±SEM + 95% CI box drawn OVER the violin
%   • Optional connecting lines between [1,2], [3,4], etc.

if nargin < 2 || isempty(colors)
    colors = repmat([0.5 0.5 0.5], size(data,2), 1);
end
if nargin < 3
    connectLines = false;
end

nGroups = size(data,2);
hold on

% --- layout parameters ---
Wbar = 0.75;        % violin half width scaling
wid  = 2;           % scaling factor
offsetData = 0.12;  % distance of datapoints from tick

for i = 1:nGroups
    groupData = data(:,i);
    groupData = groupData(~isnan(groupData));
    Nsub = numel(groupData);

    % ---- Kernel density (trimmed) ----
    [f, xi] = ksdensity(groupData);
    f = f(xi >= min(groupData) & xi <= max(groupData));
    xi = xi(xi >= min(groupData) & xi <= max(groupData));
    xi(1) = min(groupData);
    xi(end) = max(groupData);
    widthV = (Wbar/wid) / max(f);
    f = f * widthV;

    % ---- side logic ----
    if mod(i,2)==1
        side = -1; % odd -> left violin
        pointDir = +1; % data points to the right
    else
        side = +1; % even -> right violin
        pointDir = -1; % data points to the left
    end

    xRef = i;

    % ---- draw half violin ----
    fill([xRef, xRef + side*f, xRef], [xi(1), xi, xi(end)], ...
         colors(i,:), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

    % ---- stats ----
    m   = mean(groupData);
    sem = std(groupData)/sqrt(Nsub);
    conf = tinv(0.975, Nsub-1);
    ci95 = sem * conf;

    % ---- 95% CI box over violin half ----
    boxWidth = Wbar/wid;
    if side == -1
        boxX = xRef - boxWidth;  % fully on left half
    else
        boxX = xRef;             % fully on right half
    end
    rectangle('Position',[boxX, m - ci95, boxWidth, 2*ci95], ...
              'EdgeColor', colors(i,:), 'LineWidth', 1.2);

    % ---- mean + SEM over violin ----
    midX = xRef + side*(boxWidth/2);
    plot([midX - 0.05*side, midX + 0.05*side], [m, m], 'k', 'LineWidth', 1.5);
    plot([midX, midX], [m-sem, m+sem], 'k', 'LineWidth', 1);

    % ---- datapoints: slightly toward the center (inside space) ----
    pointX = xRef + pointDir*(boxWidth - offsetData);
    scatter(ones(Nsub,1)*pointX, groupData, 22, colors(i,:), ...
        'filled', 'MarkerFaceAlpha', 0.25, 'MarkerEdgeColor', 'none');
end

% ---- connecting lines between [1,2], [3,4], ... ----
if connectLines
    pairIdx = 1:2:(nGroups-1);
    for p = pairIdx
        if p+1 <= nGroups
            meanDiff = mean(data(:,p+1) - data(:,p), 'omitnan');

            % coordinates just outside the violin halves (where points are)
            xLeft  = p   + (Wbar/wid - offsetData);  % point side for left half (odd)
            xRight = p+1 - (Wbar/wid - offsetData);  % point side for right half (even)

            for s = 1:size(data,1)
                if all(~isnan(data(s,[p, p+1])))
                    indivDiff = data(s,p+1) - data(s,p);
                    if sign(indivDiff) == sign(meanDiff)
                        lineColor = [1.0000, 0.5529, 0.3608, 0.8]; % orange
                    else
                        lineColor = [0 0 0 0.3]; % black
                    end

                    plot([xLeft, xRight], data(s,[p, p+1]), ...
                         'Color', lineColor, 'LineWidth', 1);

                    scatter([xLeft, xRight], data(s,[p, p+1]), 22, ...
                        colors([p, p+1],:), 'filled', ...
                        'MarkerFaceAlpha', 0.35, 'MarkerEdgeColor', 'none');
                end
            end
        end
    end
end

set(gca, 'XTick', 1:nGroups);
box on
hold off
end
