% (C) Rahul Bhadani
csv_file = '../Data/vel.csv';
data = readtable(csv_file);
time = data.Time;
speed = data.Message;
% Make a plot
% Plot the velocity data
f= figure;
f.Position = [ 810         819        1320         419];
plot(time, speed, 'LineWidth',2, 'DisplayName','Speed');
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
ylim([-2, 100])
xlabel('Time (s), $t$','Interpreter', 'latex');
ylabel('Speed km/hour','Interpreter', 'latex');

exportgraphics(f, 'figures/Ch02_reallife_speed.pdf', 'BackgroundColor', 'none');


%% Compute Time Diff to Show Non-Uniformity of Time Points
timediff = diff(time);
% plot the histogram of diffs
f= figure;
f.Position = [ 724   615   551   419];
histogram(timediff);
xlim([0.01, 0.04])
hold on;
grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
xlabel(' $\Delta t$','Interpreter', 'latex');
ylabel('Counts','Interpreter', 'latex');
set(gca, 'FontSize', 18);
exportgraphics(f, 'figures/Ch02_reallife_speed_deltaT_Histogram.pdf', ...
    'BackgroundColor', 'none', 'Resolution',900);


disp(sprintf("Mean time diff is %f", mean(timediff)));