%%
clear; clc;close all;
csv_file = '../Data/week_data_ERCOT_zone_1_.csv';
week_data = readtable(csv_file);
px_time = posixtime(week_data.time);
px_time = px_time - px_time(1);
f = figure;
f.Position(3:4) = [1200, 400];
plot(px_time, week_data.load_power, 'b', 'LineWidth',2);
hold on;
title('Load Power as function of time','Interpreter', 'latex');
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
xlabel('Time','Interpreter', 'latex');
set(gca, 'FontSize', 18);
grid on;
grid minor;


%% We will use Ch02_cubic_spline_interpolation function provided in GitHub to interpolate
t_new = px_time(1):1:px_time(end);
[x_interp, coefficients] = Ch02_cubic_spline_interpolation(px_time, week_data.load_power, t_new, 'free');

f = figure;
f.Position(3:4) = [1200, 400];
plot(px_time, week_data.load_power, 'b', 'LineWidth',2, 'DisplayName', 'Original Data');
hold on;
plot(t_new, x_interp, 'r', 'LineWidth',2, 'LineStyle','--','DisplayName', 'Interpolated Data');
hold on;
xlim([7100, 7300]);
title('Load Power as function of time','Interpreter', 'latex');
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
xlabel('Time','Interpreter', 'latex');
set(gca, 'FontSize', 18);
grid on;
grid minor;
legend;