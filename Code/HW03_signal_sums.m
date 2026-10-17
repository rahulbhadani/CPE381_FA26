%
t = 0:0.01:2;
y = 3.*cos(4.*pi.*t) + 2.*cos(10.*pi.*t) + cos(20.*pi.*t);
f = figure;
f.Position(3:4) = [1200, 400];
plot(t, y, 'b', 'LineWidth',2);
hold on;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
xlabel('Time','Interpreter', 'latex');
set(gca, 'FontSize', 18);
grid on;
grid minor;