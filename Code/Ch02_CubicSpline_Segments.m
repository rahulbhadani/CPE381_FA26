% Cubic Spline Visualization for Three Successive Data Points
% This script demonstrates fitting cubic splines P1(t) and P2(t) through three points

clear; clc; close all;

% Define three successive data points
t1 = 100; x1 = 20;
t2 = 200; x2 = 50;
t3 = 300; x3 = 35;

% Store points for easy reference
t_points = [t1, t2, t3];
x_points = [x1, x2, x3];

% For cubic spline, we need to define boundary conditions
% Using natural spline conditions (second derivative = 0 at endpoints)
% This creates a system of equations to solve for cubic coefficients

% First spline P1(t) from (t1,x1) to (t2,x2)
% Second spline P2(t) from (t2,x2) to (t3,x3)

% Using MATLAB's spline function for natural cubic spline
pp = spline(t_points, x_points);

% Extract the piecewise polynomial coefficients
coeffs = pp.coefs;
breaks = pp.breaks;

% Generate fine time vectors for smooth plotting
t1_fine = linspace(t1, t2, 100);
t2_fine = linspace(t2, t3, 100);

% Evaluate the splines
P1_values = ppval(pp, t1_fine);
P2_values = ppval(pp, t2_fine);

% Create the main plot
f= figure('Position', [100, 100, 700, 400]);

% Plot the data points
plot(t_points, x_points, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k', 'LineWidth', 2);
hold on;

% Plot P1(t) - first cubic spline segment
plot(t1_fine, P1_values, 'Color', '#1f77b4', 'LineWidth', 3, 'DisplayName', '$P_1(t)$');

% Plot P2(t) - second cubic spline segment
plot(t2_fine, P2_values, 'Color', '#ff7f0e', 'LineWidth', 3, 'DisplayName', '$P_2(t)$');

% Add point labels
text(t1-10, x1+2, '$(t_1, x_1)$', ...
     'Interpreter', 'latex', 'FontSize', 18, 'HorizontalAlignment', 'right');
text(t2, x2+3, '$(t_2, x_2)$', ...
     'Interpreter', 'latex', 'FontSize', 18, 'HorizontalAlignment', 'center');
text(t3+10, x3+2, '$(t_3, x_3)$', ...
     'Interpreter', 'latex', 'FontSize', 18, 'HorizontalAlignment', 'left');
text(150, 40, '$P_1(t)$', ...
     'Interpreter', 'latex', 'FontSize', 18, 'HorizontalAlignment', 'left');

text(250, 45, '$P_2(t)$', ...
     'Interpreter', 'latex', 'FontSize', 18, 'HorizontalAlignment', 'left');

% Apply the provided styling
grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
title('Cubic Spline Interpolation: $P_1(t)$ and $P_2(t)$', 'Interpreter','latex');
set(gca, 'FontSize', 18);
xlim([50, 350]);
ylim([15, 55]);
xlabel('Time (s), $t$','Interpreter', 'latex');
ylabel('Position, $x$','Interpreter', 'latex');

exportgraphics(f, 'figures/Ch02_CubicSpline_Segments.pdf', 'BackgroundColor', 'none');
