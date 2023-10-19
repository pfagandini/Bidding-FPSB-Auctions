======
README
======
These files allow for 4 types of bidders. Sophisticated and naive with one
normal distribution, and sophisticated and naive with another normal
distribution.

There are main files. 'figures.m' replicates all the figures included in
the paper.

On the other hand 'run.m' is useful to run a single simulation, for a particular
case.

'bias_factor_estimator.m' accepts the parameters of the environment (number of
bidders that belong to each group, moments of their distributions) and delivers
the bias factor correction for the sophisticated bidders with each distribution,
result is delivered as an horizontal vector [bf1 bf2]. Note that correction
is equivalent to bias factor times the standard deviation. Both coincide in the
case of the standard deviation equal to 1. The same applies to the file
'opt_factor_estimator.m', but for the optimal shading.

'derivative.m' contains the function of the first order condition, i.e. the
derivative of the expected profits with respect to the shading.

'expected_winner.m' delivers a matrix with the number of bidders with each set
of characteristics, their expected winning profits, and the probability of
winning. Each value on a different column for each set of bidders.
