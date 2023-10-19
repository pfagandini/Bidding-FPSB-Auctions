% This script helps to try the model

%Moments of group 1
m1 = 0;
sd1 = 1;
disp1 = 0; %pre applied displacement, leave at 0

%Moments of group 2
m2 = 0;
sd2 = 1;
disp2 = 0; %pre applied displacement, leave at 0

% Sophisticated and naive of group 1
a = 8;
b = 0;

% Sophisticated and naive of group 2
c = 0;
d = 0;

parameters = [m1,sd1;m2,sd2;disp1,disp2];

display('Bias Factor G1 - Bias Factor G2')
bias_factors = bias_factor_estimator(a,b,c,d,parameters)

output_precision(5)

display('Shading Factor G1 - Shading Factor G2')
result_of = opt_factor_estimator(a,b,c,d,parameters)
parameters = [m1,sd1;m2,sd2;result_of(1,1),result_of(1,2)];
display('Num. Bidders - Exp Winning Bid - Prob winning')
result_stats = expected_winner(a,b,c,d,parameters)
display('Exp. winning profits - Exp Profits')
exp_profits = [...
   result_stats(1,2)*(a>0),result_stats(1,2)*(a>0)*result_stats(1,3);...
   result_stats(2,2)*(b>0),result_stats(2,2)*(b>0)*result_stats(2,3);...
   result_stats(3,2)*(c>0),result_stats(3,2)*(c>0)*result_stats(3,3);...
   result_stats(4,2)*(d>0),result_stats(4,2)*(d>0)*result_stats(4,3)
  ]