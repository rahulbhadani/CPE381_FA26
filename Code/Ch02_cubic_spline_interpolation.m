function [x_interp, coefficients] = Ch02_cubic_spline_interpolation(t_data, x_data, t_interp, boundary_type, varargin)

% (C) Rahul Bhadani

% CUBIC_SPLINE_INTERPOLATION - Implementation of cubic spline interpolation from scratch
%
% INPUTS:
%   t_data - Original time points (column vector)
%   x_data - Original signal values (column vector)
%   t_interp - New time points for interpolation (column vector)
%   boundary_type - 'clamped' or 'free'
%   varargin - For clamped: [p, q] where p = derivative at first point, q = derivative at last point
%
% OUTPUTS:
%   x_interp - Interpolated signal values
%   coefficients - Structure containing spline coefficients (a, b, c, d)


% Convert to column vectors if already not
t_data = t_data(:);
x_data = x_data(:);
t_interp = t_interp(:);

n = length(t_data) - 1; % Number of spline segments

% Cubic splines are P_i(t) = a_i(t - t_i)^3 + b_i(t - t_i)^2 + c_i(t - t_i)
% + d_i

% Calculate h, spacing between time points
h = diff(t_data);

% d coefficients are easy
d = x_data;


% Now we need to solve for b_i
if strcmp(boundary_type, 'free')
    % b_1 = 0, b_{n+1} = 0

    % Setting up for solving  $b_{i-1}h_{i-1} + 2b_i (h_i + h_{i-1}) 
    % + b_{i+1}h_i = \frac{3(d_{i+1} - d_i)}{h_i} - 
    % \frac{3(d_{i} - d_{i-1})}{h_{i-1}}$, $ i = 2, 3, \cdots n$

    B = zeros(n-1, n-1);
    RHS = zeros(n-1, 1);

    for i = 2:n
        % Row i-1 in matrix corresponds to equation for b_i
        row = i - 1;

        % Coefficient of b_{i-1}
        if i > 2
            B(row, row-1) = h(i-1);
        end
        % Coefficient of b_i (diagonal)
        B(row, row) = 2*(h(i) + h(i-1));

        % Coefficient of b_{i+1}
        if i < n
            B(row, row+1) = h(i);
        end

        % Right hand side
        RHS(row) = 3*((d(i+1) - d(i))/h(i) - (d(i) - d(i-1))/h(i-1));

    end

    % Solve for B values
    b_interior = B \ RHS;

    % full b vector
    b = [0; b_interior; 0]; % b_1 = 0, b_{n+1} = 0

elseif strcmp(boundary_type, 'clamped')
    % Clamped boundary conditions
    if length(varargin) < 1 || length(varargin{1}) < 2
        error('For clamped boundary conditions, provide [p, q] as additional argument');
    end
    p = varargin{1}(1); % First derivative at t_1
    q = varargin{1}(2); % First derivative at t_{n+1}

    % Set up system for all b values (b_1 to b_{n+1})

    B = zeros(n+1, n+1);
    RHS = zeros(n+1, 1);

    % First equation: (2*b_1 + b_2)*h_1 = 3*(d_2 - d_1)/h_1 - 3*p
    B(1, 1) = 2*h(1);
    B(1, 2) = h(1);
    RHS(1) = 3*(d(2) - d(1))/h(1) - 3*p;

    % Interior equations: i = 2 to n
    for i = 2:n
        row = i;
        B(row, i-1) = h(i-1);           % b_{i-1}
        B(row, i) = 2*(h(i) + h(i-1));  % b_i
        B(row, i+1) = h(i);             % b_{i+1}
        RHS(row) = 3*((d(i+1) - d(i))/h(i) - (d(i) - d(i-1))/h(i-1));
    end

    % Last equation: (2*b_{n+1} + b_n)*h_n = -3*(d_{n+1} - d_n)/h_n + 3*q
    B(n+1, n) = h(n);
    B(n+1, n+1) = 2*h(n);
    RHS(n+1) = -3*(d(n+1) - d(n))/h(n) + 3*q;
    
    disp(RHS)
    % Solve for all b values
    b = B \ RHS;

else
    error('boundary_type must be either ''free'' or ''clamped''');
end

% Calculate c coefficients
c = zeros(n+1, 1);
for i = 1:n
    c(i) = (d(i+1) - d(i))/h(i) - (1/3)*(2*b(i) + b(i+1))*h(i);
end

if strcmp(boundary_type, 'clamped')
    c(n+1) = q; % Given boundary condition
else
    c(n+1) = c(n) + (b(n) + b(n+1))*h(n); % From continuity
end

% Calculate a coefficients
a = zeros(n, 1);
for i = 1:n
    a(i) = (b(i+1) - b(i))/(3*h(i));
end

x_interp = zeros(size(t_interp));

for k = 1:length(t_interp)
    t_val = t_interp(k);

    % now we need to find the spline segment this particular point belongs

    if t_val < t_data(1) || t_val > t_data(end)
        warning('Interpolation point %.3f is outside data range [%.3f, %.3f]', ...
                t_val, t_data(1), t_data(end));
    end

    i = find(t_data <= t_val, 1, 'last');
    if i == length(t_data)
        i = i - 1; % Handle the case where t_val equals the last data point
    end

    i = max(1, min(i, n)); % here, make sure i is within valid range

    % Let's calculate the interpolated value
    dt = t_val - t_data(i);
    x_interp(k) = a(i)*dt^3 + b(i)*dt^2 + c(i)*dt + d(i);

end

% Return the coefficients
coefficients.a = a;
coefficients.b = b;
coefficients.c = c;
coefficients.d = d;
coefficients.h = h;
coefficients.t_data = t_data;
coefficients.t_interp = t_interp;

end


