% Draw a unit circle and mark specific angles
clear; clc;

% Define the angles to mark
angles = [pi/6, pi/3, pi/4, 3*pi/4];
angle_labels = {'\pi/6', '\pi/3', '\pi/4', '3\pi/4'};

% Create the figure
f= figure;
set(gca, 'FontSize', 14);
hold on;

% Draw the unit circle
theta = linspace(0, 2*pi, 100);
x_circle = cos(theta);
y_circle = sin(theta);
plot(x_circle, y_circle, 'b-', 'LineWidth', 2);

% Draw coordinate axes
plot([-1.3, 1.3], [0, 0], 'k--', 'LineWidth', 0.5);
plot([0, 0], [-1.3, 1.3], 'k--', 'LineWidth', 0.5);

% Mark and label the specified angles
colors = {'red', 'green', 'magenta', '#452020'};
for i = 1:length(angles)
    % Calculate the point on the circle
    x_point = cos(angles(i));
    y_point = sin(angles(i));
    
    % Draw line from origin to the point
    plot([0, x_point], [0, y_point], 'Color', colors{i}, 'LineWidth', 2);
    
    % Mark the point on the circle
    plot(x_point, y_point, 'o', 'Color', colors{i}, 'MarkerSize', 8, ...
         'MarkerFaceColor', colors{i}, 'MarkerEdgeColor', 'black');
    
    % Add angle label near the point
    label_radius = 1.15;
    x_label = label_radius * cos(angles(i));
    y_label = label_radius * sin(angles(i));
    text(x_label, y_label, angle_labels{i}, 'FontSize', 14, ...
         'HorizontalAlignment', 'center', 'FontWeight', 'bold', ...
         'Color', colors{i});
    
   
end

% Draw angle arcs for better visualization
arc_radius = 0.3;
for i = 1:length(angles)
    arc_theta = linspace(0, angles(i), 50);
    arc_x = arc_radius * cos(arc_theta);
    arc_y = arc_radius * sin(arc_theta);
    plot(arc_x, arc_y, 'Color', colors{i}, 'LineWidth', 1.5);
end

% Customize the plot
axis equal;
grid on;
xlim([-1.4, 1.4]);
ylim([-1.4, 1.4]);

% Set axis labels and title
xlabel('x (Real)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('y (Imaginary)', 'FontSize', 12, 'FontWeight', 'bold');
title('Unit Circle with Marked Angles', 'FontSize', 16, 'FontWeight', 'bold');

% Set tick font size
set(gca, 'FontSize', 12);

% Add degree equivalents in the legend
degree_labels = {'30°', '60°', '45°', '135°'};
legend_labels = cell(length(angles), 1);
for i = 1:length(angles)
    legend_labels{i} = sprintf('%s (%s)', angle_labels{i}, degree_labels{i});
end


% Add center point
plot(0, 0, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'black');

exportgraphics(f, 'figures/Ch01_radian_marking.pdf', 'BackgroundColor', 'none');



hold off;

