%% Discrete Derivative and Sampling Time

f = @(t) 3.*t.*t + 4.*t + 5;
true_diff_f =  @(t) 6.*t + 4;

t1 = 0:1:10;
x1 = f(t1);
t2 = 0:0.5:10;
x2 = f(t2);
t3 = 0:0.05:10;
x3 = f(t3);

y1 = delta_f(t1, x1);
y2 = delta_f(t2, x2);
y3 = delta_f(t3, x3);

y_true = true_diff_f(t3);

f = figure;
plot(t1, y1, 'LineWidth',2, 'Color','#432423', 'DisplayName','\Delta t = 1');
hold on;
plot(t2, y2, 'LineWidth',2, 'Color','#A42368', 'DisplayName','\Delta t = 0.5');
plot(t3, y3, 'LineWidth',2, 'Color','#989233', 'DisplayName','\Delta t = 0.05');
plot(t3, y_true, 'LineWidth',2, 'Color','#F14056', ...
    'LineStyle','--', 'DisplayName','True Derivative');
grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
set(gca, 'FontSize', 18);
xlabel('t','Interpreter', 'latex');
ylabel('Derivative of f','Interpreter', 'latex');
legend('Location', 'northwest');

exportgraphics(f, 'figures/HW01_Discrete_Derivative_Sampling_Time.pdf', 'BackgroundColor', 'none');

function y = delta_f(t, x)
    y = zeros(1, length(t));
    y(1) = 0.0;
    for i = 2:length(t)
        y(i) = (x(i) - x(i-1))./(t(i) - t(i-1));
    end
end