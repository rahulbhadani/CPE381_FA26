function Ch04_signal_decomposition_fourier_series()
%FOURIER_SERIES_DATASETS - Comprehensive Fourier Series analysis for ECE applications
%   This function provides synthetic datasets and analysis tools for:
%   1. Power grid voltage analysis (harmonics, Total Harmonic Distortion (THD))
%   2. Motor drive current analysis (PWM harmonics)  
%   3. Rectifier ripple analysis (DC power supplies)
%   4. Digital communication signal analysis (Manchester encoding)

    fprintf('Fourier Series Analysis with ECE Datasets\n');
    fprintf('==================================================\n');
    
    % Run all analyses and create plots
    create_analysis_plots();
    
    fprintf('\n==================================================\n');
    fprintf('DATASET ANALYSIS SUMMARY:\n');
    fprintf('1. Power Grid: Total Harmonic Distortion compliance checking for power quality\n');
    fprintf('2. Motor Drive: Harmonic analysis for efficiency and heating\n');
    fprintf('3. Rectifier: Ripple analysis for filter design\n');
    fprintf('4. Communication: Bandwidth analysis for signal transmission\n');
    fprintf('\nAll analyses use numerical integration to compute Fourier\n');
    fprintf('coefficients directly from measured data, not transforms.\n');
end

function data = generate_power_grid_dataset(duration, fs, harmonics_data)
%GENERATE_POWER_GRID_DATASET Generate synthetic power grid voltage data with harmonics
%   Simulates real power quality measurements
    
    % If you pass variable number of arguments
    if nargin < 1, duration = 1.0; end
    if nargin < 2, fs = 1000; end
    if nargin < 3
        harmonics_data = containers.Map({3, 5, 7, 11, 13}, ...
                                      {0.05, 0.06, 0.04, 0.035, 0.03});
    end
    
    t = linspace(0, duration, round(fs * duration));
    fundamental = 60; % Hz
    
    % Base 60 Hz sine wave
    voltage = 120 * sqrt(2) * sin(2 * pi * fundamental * t);
    
    % Add realistic harmonics based on IEEE standards
    harmonic_keys = keys(harmonics_data);
    for i = 1:length(harmonic_keys)
        harmonic = harmonic_keys{i};
        amplitude = harmonics_data(harmonic);
        voltage = voltage + 120 * sqrt(2) * amplitude * sin(2 * pi * harmonic * fundamental * t);
    end
    
    % Add noise to make it realistic
    noise = 2 * randn(size(voltage));
    voltage = voltage + noise;
    
    % Create a table of dataset
    data = struct();
    data.time = t;
    data.voltage = voltage;
    data.sampling_rate = fs;
    data.fundamental_freq = fundamental;
end

function data = generate_motor_current_dataset(duration, fs)
%GENERATE_MOTOR_CURRENT_DATASET Generate synthetic motor current data with PWM switching harmonics
%   Simulates variable frequency drive measurements
    
    if nargin < 1, duration = 0.5; end
    if nargin < 2, fs = 2000; end
    
    t = linspace(0, duration, round(fs * duration));
    motor_freq = 30; % Hz motor frequency
    pwm_freq = 2000; % Hz PWM switching frequency
    
    % Fundamental motor current (sinusoidal)
    current = 10 * sin(2 * pi * motor_freq * t);
    
    % PWM switching harmonics (simplified model)
    pwm_harmonics = containers.Map(...
        {pwm_freq - motor_freq, pwm_freq + motor_freq, ...
         2*pwm_freq - motor_freq, 2*pwm_freq + motor_freq}, ...
        {0.3, 0.3, 0.2, 0.2});
    
    harmonic_keys = keys(pwm_harmonics);
    for i = 1:length(harmonic_keys)
        freq = harmonic_keys{i};
        amp = pwm_harmonics(freq);
        current = current + amp * sin(2 * pi * freq * t);
    end
    
    % Add measurement noise
    noise = 0.1 * randn(size(current));
    current = current + noise;
    
    data = struct();
    data.time = t;
    data.current = current;
    data.sampling_rate = fs;
    data.motor_freq = motor_freq;
    data.pwm_freq = pwm_freq;
end

function data = generate_rectifier_dataset(duration, fs)
%GENERATE_RECTIFIER_DATASET Generate synthetic rectifier output data
%   Simulates DC power supply measurements
    
    if nargin < 1, duration = 0.1; end
    if nargin < 2, fs = 5000; end
    
    t = linspace(0, duration, round(fs * duration));
    line_freq = 60; % Hz
    
    % Full-wave rectifier output (theoretical)
    dc_component = 100; % V
    voltage = dc_component * ones(size(t));
    
    % Add ripple components (even harmonics)
    ripple_harmonics = containers.Map({2, 4, 6, 8}, {0.4, 0.1, 0.05, 0.02});
    
    harmonic_keys = keys(ripple_harmonics);
    for i = 1:length(harmonic_keys)
        harmonic = harmonic_keys{i};
        amplitude = ripple_harmonics(harmonic);
        voltage = voltage + dc_component * amplitude * cos(2 * pi * harmonic * line_freq * t);
    end
    
    % Add switching noise (high frequency)
    switching_noise = 2 * randn(size(voltage));
    voltage = voltage + switching_noise;
    
    data = struct();
    data.time = t;
    data.voltage = voltage;
    data.sampling_rate = fs;
    data.line_freq = line_freq;
    data.dc_component = dc_component;
end

function data = generate_communication_signal_dataset(duration, fs, bit_rate)
%GENERATE_COMMUNICATION_SIGNAL_DATASET Generate digital communication signal with Manchester encoding
%   Simulates digital data transmission measurements
    
    if nargin < 1, duration = 0.01; end
    if nargin < 2, fs = 10000; end
    if nargin < 3, bit_rate = 1000; end
    
    t = linspace(0, duration, round(fs * duration));
    
    % Generate random bit sequence
    num_bits = round(duration * bit_rate);
    bits = randi([0, 1], 1, num_bits);
    
    % Manchester encoding: 0 -> high-to-low, 1 -> low-to-high
    signal_data = zeros(size(t));
    bit_duration = 1 / bit_rate;
    
    for i = 1:num_bits
        start_time = (i-1) * bit_duration;
        end_time = i * bit_duration;
        mid_time = start_time + bit_duration / 2;
        
        % Find indices for this bit period
        start_idx = round(start_time * fs) + 1;
        mid_idx = round(mid_time * fs) + 1;
        end_idx = round(end_time * fs) + 1;
        
        if end_idx > length(signal_data)
            break;
        end
        
        if bits(i) == 0  % High-to-low transition
            signal_data(start_idx:mid_idx-1) = 1;
            signal_data(mid_idx:end_idx) = -1;
        else  % Low-to-high transition
            signal_data(start_idx:mid_idx-1) = -1;
            signal_data(mid_idx:end_idx) = 1;
        end
    end
    
    % Add channel noise and distortion
    noise = 0.1 * randn(size(signal_data));
    signal_data = signal_data + noise;
    
    data = struct();
    data.time = t;
    data.signal = signal_data;
    data.sampling_rate = fs;
    data.bit_rate = bit_rate;
    data.bits = bits;
end

function analyzer = FourierSeriesAnalyzer(data, time_col, signal_col, max_harmonics)
%FOURIERSERIESANALYZER for performing Fourier Series analysis on real datasets
    
    if nargin < 4, max_harmonics = 20; end
    
    analyzer = struct();
    analyzer.time = data.(time_col);
    analyzer.signal = data.(signal_col);
    analyzer.max_harmonics = max_harmonics;
    analyzer.T = analyzer.time(end) - analyzer.time(1); % Period
    analyzer.fs = length(analyzer.time) / analyzer.T; % Sampling frequency
    
    % Add function handles
    analyzer.compute_fourier_coefficients = @(fundamental_freq) compute_fourier_coefficients_impl(analyzer, fundamental_freq);
    analyzer.reconstruct_signal = @(coefficients, num_harmonics) reconstruct_signal_impl(analyzer, coefficients, num_harmonics);
    analyzer.calculate_power_spectrum = @(coefficients) calculate_power_spectrum_impl(coefficients);
    analyzer.calculate_thd = @(coefficients) calculate_thd_impl(coefficients);
end

function coeffs = compute_fourier_coefficients_impl(analyzer, fundamental_freq)
%COMPUTE_FOURIER_COEFFICIENTS_IMPL Compute Fourier series coefficients from dataset
%   Uses numerical integration (trapezoidal rule)
    
    if nargin < 2 || isempty(fundamental_freq)
        fundamental_freq = 1 / analyzer.T;
    end
    
    omega0 = 2 * pi * fundamental_freq;
    
    % DC component
    a0 = 2 * trapz(analyzer.time, analyzer.signal) / analyzer.T;
    
    % Initialize coefficient arrays
    an_coeffs = zeros(1, analyzer.max_harmonics + 1);
    bn_coeffs = zeros(1, analyzer.max_harmonics + 1);
    
    % Calculate harmonics
    for n = 1:analyzer.max_harmonics
        % Cosine coefficients
        integrand_cos = analyzer.signal .* cos(n * omega0 * analyzer.time);
        an_coeffs(n+1) = 2 * trapz(analyzer.time, integrand_cos) / analyzer.T;
        Class
        % Sine coefficients
        integrand_sin = analyzer.signal .* sin(n * omega0 * analyzer.time);
        bn_coeffs(n+1) = 2 * trapz(analyzer.time, integrand_sin) / analyzer.T;
    end
    
    coeffs = struct();
    coeffs.a0 = a0;
    coeffs.an = an_coeffs;
    coeffs.bn = bn_coeffs;
    coeffs.fundamental_freq = fundamental_freq;
end

function reconstructed = reconstruct_signal_impl(analyzer, coefficients, num_harmonics)
%RECONSTRUCT_SIGNAL_IMPL Reconstruct signal using computed Fourier coefficients
    
    if nargin < 3 || isempty(num_harmonics)
        num_harmonics = analyzer.max_harmonics;
    end
    
    omega0 = 2 * pi * coefficients.fundamental_freq;
    
    % Start with DC component
    reconstructed = coefficients.a0 / 2 * ones(size(analyzer.time));
    
    % Add harmonics
    for n = 1:min(num_harmonics, length(coefficients.an)-1)
        reconstructed = reconstructed + ...
            coefficients.an(n+1) * cos(n * omega0 * analyzer.time) + ...
            coefficients.bn(n+1) * sin(n * omega0 * analyzer.time);
    end
end

function power_spectrum = calculate_power_spectrum_impl(coefficients)
%CALCULATE_POWER_SPECTRUM_IMPL Calculate power distribution across harmonics
    
    power_spectrum = struct();
    total_power = 0;
    
    % DC power
    dc_power = (coefficients.a0 / 2)^2;
    power_spectrum.DC = dc_power;
    total_power = total_power + dc_power;
    
    % Harmonic powers
    for n = 1:length(coefficients.an)-1
        if n < length(coefficients.bn)
            harmonic_power = 0.5 * (coefficients.an(n+1)^2 + coefficients.bn(n+1)^2);
            power_spectrum.(sprintf('H%d', n)) = harmonic_power;
            total_power = total_power + harmonic_power;
        end
    end
    
    power_spectrum.Total = total_power;
end

function thd = calculate_thd_impl(coefficients)
%CALCULATE_THD_IMPL Calculate Total Harmonic Distortion
    
    if length(coefficients.an) < 2
        thd = 0;
        return;
    end
    
    fundamental_power = 0.5 * (coefficients.an(2)^2 + coefficients.bn(2)^2);
    harmonic_power = 0;
    
    for n = 2:length(coefficients.an)-1
        if n+1 <= length(coefficients.bn)
            harmonic_power = harmonic_power + ...
                0.5 * (coefficients.an(n+1)^2 + coefficients.bn(n+1)^2);
        end
    end
    
    if fundamental_power > 0
        thd = sqrt(harmonic_power / fundamental_power) * 100;
    else
        thd = 0;
    end
end

function [data, coeffs, analyzer] = analyze_power_quality_dataset()
%ANALYZE_POWER_QUALITY_DATASET Example 1: Power Quality Analysis
    
    fprintf('=== POWER QUALITY ANALYSIS ===\n');
    
    % Generate power grid dataset
    grid_data = generate_power_grid_dataset(1.0, 1000);
    
    % Perform Fourier analysis
    analyzer = FourierSeriesAnalyzer(grid_data, 'time', 'voltage', 20);
    coeffs = analyzer.compute_fourier_coefficients(60);
    
    % Calculate THD
    thd = analyzer.calculate_thd(coeffs);
    fprintf('Total Harmonic Distortion: %.2f%%\n', thd);
    
    % Power spectrum analysis
    power_spec = analyzer.calculate_power_spectrum(coeffs);
    fprintf('DC Component Power: %.2f W\n', power_spec.DC);
    fprintf('Fundamental Power: %.2f W\n', power_spec.H1);
    
    % Check IEEE 519 compliance (THD < 5% for low voltage)
    if thd < 5.0
        compliance = 'PASS';
    else
        compliance = 'FAIL';
    end
    fprintf('IEEE 519 Compliance: %s\n', compliance);
    
    data = grid_data;
end

function [data, coeffs, analyzer] = analyze_motor_drive_dataset()
%ANALYZE_MOTOR_DRIVE_DATASET Example 2: Motor Drive Harmonic Analysis
    
    fprintf('\n=== MOTOR DRIVE ANALYSIS ===\n');
    
    % Generate motor current dataset
    motor_data = generate_motor_current_dataset(0.5, 2000);
    
    % Analyze with Fourier series
    analyzer = FourierSeriesAnalyzer(motor_data, 'time', 'current', 50);
    coeffs = analyzer.compute_fourier_coefficients(30);
    
    % Calculate current THD
    thd = analyzer.calculate_thd(coeffs);
    fprintf('Current THD: %.2f%%\n', thd);
    
    % Motor heating factor (additional losses due to harmonics)
    power_spec = analyzer.calculate_power_spectrum(coeffs);
    fundamental_power = power_spec.H1;
    
    % Sum all harmonic powers except fundamental
    field_names = fieldnames(power_spec);
    total_harmonic_power = 0;
    for i = 1:length(field_names)
        field_name = field_names{i};
        if startsWith(field_name, 'H') && ~strcmp(field_name, 'H1')
            total_harmonic_power = total_harmonic_power + power_spec.(field_name);
        end
    end
    
    heating_factor = 1 + (total_harmonic_power / fundamental_power);
    fprintf('Motor Heating Factor: %.3f\n', heating_factor);
    
    data = motor_data;
end

function [data, coeffs, analyzer] = analyze_rectifier_dataset()
%ANALYZE_RECTIFIER_DATASET Example 3: DC Power Supply Ripple Analysis
    
    fprintf('\n=== RECTIFIER RIPPLE ANALYSIS ===\n');
    
    % Generate rectifier output dataset
    rectifier_data = generate_rectifier_dataset(0.1, 5000);
    
    % Analyze ripple content
    analyzer = FourierSeriesAnalyzer(rectifier_data, 'time', 'voltage', 15);
    coeffs = analyzer.compute_fourier_coefficients(120); % 120 Hz ripple
    
    % Calculate ripple factor
    dc_value = coeffs.a0 / 2;
    ac_power = 0;
    for n = 1:length(coeffs.an)-1
        if n+1 <= length(coeffs.bn)
            ac_power = ac_power + 0.5 * (coeffs.an(n+1)^2 + coeffs.bn(n+1)^2);
        end
    end
    ripple_factor = sqrt(ac_power) / dc_value * 100;
    
    fprintf('DC Output: %.2f V\n', dc_value);
    fprintf('Ripple Factor: %.2f%%\n', ripple_factor);
    
    if length(coeffs.an) >= 2 && length(coeffs.bn) >= 2
        ripple_120hz = sqrt(0.5 * (coeffs.an(2)^2 + coeffs.bn(2)^2));
        fprintf('120 Hz Component: %.2f V\n', ripple_120hz);
    end
    
    data = rectifier_data;
end

function [data, coeffs, analyzer] = analyze_communication_dataset()
%ANALYZE_COMMUNICATION_DATASET Example 4: Digital Communication Signal Analysis
    
    fprintf('\n=== DIGITAL COMMUNICATION ANALYSIS ===\n');
    
    % Generate Manchester encoded signal
    comm_data = generate_communication_signal_dataset(0.01, 10000, 1000);
    
    % Analyze spectrum
    analyzer = FourierSeriesAnalyzer(comm_data, 'time', 'signal', 30);
    coeffs = analyzer.compute_fourier_coefficients(1000);
    
    % Calculate bandwidth (99% power bandwidth)
    power_spec = analyzer.calculate_power_spectrum(coeffs);
    total_power = power_spec.Total;
    cumulative_power = 0;
    bandwidth_99 = 0;
    
    for n = 1:length(coeffs.an)-1
        field_name = sprintf('H%d', n);
        if isfield(power_spec, field_name)
            cumulative_power = cumulative_power + power_spec.(field_name);
            if cumulative_power / total_power >= 0.99
                bandwidth_99 = n * coeffs.fundamental_freq;
                break;
            end
        end
    end
    
    fprintf('Signal Power: %.4f\n', total_power);
    fprintf('99%% Power Bandwidth: %.0f Hz\n', bandwidth_99);
    fprintf('Theoretical Bandwidth (Manchester): %.0f Hz\n', 2 * coeffs.fundamental_freq);
    
    data = comm_data;
end

function create_analysis_plots()
%CREATE_ANALYSIS_PLOTS Create comprehensive plots for all dataset analyses
    
    figure('Position', [100, 100, 1400, 1000]);
    
    % Analysis 1: Power Grid
    [grid_data, grid_coeffs, grid_analyzer] = analyze_power_quality_dataset();
    
    % Time domain plot
    subplot(4, 3, 1);
    plot_range = 1:min(500, length(grid_data.voltage));
    plot(grid_data.time(plot_range), grid_data.voltage(plot_range), 'b-', 'LineWidth', 1);
    title('Power Grid Voltage');
    xlabel('Time (s)');
    ylabel('Voltage (V)');
    grid on;
    
    % Harmonic spectrum
    subplot(4, 3, 2);
    harmonics = 1:min(15, length(grid_coeffs.an)-1);
    amplitudes = zeros(1, length(harmonics));
    for i = 1:length(harmonics)
        n = harmonics(i);
        if n+1 <= length(grid_coeffs.an) && n+1 <= length(grid_coeffs.bn)
            amplitudes(i) = sqrt(0.5 * (grid_coeffs.an(n+1)^2 + grid_coeffs.bn(n+1)^2));
        end
    end
    bar(harmonics, amplitudes);
    title('Harmonic Spectrum');
    xlabel('Harmonic Number');
    ylabel('Amplitude (V)');
    grid on;
    
    % Reconstruction comparison
    subplot(4, 3, 3);
    reconstructed = grid_analyzer.reconstruct_signal(grid_coeffs, 10);
    plot_range = 1:min(200, length(grid_data.voltage));
    plot(grid_data.time(plot_range), grid_data.voltage(plot_range), 'b-', 'DisplayName', 'Original');
    hold on;
    plot(grid_data.time(plot_range), reconstructed(plot_range), 'r--', 'DisplayName', '10 harmonics');
    title('Signal Reconstruction');
    legend('show');
    grid on;
    hold off;
    
    % Analysis 2: Motor Drive
    [motor_data, motor_coeffs, motor_analyzer] = analyze_motor_drive_dataset();
    
    subplot(4, 3, 4);
    plot_range = 1:min(1000, length(motor_data.current));
    plot(motor_data.time(plot_range), motor_data.current(plot_range), 'g-', 'LineWidth', 1);
    title('Motor Current');
    xlabel('Time (s)');
    ylabel('Current (A)');
    grid on;
    
    % Motor harmonic spectrum
    subplot(4, 3, 5);
    motor_harmonics = 1:20;
    motor_amplitudes = zeros(1, length(motor_harmonics));
    for i = 1:length(motor_harmonics)
        n = motor_harmonics(i);
        if n+1 <= length(motor_coeffs.an) && n+1 <= length(motor_coeffs.bn)
            motor_amplitudes(i) = sqrt(0.5 * (motor_coeffs.an(n+1)^2 + motor_coeffs.bn(n+1)^2));
        end
    end
    bar(motor_harmonics, motor_amplitudes);
    title('Motor Current Harmonics');
    xlabel('Harmonic Number');
    ylabel('Amplitude (A)');
    grid on;
    
    subplot(4, 3, 6);
    motor_reconstructed = motor_analyzer.reconstruct_signal(motor_coeffs, 15);
    plot_range = 1:min(500, length(motor_data.current));
    plot(motor_data.time(plot_range), motor_data.current(plot_range), 'g-', 'DisplayName', 'Original');
    hold on;
    plot(motor_data.time(plot_range), motor_reconstructed(plot_range), 'r--', 'DisplayName', '15 harmonics');
    title('Motor Current Reconstruction');
    legend('show');
    grid on;
    hold off;
    
    % Analysis 3: Rectifier
    [rect_data, rect_coeffs, rect_analyzer] = analyze_rectifier_dataset();
    
    subplot(4, 3, 7);
    plot(rect_data.time, rect_data.voltage, 'm-', 'LineWidth', 1);
    title('Rectifier Output Voltage');
    xlabel('Time (s)');
    ylabel('Voltage (V)');
    grid on;
    
    % Ripple harmonics
    subplot(4, 3, 8);
    rect_harmonics = 1:10;
    rect_amplitudes = zeros(1, length(rect_harmonics));
    for i = 1:length(rect_harmonics)
        n = rect_harmonics(i);
        if n+1 <= length(rect_coeffs.an) && n+1 <= length(rect_coeffs.bn)
            rect_amplitudes(i) = sqrt(0.5 * (rect_coeffs.an(n+1)^2 + rect_coeffs.bn(n+1)^2));
        end
    end
    bar(rect_harmonics, rect_amplitudes);
    title('Ripple Harmonics (120Hz base)');
    xlabel('Harmonic Number');
    ylabel('Amplitude (V)');
    grid on;
    
    subplot(4, 3, 9);
    rect_reconstructed = rect_analyzer.reconstruct_signal(rect_coeffs, 8);
    plot(rect_data.time, rect_data.voltage, 'm-', 'DisplayName', 'Original');
    hold on;
    plot(rect_data.time, rect_reconstructed, 'r--', 'DisplayName', '8 harmonics');
    title('Rectifier Signal Reconstruction');
    legend('show');
    grid on;
    hold off;
    
    % Analysis 4: Communication Signal
    [comm_data, comm_coeffs, comm_analyzer] = analyze_communication_dataset();
    
    subplot(4, 3, 10);
    plot(comm_data.time, comm_data.signal, 'c-', 'LineWidth', 1);
    title('Manchester Encoded Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
    
    % Communication spectrum
    subplot(4, 3, 11);
    comm_harmonics = 1:20;
    comm_amplitudes = zeros(1, length(comm_harmonics));
    for i = 1:length(comm_harmonics)
        n = comm_harmonics(i);
        if n+1 <= length(comm_coeffs.an) && n+1 <= length(comm_coeffs.bn)
            comm_amplitudes(i) = sqrt(0.5 * (comm_coeffs.an(n+1)^2 + comm_coeffs.bn(n+1)^2));
        end
    end
    bar(comm_harmonics, comm_amplitudes);
    title('Communication Signal Spectrum');
    xlabel('Harmonic Number');
    ylabel('Amplitude');
    grid on;
    
    subplot(4, 3, 12);
    comm_reconstructed = comm_analyzer.reconstruct_signal(comm_coeffs, 12);
    plot(comm_data.time, comm_data.signal, 'c-', 'DisplayName', 'Original');
    hold on;
    plot(comm_data.time, comm_reconstructed, 'r--', 'DisplayName', '12 harmonics');
    title('Communication Signal Reconstruction');
    legend('show');
    grid on;
    hold off;
    
    sgtitle('Fourier Series Analysis of ECE Datasets', 'FontSize', 16);
end