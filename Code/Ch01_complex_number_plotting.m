% Plot complex numbers on the complex plane
% Define the complex numbers
z1 = 2 + 3i;    % 2 + i3
z2 = 3 - 2i;    % 3 - i2  
z3 = -2 - 2i;    % 2 - i2
z4 = -4 + 2i;   % -4 + j2

% Create arrays of complex numbers for easier plotting
z = [z1, z2, z3, z4];

% Create the plot
f =figure('Position', [100, 100, 800, 600]);
hold on;
set(gca, 'FontSize', 14);
% Plot each complex number as a point
plot(real(z), imag(z), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'red');

% Plot vectors from origin to each point
for k = 1:length(z)
    plot([0, real(z(k))], [0, imag(z(k))], 'b-', 'LineWidth', 1.5);
end

% Add labels for each point
labels = {'2+3i', '3-2i', '2-2i', '-4+2i'};
for k = 1:length(z)
    text(real(z(k)) + 0.2, imag(z(k)) + 0.2, labels{k}, ...
         'FontSize', 12, 'FontWeight', 'bold');
end

% Customize the plot
grid on;
axis equal;
xlabel('Real Part', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Imaginary Part', 'FontSize', 16, 'FontWeight', 'bold');
title('Complex Numbers on the Complex Plane', 'FontSize', 18, 'FontWeight', 'bold');

% Add axes through origin
axisLimits = axis;
plot([axisLimits(1), axisLimits(2)], [0, 0], 'k--', 'LineWidth', 0.5);
plot([0, 0], [axisLimits(3), axisLimits(4)], 'k--', 'LineWidth', 0.5);

% Set appropriate axis limits with some padding
realParts = real(z);
imagParts = imag(z);
xRange = max(realParts) - min(realParts);
yRange = max(imagParts) - min(imagParts);
padding = 0.5;

xlim([min(realParts) - padding, max(realParts) + padding]);
ylim([min(imagParts) - padding, max(imagParts) + padding]);


% Add legend
L = legend('Complex Numbers', 'Vectors from Origin', 'Location', 'northwest');
L.FontSize=14;

exportgraphics(f, 'figures/Ch01_complex_number_plotting.pdf', 'BackgroundColor', 'none');


hold off;