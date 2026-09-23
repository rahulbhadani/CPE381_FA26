Sn = @(a, r, n) (a.*(r.^n - 1))./(r-1);
a = 2.0;
r = 1.0/3.0;
% Varies n from 1 to 100 spaced by 1
N = 1:1:100;
SUM = zeros(1, length(N));
for i = 1:length(N)
    SUM(i) = Sn(a, r, N(i));
    SUM(i)
end
f = figure;
plot(N, SUM, 'LineWidth',2, 'Color','#432423');
grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
set(gca, 'FontSize', 18);
xlabel('n','Interpreter', 'latex');
ylabel('$S_n$','Interpreter', 'latex');
ylim([1.9, 3.1])
exportgraphics(f, 'figures/HW01_Geometric_Progression.pdf', 'BackgroundColor', 'none');
