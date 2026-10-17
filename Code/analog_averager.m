function y = analog_averager(t, x, T)
    % ANALOG_AVERAGER Computes analog moving average of a signal
    %
    % Inputs:
    %   t - time vector (column or row vector)
    %   x - signal vector (same size as t)
    %   T - averaging window duration
    %
    % Output:
    %   y - averaged signal vector (same size as x)
    %
    % The function computes: y(t) = (1/T) * integral from (t-T) to t of x(tau) dtau
    
    % Ensure inputs are column vectors
    t = t(:);
    x = x(:);
    
    % Initialize output vector
    y = zeros(size(x));
    
    % For each time point, compute the integral over the window [t-T, t]
    for i = 1:length(t)
        current_time = t(i);
        
        % Find indices where time is in the integration window [current_time-T, current_time]
        window_indices = find(t >= (current_time - T) & t <= current_time);
        
        if length(window_indices) < 2
            % If we don't have enough points in the window, use available data
            y(i) = mean(x(window_indices));
        else
            % Extract time and signal values in the window
            t_window = t(window_indices);
            x_window = x(window_indices);
            
            % Perform numerical integration using trapezoidal rule
            % integral = trapz(t_window, x_window)
            integral_value = trapz(t_window, x_window);
            
            % Compute average: (1/T) * integral
            actual_window_duration = t_window(end) - t_window(1);
            if actual_window_duration > 0
                y(i) = integral_value / T;
            else
                y(i) = x_window(1); % Single point case
            end
        end
    end
end