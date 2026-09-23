
% In this code, we simulae real power quality measurement
% We will use Fourier series to remove distortion in power masurement

clear all; close all; clc; clear;

fs = 1000; % Sampling frequencty in Hz (how often data is sampled)
duration = 0.25; % What is the duration of the signal

% time vector
t = linspace(0, duration, round(fs*duration));

% 60 Hz fundamental frequency
T_0 = 60; % Hz

% Power Grid Voltage
voltage = 120*sqrt(2)*sin(2 *pi*T_0*t);
% Generate harmonics component for distortion
harmonics_data = containers.Map({3, 5, 7, 11, 13}, {0.05, 0.06, 0.04, 0.035, 0.03});

% Add realistic harmonics based on IEEE standards
harmonic_keys = keys(harmonics_data);

% Initialize the distorted voltage signal
distortedVoltage = voltage;
for i = 1:length(harmonic_keys)
    harmonic = harmonic_keys{i};
    % Add the harmonic component to the distorted voltage
    amplitude = harmonics_data(harmonic);
    distortedVoltage = distortedVoltage + (120 * sqrt(2) * amplitude * sin(2 * pi * harmonic * T_0* t));
end

% add noise
noise = 2*randn(size(voltage));
distortedVoltage = distortedVoltage +  noise;

%%

% Compute Fourier Coefficients using Trigonometric Fourier Series
omega0  = 2*pi*T_0;

% DC Component
a0 = 2*trapz(t, distortedVoltage)/duration;
% Compute Fourier coefficients for harmonics

% Maximum Number of Harmonics to Compute
max_harmonics = 20;


a_n = zeros(1, max_harmonics + 1);
b_n = zeros(1, max_harmonics + 1);

for n = 1:max_harmonics
    
    % Cosine coefficients
    integrand_cos = distortedVoltage.* cos(n*omega0*t);
    a_n(n+1) = 2 * trapz(t, integrand_cos) / duration;
    
    % Sine coefficients
    integrand_sin = distortedVoltage .* sin(n * omega0 * t);
    b_n(n+1) = 2 * trapz(t, integrand_sin) / duration;
    
    fprintf('Computed harmonic %d/%d\n', n, max_harmonics);

end
fprintf('Fourier coefficients computed!\n');
fprintf('DC component (a0): %.4f\n', a0);

% Compute the Harmonics Power |X_k|^2
dc_power = (a0 / 2)^2;
total_power = dc_power;
harmonic_powers = zeros(1, max_harmonics);

for n = 1:max_harmonics
    harmonic_powers(n) = 0.5*sqrt((a_n(n+1)^2 + b_n(n+1)^2));
    total_power = total_power + harmonic_powers(n);
end

% Now we will compute total harmonic distortion (THD)
fundamental_power =harmonic_powers(1);
harmonic_power_sum = sum(harmonic_powers(2:end));

if fundamental_power > 0
    thd = sqrt(harmonic_power_sum / fundamental_power) * 100;
else
    thd = 0;
end

% Check IEEE 519 compliance (THD < 5% for low voltage systems)
if thd < 5.0
    compliance = 'PASS';
else
    compliance = 'FAIL';
end
fprintf('IEEE 519 Compliance: %s\n', compliance);


fprintf('\nTotal Harmonic Distortion (THD): %.2f%%\n', thd);
fprintf('DC Power: %.4f W\n', dc_power);


%% Reconstruct Signal using Fourier Series
% Only use first 10 harmonics
num_harmonics_recon = 10;
reconstructed = (a0 / 2) * ones(size(t));
for n = 1:num_harmonics_recon
    reconstructed = reconstructed + ...
        a_n(n+1) * cos(n * omega0 * t) + ...
        b_n(n+1) * sin(n * omega0 * t);
end

fprintf('Reconstruction Quality (10 harmonics): %.2f%%\n', ...
    (1 - norm(distortedVoltage - reconstructed) / norm(distortedVoltage)) * 100);

% plot
f = figure(1);
f.Position(3:4) = [1400, 500];
subplot(1,3,1);
plot(t, distortedVoltage, 'LineWidth',2, 'Color','#689212', 'DisplayName','Distorted Noisy Voltage');
grid on;
xlabel('time')
ylabel('Voltage (V)')
title('Power Grid Voltage')

% Harmonic Spectrum
subplot(1, 3, 2)
harmonics_plot = 1:15;
amplitudes = zeros(1, length(harmonics_plot));
for i = 1:length(harmonics_plot)
    n = harmonics_plot(i);
    amplitudes(i) = sqrt(harmonic_powers(n));
end
bar(harmonics_plot, amplitudes, 'FaceColor', [0.2 0.4 0.8]);
title('Harmonic Spectrum');
xlabel('Harmonic Number');
ylabel('Amplitude (V)');
grid on;

subplot(1,3,3);
plot(t, distortedVoltage, 'LineWidth',2, 'Color','#689212', 'DisplayName','Distorted Noisy Voltage');
hold on;
plot(t, reconstructed, 'LineWidth',1, 'LineStyle', '--', 'Color','#AB0282', 'DisplayName','Reconstructed Voltage');
grid on;
legend;
xlabel('time')
ylabel('Voltage (V)')
title('Power Grid Voltage')
