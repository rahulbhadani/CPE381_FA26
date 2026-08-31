% (C) Rahul Bhadani
csv_file = '../Data/vel.csv';
data = readtable(csv_file);
time = data.Time;
speed = data.Message;

speed = (speed*1000)/3600; % Convert km/h to m/s

% Uniformly sample given time series with Cubic Spline
h = 1.0/100.0; %20 Hz
t_new = 0:h:time(end);
[speed_interp, coefficients]  = Ch02_cubic_spline_interpolation(time, speed, t_new, 'free');


% Implement Three-Point Backward Differentiation
speed_diff_3pback = zeros(length(speed_interp),1);

% 3 point backward differentiation needs at least two previous points and a
% current point
for i = 3:length(t_new)
    speed_diff_3pback(i) = (speed_interp(i-2) - 4.*speed_interp(i-1) + 3.*speed_interp(i))./(2.*h);
end

% Implement Three-Point Forward Differentiation

speed_diff_3pfwd = zeros(length(speed_interp),1);

% 3 point backward differentiation needs at least two next points and a
% current point
for i = 1:length(t_new)-2
    speed_diff_3pfwd(i) = (-3.*speed_interp(i) + 4.*speed_interp(i+1) - speed_interp(i+2))./(2.*h);
end

f= figure;
f.Position = [ 810         819        1320         419];
hold on;
plot(t_new, speed_diff_3pback, 'LineWidth',2, ...
    'DisplayName','3Pt Backward Differentiation', ...
    'Color', '#336E99');
plot(t_new, speed_diff_3pfwd, 'LineWidth',2, ...
    'DisplayName','3Pt Forward Differentiation', ...
    'Color', '#AA41E0');

grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
title('Derivative of Speed', 'Interpreter','latex');
set(gca, 'FontSize', 18);
legend('Interpreter','latex');
xlabel('Time (s), $t$','Interpreter', 'latex');
ylabel('Differentiation','Interpreter', 'latex');

% Create zoom inset
ax2 = axes('Position', [0.5, 0.24, 0.15, 0.2]); % x, y, width, height
plot(t_new, speed_diff_3pback, 'LineWidth',2, ...
    'DisplayName','3Pt Backward Differentiation', ...
    'Color', '#336E99');
hold on;
plot(t_new, speed_diff_3pfwd, 'LineWidth',2, ...
    'DisplayName','3Pt Forward Differentiation', ...
    'Color', '#AA41E0');

xlim([125.35, 125.55]);
grid on;
grid minor;
title('Zoomed In')
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
set(gca, 'FontSize', 14);

exportgraphics(f, 'figures/Ch02_Differentiation_Real_Signal.pdf', 'BackgroundColor', 'none');


