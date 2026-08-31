function Ch02_demo_cubic_spline()
    fprintf('=== Cubic Spline Interpolation Demo ===\n\n');
    
    % Create test data with some curvature
    t_original = [0, 1.01, 2.03, 3.01];
    x_original = [0; 0.5; 2; 1.5];
    
    % Define interpolation points
    t_new = linspace(0, 3.0, 100)';
    
    % Test both boundary conditions
    fprintf('1. Free boundary conditions (natural splines):\n');
    [x_free, coeff_free] = Ch02_cubic_spline_interpolation(t_original, x_original, t_new, 'free');
    
    fprintf('   First few a coefficients: [%.4f, %.4f, %.4f]\n', coeff_free.a(1:3));
    fprintf('   First few b coefficients: [%.4f, %.4f, %.4f]\n', coeff_free.b(1:3));
    
    fprintf('\n2. Clamped boundary conditions (p=0, q=0):\n');
    [x_clamped, coeff_clamped] = Ch02_cubic_spline_interpolation(t_original, x_original, t_new, 'clamped', [0, 0]);
    
    fprintf('   First few a coefficients: [%.4f, %.4f, %.4f]\n', coeff_clamped.a(1:3));
    fprintf('   First few b coefficients: [%.4f, %.4f, %.4f]\n', coeff_clamped.b(1:3));
    
    % Compare with MATLAB's built-in spline function
    x_matlab = spline(t_original, x_original, t_new);
    
    % Plot results
    figure('Position', [100, 100, 1200, 400]);
    
    subplot(1, 3, 1);
    plot(t_original, x_original, 'ko', 'MarkerSize', 8, 'LineWidth', 2);
    hold on;
    plot(t_new, x_free, 'b-', 'LineWidth', 2);
    title('Free Boundary Conditions');
    xlabel('t');
    ylabel('x(t)');
    legend('Original Data', 'Cubic Spline', 'Location', 'best');
    grid on;
    grid minor;
    set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
    xaxis = get(gca, 'XAxis');
    xaxis.TickLabelInterpreter = 'latex';
    yaxis = get(gca, 'YAxis');
    yaxis.TickLabelInterpreter = 'latex';
    set(gca, 'FontSize', 12);
    
    subplot(1, 3, 2);
    plot(t_original, x_original, 'ko', 'MarkerSize', 8, 'LineWidth', 2);
    hold on;
    plot(t_new, x_clamped, 'r-', 'LineWidth', 2);
    title('Clamped Boundary Conditions');
    xlabel('t');
    ylabel('x(t)');
    legend('Original Data', 'Cubic Spline', 'Location', 'best');
    grid on;
    grid minor;
    set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
    xaxis = get(gca, 'XAxis');
    xaxis.TickLabelInterpreter = 'latex';
    yaxis = get(gca, 'YAxis');
    yaxis.TickLabelInterpreter = 'latex';
    set(gca, 'FontSize', 12);
    
    subplot(1, 3, 3);
    plot(t_original, x_original, 'ko', 'MarkerSize', 8, 'LineWidth', 2);
    hold on;
    plot(t_new, x_free, 'b-', 'LineWidth', 2, 'DisplayName', 'Our Free');
    plot(t_new, x_clamped, 'r-', 'LineWidth', 2, 'DisplayName', 'Our Clamped');
    plot(t_new, x_matlab, 'g--', 'LineWidth', 2, 'DisplayName', 'MATLAB spline');
    title('Comparison');
    xlabel('t');
    ylabel('x(t)');
    legend('Original Data', 'Our Free', 'Our Clamped', 'MATLAB spline', 'Location', 'best');
    grid on;
    grid minor;
    set(gca, 'XColor', [0, 0, 0], 'YColor', [0, 0, 0], 'TickDir', 'out');
    xaxis = get(gca, 'XAxis');
    xaxis.TickLabelInterpreter = 'latex';
    yaxis = get(gca, 'YAxis');
    yaxis.TickLabelInterpreter = 'latex';
    set(gca, 'FontSize', 12);
    
    % Calculate and display errors compared to MATLAB's implementation
    error_free = max(abs(x_free - x_matlab));
    error_clamped = max(abs(x_clamped - x_matlab));
    
    fprintf('\nComparison with MATLAB''s spline function:\n');
    fprintf('   Max error (free boundary): %.6f\n', error_free);
    fprintf('   Max error (clamped boundary): %.6f\n', error_clamped);
    
    fprintf('\nNote: MATLAB''s spline uses clamped boundary conditions,\n');
    fprintf('      so the free boundary result will differ slightly.\n');
end