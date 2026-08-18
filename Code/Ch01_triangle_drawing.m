% Draw a right triangle with labeled sides and angle
clear; clc;

% Define the triangle vertices
% Right angle at origin, horizontal base, vertical side
A = [0, 0];     % Right angle vertex
B = [3, 0];     % End of horizontal side (base)
C = [0, 2];     % End of vertical side (height)

% Create the figure
f = figure;
hold on;

% Draw the triangle
triangle_x = [A(1), B(1), C(1), A(1)];
triangle_y = [A(2), B(2), C(2), A(2)];
plot(triangle_x, triangle_y, 'b-', 'LineWidth', 3);

% Draw the right angle indicator (small square)
square_size = 0.2;
right_angle_x = [A(1), A(1) + square_size, A(1) + square_size, A(1), A(1)];
right_angle_y = [A(2), A(2), A(2) + square_size, A(2) + square_size, A(2)];
plot(right_angle_x, right_angle_y, 'b-', 'LineWidth', 2);

% Calculate the hypotenuse length
c = sqrt((B(1) - C(1))^2 + (B(2) - C(2))^2);

% Add side labels
% Label for base (b = 1, but we'll use 3 for better visualization)
text((A(1) + B(1))/2, A(2) - 0.3, '1', 'FontSize', 16, 'FontWeight', 'bold', ...
     'HorizontalAlignment', 'center', 'Color', 'blue');

% Label for height (a - 1, but we'll use 2 for better visualization)  
text(A(1) - 0.3, (A(2) + C(2))/2, '1', 'FontSize', 16, 'FontWeight', 'bold', ...
     'HorizontalAlignment', 'center', 'Color', 'blue', 'Rotation', 90)

% Label for hypotenuse
text((B(1) + C(1))/2 - 0.2, (B(2) + C(2))/2 + 0.5, '$\sqrt{2}$', ...
     'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
     'Color', 'blue', 'Rotation', -33.7, 'Interpreter', 'latex')

% Add angle θ label
angle_radius = 0.4;
% Calculate the angle at point B (between base and hypotenuse)
angle_start = atan2(A(2) - B(2), A(1) - B(1)); % Angle from B to A
angle_end = atan2(C(2) - B(2), C(1) - B(1));   % Angle from B to C
angle_theta = linspace(angle_start, angle_end, 20);
angle_x = B(1) + angle_radius * cos(angle_theta);
angle_y = B(2) + angle_radius * sin(angle_theta);
plot(angle_x, angle_y, 'b-', 'LineWidth', 2);

% Add θ label at point B
theta_angle = (angle_start + angle_end) / 2;
theta_label_x = B(1) + 0.6 * cos(theta_angle);
theta_label_y = B(2) + 0.6 * sin(theta_angle);
text(theta_label_x, theta_label_y, '\theta', 'FontSize', 16, 'FontWeight', 'bold', ...
     'HorizontalAlignment', 'center', 'Color', 'blue', 'Interpreter', 'tex');


% Set equal axis scaling and limits
axis equal;
xlim([-1, 4]);
ylim([-1, 3]);

% Add grid
grid on;
set(gca, 'GridAlpha', 0.3);

% Remove axis labels and ticks for cleaner look
set(gca, 'XTick', [], 'YTick', []);

% Set background color
set(gca, 'Color', [0.98, 0.98, 0.98]);



axis off;
% Set tick font size
set(gca, 'FontSize', 12);

exportgraphics(f, 'figures/Ch01_triangle_drawing.pdf', 'BackgroundColor', 'none');

hold off;