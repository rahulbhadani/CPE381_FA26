% MATLAB Code to smooth main power data using Fourier Series
% Flat code without functions or classes

clear; clc;

% ========== LOAD DATA FROM CSV ==========
fprintf('Loading main power subset data...\n');
data_table = readtable('../Data/main_power_subset.csv');
time = data_table.time_seconds;
signal = data_table.amplitude_raw;

fprintf('Data loaded: %d points\n', length(signal));
fprintf('Duration: %.4f seconds\n', time(end) - time(1));

% ========== PARAMETERS ==========
T = time(end) - time(1);  % Period (total duration)
fs = length(time) / T;     % Sampling frequency
fundamental_freq = 60;     % Hz (power grid fundamental)
max_harmonics = 20;        % Number of harmonics to compute

fprintf('\nSampling rate: %.0f Hz\n', fs);
fprintf('Fundamental frequency: %.0f Hz\n', fundamental_freq);
fprintf('Max harmonics: %d\n', max_harmonics);

% ========== COMPUTE FOURIER COEFFICIENTS ==========
fprintf('\nComputing Fourier coefficients...\n');

omega0 = 2 * pi * fundamental_freq;

% DC component (a0)
a0 = 2 * trapz(time, signal) / T;

% Initialize coefficient arrays
an_coeffs = zeros(1, max_harmonics);
bn_coeffs = zeros(1, max_harmonics);

% Calculate harmonics using numerical integration (trapezoidal rule)
for n = 1:max_harmonics
    % Cosine coefficients
    integrand_cos = signal .* cos(n * omega0 * time);
    an_coeffs(n) = 2 * trapz(time, integrand_cos) / T;
    
    % Sine coefficients
    integrand_sin = signal .* sin(n * omega0 * time);
    bn_coeffs(n) = 2 * trapz(time, integrand_sin) / T;
    
    if mod(n, 5) == 0
        fprintf('  Computed harmonic %d/%d\n', n, max_harmonics);
    end
end

fprintf('Fourier coefficients computed!\n');
fprintf('DC component (a0): %.4f\n', a0);

% ========== CALCULATE HARMONIC AMPLITUDES ==========
harmonic_amplitudes = zeros(1, max_harmonics);
for n = 1:max_harmonics
    harmonic_amplitudes(n) = sqrt(0.5 * (an_coeffs(n)^2 + bn_coeffs(n)^2));
end

% ========== CALCULATE THD ==========
fundamental_power = 0.5 * (an_coeffs(1)^2 + bn_coeffs(1)^2);
harmonic_power = 0;
for n = 2:max_harmonics
    harmonic_power = harmonic_power + 0.5 * (an_coeffs(n)^2 + bn_coeffs(n)^2);
end

if fundamental_power > 0
    thd = sqrt(harmonic_power / fundamental_power) * 100;
else
    thd = 0;
end

fprintf('\nTotal Harmonic Distortion (THD): %.2f%%\n', thd);

% ========== RECONSTRUCT SIGNAL WITH DIFFERENT HARMONICS ==========
fprintf('\nReconstructing signals...\n');

% Number of harmonics for different reconstructions
num_harmonics_list = [1, 3, 5, 10, 15, 20];
reconstructed_signals = cell(1, length(num_harmonics_list));

for idx = 1:length(num_harmonics_list)
    num_harmonics = num_harmonics_list(idx);
    
    % Start with DC component
    reconstructed = (a0 / 2) * ones(size(time));
    
    % Add harmonics
    for n = 1:min(num_harmonics, max_harmonics)
        reconstructed = reconstructed + ...
            an_coeffs(n) * cos(n * omega0 * time) + ...
            bn_coeffs(n) * sin(n * omega0 * time);
    end
    
    reconstructed_signals{idx} = reconstructed;
    fprintf('  Reconstructed with %d harmonics\n', num_harmonics);
end

% ========== PLOTTING ==========
fprintf('\nCreating plots...\n');

f  = figure('Position', [100, 100, 1400, 1000]);

% Plot 1: Original signal (time domain)
subplot(3, 3, 1);
plot(time * 1000, signal, 'b-', 'LineWidth', 1);
title('Original Signal (Full)');
xlabel('Time (ms)');
ylabel('Amplitude (raw)');
grid on;

% Plot 2: Original signal (zoomed - first 5 cycles)
subplot(3, 3, 2);
cycles_to_show = 5;
duration_cycles = cycles_to_show / fundamental_freq;
idx_zoom = time <= duration_cycles;
plot(time(idx_zoom) * 1000, signal(idx_zoom), 'b-', 'LineWidth', 1.5);
title(sprintf('Original Signal (First %d cycles)', cycles_to_show));
xlabel('Time (ms)');
ylabel('Amplitude (raw)');
grid on;

% Plot 3: Harmonic spectrum
subplot(3, 3, 3);
bar(1:max_harmonics, harmonic_amplitudes);
title('Harmonic Spectrum');
xlabel('Harmonic Number');
ylabel('Amplitude');
grid on;
text(max_harmonics*0.6, max(harmonic_amplitudes)*0.9, sprintf('THD: %.2f%%', thd), ...
    'FontSize', 10, 'BackgroundColor', 'white');

% Plot 4-9: Reconstructed signals with different numbers of harmonics
for idx = 1:length(num_harmonics_list)
    subplot(3, 3, 3 + idx);
    num_harmonics = num_harmonics_list(idx);
    reconstructed = reconstructed_signals{idx};
    
    % Plot zoomed version for better visibility
    plot(time(idx_zoom) * 1000, signal(idx_zoom), 'b-', 'LineWidth', 1, 'DisplayName', 'Original');
    hold on;
    plot(time(idx_zoom) * 1000, reconstructed(idx_zoom), 'r--', 'LineWidth', 1.5, ...
        'DisplayName', sprintf('%d harmonics', num_harmonics));
    hold off;
    
    title(sprintf('Reconstructed (%d harmonics)', num_harmonics));
    xlabel('Time (ms)');
    ylabel('Amplitude');
    legend('show', 'Location', 'best');
    grid on;
    
    % Calculate reconstruction error
    error_rms = sqrt(mean((signal - reconstructed).^2));
    fprintf("RMS Error for %d harmonics are: %f\n", num_harmonics, error_rms);
    error_percent = (error_rms / std(signal)) * 100;
    fprintf("RMS ERROR PERCENT for %d harmonics are: %f\n", num_harmonics, error_percent);

    text(min(time(idx_zoom))*1000 + 1, max(signal(idx_zoom))*0.9, ...
        sprintf('Error: %.2f%%', error_percent), 'FontSize', 8, 'BackgroundColor', 'white');
end

sgtitle('Fourier Series Analysis: Main Power Signal Smoothing', 'FontSize', 14, 'FontWeight', 'bold');

exportgraphics(f, 'figures/HW04_main_power_subset_analysis.pdf');


% ========== SAVE SMOOTHED DATA ==========
fprintf('\nSaving smoothed data...\n');

% Choose the best reconstruction (e.g., 10 harmonics for good smoothing)
smoothed_signal = reconstructed_signals{4};  % 10 harmonics

% Create output table
output_table = table(time, signal, smoothed_signal, ...
    'VariableNames', {'time_seconds', 'original_signal', 'smoothed_signal'});

% Save to CSV
writetable(output_table, 'main_power_smoothed.csv');
fprintf('Smoothed data saved to: main_power_smoothed.csv\n');


fprintf('Original signal: %d points\n', length(signal));
fprintf('DC component: %.4f\n', a0);
fprintf('Fundamental amplitude: %.4f\n', harmonic_amplitudes(1));
fprintf('THD: %.2f%%\n', thd);
fprintf('Recommended harmonics for smoothing: 10-15\n');
fprintf('Top 3 harmonic amplitudes:\n');
[sorted_amps, sorted_idx] = sort(harmonic_amplitudes, 'descend');
for i = 1:min(3, length(sorted_amps))
    fprintf('  Harmonic %d: %.4f\n', sorted_idx(i), sorted_amps(i));
end
