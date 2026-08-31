% (C) Rahul Bhadani
%% Plotting a line
t_0 = 2.0;
t_1 = 2.4;
x_0 = 6.0;
x_1 = 7.5;
f = figure;
hold on;
plot([t_0, t_1], [x_0, x_1], 'LineWidth', 2, 'Color','#22615E', 'LineStyle','-');

% Plot the points
plot(t_0, x_0, 'MarkerSize', 10, 'Marker','o', ...
    'MarkerEdgeColor','#5E2261','MarkerFaceColor','#5E2261');
plot(t_1, x_1, 'MarkerSize', 10, 'Marker','o', ...
    'MarkerEdgeColor','#5E2261','MarkerFaceColor','#5E2261');

% Add grid lines (dashed)
plot([t_0, t_0], [0, x_0], 'LineStyle','--', 'LineWidth', 1,'Color','#666666');
plot([t_1, t_1], [0, x_1], 'LineStyle','--', 'LineWidth', 1,'Color','#666666');
plot([0, t_0], [x_0, x_0], 'LineStyle','--', 'LineWidth', 1,'Color','#666666');
plot([0, t_1], [x_1, x_1], 'LineStyle','--', 'LineWidth', 1,'Color','#666666');

% Add text annotation for the points
text(t_1+0.05, x_1+0.05, '(t_1,x_1)', 'FontSize', 14, 'Color', 'b');
text(t_0+0.05, x_0+0.05, '(t_0,x_0)', 'FontSize', 14, 'Color', 'b');

% Show Point on the line joining (t_0, x_0) and (t_1, x_1)
% Compute slope and intercept, 
% line equation is x = mt +c
% where m = (x_1 - x_0)/(t_1 - t_0)
% c = x_0 - m * t_0
m = (x_1 - x_0)/(t_1 - t_0);
c = x_0 - m * t_0;

t_new = 2.15;
x_new = m.*t_new  + c;
text(t_new+0.05, x_new+0.05, '(t,x)', 'FontSize', 14, 'Color', 'b');

plot([t_new, t_new], [0, x_new], 'LineStyle','-', 'LineWidth', 1,'Color','#333333');
plot([0, t_new], [x_new, x_new], 'LineStyle','-', 'LineWidth', 1,'Color','#333333');
plot(t_new, x_new, 'MarkerSize', 10, 'Marker','o', ...
    'MarkerEdgeColor','#5E2261','MarkerFaceColor','#EF332A');

grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
set(gca, 'FontSize', 18);
xlim([1, 3]);
ylim([4, 8]);

exportgraphics(f, 'figures/Ch02_line_equation.pdf', 'BackgroundColor', 'none');

%% Linear Interpolation in MATLAB
csv_file = '../Data/vel.csv';
data = readtable(csv_file);
time = data.Time;
speed = data.Message;

% Declare an anonymous function as a line equation
line_eq = @(t0, x0, t1, x1, t) x0 + (x1 - x0) * (t - t0) / (t1 - t0);

timediff = diff(time);
mean_sampling_time = mean(timediff);
t_new = 0:mean_sampling_time:time(end);

% Create empty slots for newly sampled-data
speed_uniform = zeros(size(t_new));

% Interpolate speed values for uniformly time samples
for i = 1:length(t_new)
    t_target = t_new(i);

    % Handle edge cases
    if t_target <= time(1)
        % Before first data point - use first value
        speed_uniform(i) = speed(1);
    elseif t_target >= time(end)
        % After last data point - use last value
        speed_uniform(i) = speed(end);
    else
        % Find the two closest points that near t_target
        idx = find(time <= t_target, 1, 'last');  % Last point <= t_target
        if idx < length(time)
            % Interpolate between time(idx) and time(idx+1)
            t0 = time(idx);
            x0 = speed(idx);
            t1 = time(idx + 1);
            x1 = speed(idx + 1);
            % Use anonymous function for interpolation
            speed_uniform(i) = line_eq(t0, x0, t1, x1, t_target);
        else
            % At the last point
            speed_uniform(i) = speed(end);
        end
    end

end

% Plotting

f= figure;
f.Position = [ 810         819        1320         419];
hold on;
plot(time, speed, 'LineWidth',1, ...
    'Marker','o', 'Color','#426642', ...
    'DisplayName','Original Non-Uniformly Sampled Speed');
plot(t_new, speed_uniform, 'LineWidth',1, ...
    'Marker','o', 'Color','#BB1111', ...
    'DisplayName','Uniformly Sampled Speed');
hold on;
grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
title('speed', 'Interpreter','latex');
set(gca, 'FontSize', 18);
legend('Interpreter','latex');
xlim([-2, 1000])
ylim([-2, 100])
xlabel('Time (s), $t$','Interpreter', 'latex');
ylabel('Speed km/hour','Interpreter', 'latex');

% Create zoom inset
ax2 = axes('Position', [0.57, 0.24, 0.3, 0.4]);
plot(time, speed, 'LineWidth', 2, 'Marker', 'o', 'Color', '#426642');
hold on;
plot(t_new, speed_uniform, 'LineWidth', 2, 'Marker', 'o', 'Color', '#BB1111');
xlim([125.35, 125.55]);
ylim([min(speed_uniform((t_new > 125.35) & (t_new < 125.55))),...
    max(speed_uniform((t_new > 125.35) & (t_new < 125.55)))]);
grid on;
grid minor;
title('Zoomed In')
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';

exportgraphics(f, 'figures/Ch02_Linear_Interpolation_Resampling.pdf', 'BackgroundColor', 'none');
