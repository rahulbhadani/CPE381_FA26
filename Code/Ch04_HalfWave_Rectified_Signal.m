% Half-wave Rectified Signal

[t, x] = hw_rectified(5, 1);

f = figure;
f.Position(3:4) = [1200, 500];
plot(t, x, 'LineWidth',2, 'DisplayName','Half-wave Rectified Signal')
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
xlabel('Time','Interpreter', 'latex');
%title('Half-wave Rectified Signal', 'Interpreter', 'latex');
legend('Interpreter', 'latex');
set(gca, 'FontSize', 16);
grid on;
grid minor;
ylim([-1.5, 1.5])
exportgraphics(f, 'figures/Ch04_HalfWave_Rectified_Signal.pdf');


function [t,x] = hw_rectified(n_period, T)
% Generate n periods of half-wave rectified sine wave
%
% Inputs:
%   n_period - Number of periods to generate
%   T        - Fundamental Time Period  
% Outputs:
%   t - Time vector
%   x - Half-wave rectified signal

    duration = n_period*T;
    t = 0:0.001:duration;
    sine_wave = sin(2*pi*t./T);
    x = sine_wave.*(sine_wave > 0);

end