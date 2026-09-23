%% Area Under Curve
f = @(t) t.^2;
t1 = 0:0.1:5;
t2 = 0:0.5:5;
t3 = 0:1:5;

x1 = f(t1);
x2 = f(t2);
x3 = f(t3);

area_1 = area_under_curve(t1, x1);
area_2 = area_under_curve(t2, x2);
area_3 = area_under_curve(t3, x3);

true_area = 125.0/3.0;

fprintf("Considering time to be between 0 to 5,\n")
fprintf("True area is %f\n", true_area)
fprintf("Area with Delta t = 0.1 is %f\n", area_1)
fprintf("Area with Delta t = 0.5 is %f\n", area_2)
fprintf("Area with Delta t = 1.0 is %f\n", area_3)

fprintf("Area Difference with Delta t = 0.1 is %f\n", true_area - area_1)
fprintf("Area Difference with Delta t = 0.5 is %f\n", true_area- area_2)
fprintf("Area Difference with Delta t = 1.0 is %f\n", true_area - area_3)

function SUM = area_under_curve(t, x)
    SUM = 0.0;
    for i = 1:length(t)-1
        sum = x(i).*( t(i+1) - t(i) );
        SUM = SUM + sum;
    end
end