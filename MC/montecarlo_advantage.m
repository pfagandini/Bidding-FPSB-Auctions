clear all
pkg load statistics
max_recursion_depth(1024,"local")

sample = 5*10^2;
N = 10^5;
  
m1 = 0; % mean bidder 1
m2 = 1; % mean bidder 2
m3 = 0; % mean bidder 3
m4 = 0; % mean bidder 4

sd1 = 1; % stdev bidder 1
sd2 = 1; % stdev bidder 2
sd3 = 1; % stdev bidder 3
sd4 = 1; % stdev bidder 4

% Switch on or off each bidder, always
% leave last group of bidders at last (avoid 
% having bidder 1, 2, and 4, just have
% bidder 1, 2, and 3.

bidder3 = 0; % 1 is on, 0 is off
bidder4 = 0; % 1 is on, 0 is off

result_1 = [] ; %opti_bidder_1
result_2 = [] ; %opti_bidder_2
result_3 = [] ; %opti_bidder_3
result_4 = [] ; %opti_bidder_4

estimates1 = []; %estimates of bidder 1
estimates2 = []; %estimates of bidder 2
estimates3 = []; %estimates of bidder 3
estimates4 = []; %estimates of bidder 4

for i = 1:sample

  of1 = 0 ; %of_bidder_1
  of2 = 0 ; %of_bidder_2
  of3 = 0 ; %of_bidder_3
  of4 = 0 ; %of_bidder_3
  
  old_of1 = 1;
  old_of2 = 1;
  old_of3 = 1;
  old_of4 = 1;
  
  estimates1 = norminv(rand(N,1),m1,sd1);
  estimates2 = norminv(rand(N,1),m2,sd2);
  if bidder3 == 1 estimates3 = norminv(rand(N,1),m3,sd3); end
  if bidder4 == 1 estimates4 = norminv(rand(N,1),m4,sd4); end
  
  estimates = [estimates1, estimates2, estimates3, estimates4];
  
  counter = 0;
  
  while max([abs(of1-old_of1),abs(of2-old_of2),abs(of3-old_of3),abs(of4-old_of4)])>0.01 && counter < 50
  
    counter++;
  
    old_of1 = of1;
    old_of2 = of2;
    old_of3 = of3;
    old_of4 = of4;
  
    % est1 represent bids of the others
    est1 = estimates;
    est1(:,2) = est1(:,2) - ones(size(est1(:,2)))*of2;
    if bidder3 == 1 est1(:,3) = est1(:,3) - ones(size(est1(:,3)))*of3; end
    if bidder4 == 1 est1(:,4) = est1(:,4) - ones(size(est1(:,4)))*of4; end
    
    est2 = estimates;
    est2(:,1) = est2(:,1) - ones(size(est2(:,1)))*of1;
    if bidder3 == 1 est2(:,3) = est2(:,3) - ones(size(est2(:,3)))*of3; end
    if bidder4 == 1 est2(:,4) = est2(:,4) - ones(size(est2(:,4)))*of4; end
    
    if bidder3 == 1 
      est3 = estimates;
      est3(:,1) = est3(:,1) - ones(size(est3(:,1)))*of1;
      est3(:,2) = est3(:,2) - ones(size(est3(:,2)))*of2;
      if bidder4 == 1 est3(:,4) = est3(:,4) - ones(size(est3(:,4)))*of4; end
    end

    if bidder4 == 1   
      est4 = estimates;
      est4(:,1) = est4(:,1) - ones(size(est4(:,1)))*of1;
      est4(:,2) = est4(:,2) - ones(size(est4(:,2)))*of2;
      est4(:,3) = est4(:,3) - ones(size(est4(:,3)))*of3;
    end
  
    of1 = sf(estimates , est1 , 0.01 , 0 , 4 , 1);
    of2 = sf(estimates , est2 , 0.01 , 0 , 4 , 2);
    if bidder3 == 1 of3 = sf(estimates , est3 , 0.01 , 0 , 4 , 3); end
    if bidder4 == 1 of4 = sf(estimates , est4 , 0.01 , 0 , 4 , 4); end
    
  end
  
  result_1 = [result_1;of1];
  result_2 = [result_2;of2];
  if bidder3 == 1 result_3 = [result_3;of3]; end
  if bidder4 == 1 result_4 = [result_4;of4]; end
  
end

figure
result_1(result_1 == 0) = NaN;
hist(result_1,20)
xlabel('Shading Factor Bidder 1')
perc_nan_b1 = sum(isnan(result_1))/sample
sf1 = mean(result_1)
print('bidder1.png')

figure
result_2(result_2 == 0) = NaN;
hist(result_2,20)
xlabel('Shading Factor Bidder 2')
perc_nan_b2 = sum(isnan(result_2))/sample
sf2 = mean(result_2)
print('bidder2.png')

if bidder3 == 1 
  figure
  result_3(result_3 == 0) = NaN;
  hist(result_3,20)
  xlabel('Shading Factor Bidder 3')
  perc_nan_b3 = sum(isnan(result_3))/sample
  sf3 = mean(result_3)
  print('bidder3.png')
end

if bidder4 == 1 
  figure
  result_4(result_4 == 0) = NaN;
  hist(result_4,20)
  xlabel('Shading Factor Bidder 4')
  perc_nan_b4 = sum(isnan(result_4))/sample
  sf4 = mean(result_4)
  print('bidder4.png')
end