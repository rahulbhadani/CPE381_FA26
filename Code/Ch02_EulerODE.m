function x = Ch02_EulerODE(f,t,x0)
%
% Ch02_EulerODE uses Euler's method to solve a first-order initial-value
% problem in the form x' = f(t,x), x(t0) = x0.
%
% x = Ch02_EulerODE(f,t,x0), where
%
% f is an anonymous function representing f(t,x),
% t is a vector representing the time points,
% x0 is a scalar representing the initial value of x, 
%
% x is the vector of solution estimates at the mesh points.
%
    x = 0*t; % Pre-allocate
    x(1) = x0; h = t(2)-t(1); n = length(t);
    for i = 1:n-1
        x(i+1) = x(i)+h*f(t(i),x(i));
    end


end