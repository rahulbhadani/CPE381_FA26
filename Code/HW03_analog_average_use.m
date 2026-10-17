%%
clear; clc;close all;
csv_file = '../Data/week_data_ERCOT_zone_1_.csv';
week_data = readtable(csv_file);
px_time = posixtime(week_data.time);
px_time = px_time - px_time(1);

y = analog_averager(px_time, week_data.wind_power, 600);

f = figure;
f.Position(3:4) = [1200, 400];
plot(px_time, week_data.wind_power, 'b', 'LineWidth',2, 'DisplayName', 'Original Wind Power Data');
hold on;
plot(px_time, y, 'r', 'LineWidth',2, 'LineStyle','--','DisplayName', 'Smoothed Out Wind Power Data');
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