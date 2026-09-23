%(C) Rahul Bhadani
L = 5;
% Define the time vector
t = 0:0.01:2*L;
% Define the fundamental and harmonics
fundamental = sin(2*pi*t/L);
harmonics_2 = fundamental + (1/3)*sin(6*pi*t/L);
harmonics_5 = fundamental + (1/3)*sin(6*pi*t/L) + (1/5)*sin(10*pi*t/L) + (1/7)*sin(14*pi*t/L) + (1/9)*sin(18*pi*t/L);
harmonics_20 = 0;
for i = 1:20
    harmonics_20 = harmonics_20 + (4/pi)*(1/(2*i-1))*sin((2*i-1)*2*pi*t/L);
end

% Create the figure
f = figure;
f.Position(3:4) = [1200, 500];
hold on;
plot(t, fundamental, '-', 'LineWidth', 1.5, 'DisplayName','Fundamental (1 Sine Wave)');
plot(t, harmonics_2, '-', 'LineWidth', 1.5, 'DisplayName','Fundamental + 2 harmonics');
plot(t, harmonics_5, '-', 'LineWidth', 1.5, 'DisplayName','Fundamental + 5 harmonics');
plot(t, harmonics_20, '-', 'LineWidth',1.5, 'DisplayName','Fundamental + 20 harmonics');
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
ylim([-1.5, 1.5]);
xlim([0, 10]);
yaxis.TickLabelInterpreter = 'latex';
xlabel('Time','Interpreter', 'latex');
title(sprintf('Sine wave with period $L=%d$ and harmonics', L), 'Interpreter', 'latex');
legend('Interpreter', 'latex');
set(gca, 'FontSize', 16);
grid on;
grid minor;
ylim([-3, 3]);
exportgraphics(f, 'figures/sine_wave_with_harmonics.pdf');

%%

% Define the number of harmonics
n_harmonics = 20;

% Define the amplitudes of the harmonics
amplitudes = zeros(1, n_harmonics);
for i = 1:n_harmonics
    amplitudes(i) = (4/pi)*(1/(2*i-1));
end

% Calculate the power of each harmonic
powers = abs(amplitudes).^2;

% Create the figure
f = figure(2);
stem(1:n_harmonics, powers, 'b-', 'LineWidth', 2);
grid on;
grid minor;
set(gca, 'FontSize', 16);
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
ylim([0, 1]);
xlim([1, n_harmonics]);
yaxis.TickLabelInterpreter = 'latex';
xlabel('Harmonic Index ($k$)','Interpreter', 'latex');
ylabel('Power ($|X_k|^2$)','Interpreter', 'latex');
title('Power Distribution over Harmonics', 'Interpreter', 'latex');
exportgraphics(f, 'figures/harmonic_power.pdf');