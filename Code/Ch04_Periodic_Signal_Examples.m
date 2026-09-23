% (C) Rahul Bhadani
%% Staircase repeat

u = @(t) heaviside(t);
T_0 = 4;
x1 = @(t) 4.*u(t) - 4.*u(t-1) + ...
    3.*u(t-1) - 3.*u(t-2) + ...
    2.*u(t-2) - 2.*u(t-3) + ...
    u(t-3) - u(t-4);

% Six Periods from K = -3 to K = 3
K = 3;
t = -10*K:0.0001:10*K;
x = zeros(size(t));

for k = -K:K
x = x + x1(t-T_0.*k);
end
f = figure(1);
f.Position(3:4) = [1000, 400];
plot(t, x, 'LineStyle','-', 'LineWidth',2, 'Color','#879223');
grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
xlabel('Time','Interpreter', 'latex');
set(gca, 'FontSize', 15);
ylim([-1, 8]);
xlim([-8.1, 8.1]);
xlabel('Time, t', 'Interpreter','latex');
ylabel('x(t)', 'Interpreter','latex');
exportgraphics(f, 'figures/Ch04_Staircase_Signal.png', 'BackgroundColor', 'none');


%%

u = @(t) heaviside(t);

stair = @(t) 4.*u(t) - 4.*u(t-1) + ...
    2.*u(t-1) - 2.*u(t-2);

t = -1:0.0001:10;
x = stair(t);

f = figure(1);
f.Position(3:4) = [1000, 400];
plot(t, x, 'LineStyle','-', 'LineWidth',2, 'Color','#879223');
grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
xlabel('Time','Interpreter', 'latex');
set(gca, 'FontSize', 18);
ylim([-1, 5]);
xlim([-1, 3]);
xlabel('Time, t', 'Interpreter','latex');
ylabel('x(t)', 'Interpreter','latex');
exportgraphics(f, 'figures/Ch04_MiniStaircase_Signal.pdf', 'BackgroundColor', 'none');

%%
u = @(t) heaviside(t);
r = @(t) max(0, t);
tau = 3.0;
doubletriangle = @(t) (t./tau).*( u(t) - u(t-tau));


t = -6.5:0.0001:6.5;
x = doubletriangle(t) + doubletriangle(-t);

f = figure(1);
f.Position(3:4) = [1000, 400];
plot(t, x, 'LineStyle','-', 'LineWidth',2, 'Color','#879223');
grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
xlabel('Time','Interpreter', 'latex');
set(gca, 'FontSize', 18);
ylim([-1, 2]);
xlim([-4, 4]);
xlabel('Time, t', 'Interpreter','latex');
ylabel('f(t)', 'Interpreter','latex');
xticks([-tau, 0, tau]);
xticklabels({'$-\tau$', '$0$', '$\tau$'});
exportgraphics(f, 'figures/Ch04_DoubleTriangle_Signal.pdf', 'BackgroundColor', 'none');

%%
w_0 = 5.0;
u = @(t) heaviside(t);
FT = @(w) (w.*w).*(u(w) - u(w - w_0));

w = -12:0.0001:12;
doublesemiparabola = FT(w) + FT(-w);
f = figure(1);
f.Position(3:4) = [1000, 400];
plot(w, doublesemiparabola, 'LineStyle','-', 'LineWidth',2, 'Color','#879223');
grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
set(gca, 'FontSize', 18);
ylim([-1, 45]);
xlim([-11, 11]);
xlabel('Frequency, $\Omega$', 'Interpreter','latex');
ylabel('F($\Omega$)', 'Interpreter','latex');
xticks([-w_0, 0, w_0]);
xticklabels({'$-\Omega_0$', '$0$', '$\Omega_0$'});
text(2, 15, '\Omega^2', 'FontSize',24)
exportgraphics(f, 'figures/Ch04_DoubleParabola_Signal.pdf', 'BackgroundColor', 'none');


