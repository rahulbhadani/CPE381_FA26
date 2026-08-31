% (C) Rahul Bhadani

%% Signal with Fixed Sampling-time
sampling_time = 0.5; % 0.5 seconds
final_time = 10; % 10 seconds
% Generate time points on which to evaluate the function
t = 0:sampling_time:final_time;
x = sin(t);
% Plotting
f = figure;
f.Position = [744   358   914   592]; % Position of figure on the screen
hold on;
plot(t, x, 'LineStyle','-', 'LineWidth',2,'Marker','o', ...
    'Color','#426642', ...
    'DisplayName', 'Sine Wave with Uniform Sampling');


%%  Signal with non-uniform sampling time

% Add small random perturbations
noise_amplitude = 0.05; % 10% of sampling_time
random_noise = (rand(size(t)) - 0.5) * 2 * noise_amplitude;
t_nonuniform = t + random_noise;
% ensure the first and last points of time-index remain same
t_nonuniform(1) = 0;
t_nonuniform(end) = final_time;
plot(t_nonuniform, x, 'LineStyle','-', 'LineWidth',2, 'Marker','o', ...
    'Color','#E34288', ...
    'DisplayName','Sine Wave with Non-Uniform Sampling');

% Signal with gaussian noise

mean = 0.0;
std_dev = 0.1;
gaussian_noise = std_dev * randn(size(t));
noisy_x = x + gaussian_noise;
plot(t_nonuniform, noisy_x, 'LineStyle','-', ...
    'LineWidth',2, 'Marker','o', ...
    'Color','#56EA23', ...
    'DisplayName','Noisy Sine Wave with Non-Uniform Sampling');


xlabel('Time [s]', 'Interpreter', 'latex', 'FontSize', 14);
xlim([-1, final_time+1]);
ylim([-2, 2]);
ylabel('x', 'FontSize',15, 'Interpreter','latex');
title('Signal Generation in MATLAB');
% Set tick font size
set(gca, 'FontSize', 15);
legend;
grid on;
exportgraphics(f, 'figures/Ch02_signal_generation.pdf', 'BackgroundColor', 'none');





