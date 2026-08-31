% (C) Rahul Bhadani
% 2x' + x(t) = e^{-t}, x(0) = 1/2, 0<=t<=1
% x_exact(t) = 3/2 e^{-t/2} -e^{-t}

% Rearranging x' = (1/2)*(e^{-t} - x(t))

h = 0.1;
t = 0:h:1;
x0 = 1/2;
f = @(t,x) ((exp(-t)-x)/2);
xEuler = Ch02_EulerODE(f, t, x0);

% Exact solution
x_Exact = dsolve('2*Dx + x = exp(-t)', 'x(0) = 1/2', 't');
% Convert for evaluation purposes
x_Exact = matlabFunction(x_Exact);


for k = 1:length(t)
    t_coord = t(k);
    xE = xEuler(k);
    xEx = x_Exact(t(k));
    fprintf('%6.2f %11.6f %11.6f\n',t_coord,xE,xEx)
end

f= figure;
f.Position = [ 810         819        1320         419];
hold on;
plot(t, xEuler, 'LineWidth',2, ...
    'DisplayName','Euler ODE Solution', ...
    'Marker','o',...
    'Color', '#336E99');
plot(t, x_Exact(t), 'LineWidth',2, ...
    'DisplayName','Exact Solution', ...
    'Marker','o',...
    'Color', '#AA41E0');
grid on;
grid minor;
set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
xaxis = get(gca, 'XAxis');
xaxis.TickLabelInterpreter = 'latex';
yaxis = get(gca, 'YAxis');
yaxis.TickLabelInterpreter = 'latex';
title('Solving ODE', 'Interpreter','latex');
set(gca, 'FontSize', 18);
legend('Interpreter','latex');
xlabel('Time (s), $t$','Interpreter', 'latex');
ylabel('ODE Solution','Interpreter', 'latex');

exportgraphics(f, 'figures/Ch02_demo_EulerODE.pdf', 'BackgroundColor', 'none');

