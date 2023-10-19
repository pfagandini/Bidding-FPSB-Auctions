function f = bias_factor_estimator(a,b,c,d,parameters)
% Note that this function returns the bias factor correction, not the bias
% factor per se. The difference is that the bias factor is the correction over
% the standard deviation.

%Parameters is a matrix with mean and sd for:
%GI normal                                            [m1 sd1]
%GII normal                                           [m2 sd2]
%Last row contains displacement of each distribution. [d1 d2]

tolerance = 0.001;

if a + c == 0
    f = [0,0];
else

  truevalue = [parameters(1,1);parameters(2,1)];
  correction = [0,0];

  starting_point = expected_winner(a,b,c,d,parameters);

  i = 0;

  while ((a>0)*abs(truevalue(1,1)-starting_point(1,2))>tolerance) || ((c>0)*abs(truevalue(2,1)-starting_point(3,2))>tolerance)

    if a > 0
        if c > 0
            correction = [fzero(@(x)expected_winner(a,b,c,d,[parameters(1,1),parameters(1,2);parameters(2,1),parameters(2,2);x,parameters(3,2)])(1,2),0), ...
                          fzero(@(x)expected_winner(a,b,c,d,[parameters(1,1),parameters(1,2);parameters(2,1),parameters(2,2);parameters(3,1),x])(3,2),0) ...
                          ];
        else
             correction = [...
                            fzero(@(x)expected_winner(a,b,c,d,[parameters(1,1),parameters(1,2);parameters(2,1),parameters(2,2);x,parameters(3,2)])(1,2),0),...
                            correction(1,2) ...
                          ];
        end
    else
       correction = [...
                      correction(1,2), ...
                      fzero(@(x)expected_winner(a,b,c,d,[parameters(1,1),parameters(1,2);parameters(2,1),parameters(2,2);parameters(3,2),x])(3,2),0) ...
                    ];
    end
    
    parameters(3,1) = correction(1,1);
    parameters(3,2) = correction(1,2);
    starting_point = expected_winner(a,b,c,d,parameters);
    i = i+1;

  end
  
  f = correction;
end