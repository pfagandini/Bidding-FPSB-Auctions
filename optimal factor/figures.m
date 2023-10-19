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
a = 2;
b = 0;

% Sophisticated and naive of group 2
c = 0;
d = 0;

parameters = [m1,sd1;m2,sd2;disp1,disp2];

%Figure 1, best response figure
%==============================
display('Figure 1')
parameters_fig=parameters;
[a,b,c,d]=deal(1,0,0,1);

br=[];

for z = 0:0.05:3
  parameters_fig(2,1)=-z;
  result_of = opt_factor_estimator(a,b,c,d,parameters_fig);
  br=[br;z,result_of(1,1)];
end

plot(...
  br(:,1),br(:,1),'k','LineWidth',2.0, ...
  br(:,1),br(:,2),'k:','LineWidth',2.0, ...
  br(:,2),br(:,1),'k--','LineWidth',2.0 ...
  )
legend("45 deg line","Best response Bidder 1","Best response Bidder 2","location","southoutside","orientation","horizontal")
xlabel("Shading other bidder")
ylabel("Optimal Shading")
print('figure1.png')

%Figure 2, Shading Factor decomposition
%======================================
display('Figure 2')
to_plot = [];
of_store = [];
bf_store = [];

for z = 2:1:8
  of_store = [of_store;opt_factor_estimator(z,0,0,0,parameters)(1,1)];
  parameters(2,1) = parameters(2,1)-opt_factor_estimator(z,0,0,0,parameters)(1,1);
  
  bf_store = [bf_store;bias_factor_estimator(1,0,0,z-1,parameters)(1,1)];
  parameters(2,1) = parameters(2,1)+opt_factor_estimator(z,0,0,0,parameters)(1,1);
  
  to_plot = [to_plot;z,of_store(z-1,1),bf_store(z-1,1),of_store(z-1,1)-bf_store(z-1,1)];
end

scatter(to_plot(:,1),to_plot(:,2),'k','LineWidth',1.5,'filled')
hold on
scatter(to_plot(:,1),to_plot(:,3),'k','LineWidth',1.5)
hold on
scatter(to_plot(:,1),to_plot(:,4),'k','LineWidth',1.5,'d')

legend('Shading Factor','Bias Factor','Competitive Factor',"location","southoutside","orientation","horizontal")
xlabel('Number of Bidders')
ylabel('Shading')
axis([0 9]);
print('figure2.png')
hold off

%Figure 3, Valuation Asymmetry
%=============================

display('Figure 3a')
[a,b,c,d]=deal(1,0,1,0);
to_plot=[];

parameters_fig = parameters;

for z = 0:0.1:1
  parameters_fig(2,1)=z;
  to_plot=[to_plot;z,opt_factor_estimator(a,b,c,d,parameters_fig)(1,1),opt_factor_estimator(a,b,c,d,parameters_fig)(1,2)];
end

plot(...
  to_plot(:,1),to_plot(:,2),'k','LineWidth',2.0,...
  to_plot(:,1),to_plot(:,3),'k:','LineWidth',2.0 ...
  )
legend('SF Group I','SF Group II',"location","southoutside","orientation","horizontal")
xlabel('Group II valuation advantage')
ylabel('Shading Factor')
print('figure3a.png')

display('Figure 3b, Figure 3c')
[a,b,c,d]=deal(2,0,2,0);
to_plot=[];

parameters_fig = parameters;

for z = 0:0.1:3
  parameters_fig(2,1)=z;
  to_plot=[to_plot;z,opt_factor_estimator(a,b,c,d,parameters_fig)(1,1),opt_factor_estimator(a,b,c,d,parameters_fig)(1,2)];
end

plot(...
  to_plot(1:11,1),to_plot(1:11,2),'k','LineWidth',2.0,...
  to_plot(1:11,1),to_plot(1:11,3),'k:','LineWidth',2.0 ...
  )
legend('SF Group I','SF Group II',"location","southoutside","orientation","horizontal")
xlabel('Group II valuation advantage')
ylabel('Shading Factor')
print('figure3b.png')

plot(...
  to_plot(:,1),to_plot(:,2),'k','LineWidth',2.0,...
  to_plot(:,1),to_plot(:,3),'k:','LineWidth',2.0 ...
  )
legend('SF Group I','SF Group II',"location","southoutside","orientation","horizontal")
xlabel('Group II valuation advantage')
ylabel('Shading Factor')
print('figure3c.png')

%Figure 4, Information Asymmetry A
%=================================
%For the asymmetry information plots, a trick is necessary to invert the x-axis in Octave
%First, we need to store a "mirror" value for each, that is why instead of saving z for each column
%1.1-z is saved
display('Figure 4a')
[a,b,c,d]=deal(1,0,1,0);
to_plot=[];

parameters_fig = parameters;

for z = 0.3:0.1:1
  parameters_fig(2,2)=z;
  to_plot=[to_plot;z,opt_factor_estimator(a,b,c,d,parameters_fig)(1,1),opt_factor_estimator(a,b,c,d,parameters_fig)(1,2)];
end

plot(...
  to_plot(:,1),to_plot(:,2),'k','LineWidth',2.0,...
  to_plot(:,1),to_plot(:,3),'k:','LineWidth',2.0 ...
  )

set (gca (), "xdir", "reverse")
legend('Shading Group I','Shading Group II',"location","southoutside","orientation","horizontal")
xlabel('Group II standard deviation')
ylabel('Shading')
print('figure4a.png')

display('Figure 4b')

[a,b,c,d]=deal(2,0,1,0);
to_plot=[];

parameters_fig = parameters;

for z = 0.3:0.1:1
  parameters_fig(2,2)=z;
  to_plot=[to_plot;z,opt_factor_estimator(a,b,c,d,parameters_fig)(1,1),opt_factor_estimator(a,b,c,d,parameters_fig)(1,2)];
end

plot(...
  to_plot(:,1),to_plot(:,2),'k','LineWidth',2.0,...
  to_plot(:,1),to_plot(:,3),'k:','LineWidth',2.0 ...
  )

set (gca (), "xdir", "reverse")
legend('Shading Group I','Shading Group II',"location","southoutside","orientation","horizontal")
xlabel('Group II standard deviation')
ylabel('Shading')
print('figure4b.png')

display('Figure 4c')
[a,b,c,d]=deal(1,0,2,0);
to_plot=[];

parameters_fig = parameters;

for z = 0.3:0.1:1
  parameters_fig(2,2)=z;
  to_plot=[to_plot;z,opt_factor_estimator(a,b,c,d,parameters_fig)];%(1,1),opt_factor_estimator(a,b,c,d,parameters_fig)(1,2)];
end

plot(...
  to_plot(:,1),to_plot(:,2),'k','LineWidth',2.0,...
  to_plot(:,1),to_plot(:,3),'k:','LineWidth',2.0 ...
  )
set (gca (), "xdir", "reverse")
legend('Shading Group I','Shading Group II',"location","southoutside","orientation","horizontal")
xlabel('Group II standard deviation')
ylabel('Shading')
print('figure4c.png')

%Figure 5, Information Asymmetry B EXPECTED WINNING PROFITS
%=================================
display('Figure 5')
[a,b,c,d]=deal(1,0,2,0);
to_plot=[];

parameters_fig = parameters;

for z = 0.3:0.1:1
  parameters_fig(2,2)=z;
  sol = opt_factor_estimator(a,b,c,d,parameters_fig);
  parameters_fig(3,1)=sol(1,1);
  parameters_fig(3,2)=sol(1,2);
  to_plot = [to_plot;z,...
    expected_winner(a,b,c,d,parameters_fig)(1,2),...
    expected_winner(a,b,c,d,parameters_fig)(3,2)...
    ];
  parameters_fig = parameters;
end

plot(...
  to_plot(:,1),to_plot(:,2),'k','LineWidth',2.0,...
  to_plot(:,1),to_plot(:,3),'k:','LineWidth',2.0 ...
  )
  
set (gca (), "xdir", "reverse")
legend('Exp. Winning Profits G I','Exp. Winning Profits G II',"location","southoutside","orientation","horizontal")
xlabel('Group II standard deviation')
ylabel('Exp. Winning Profits')
print('figure5.png')

%Figure 6, Naive Bidders
%=======================
display('Figure 6')
parameters_fig_a = parameters;
to_plot_a=[];
to_plot_b=[];

for z = 1:1:6
  opt_sym = opt_factor_estimator(z+1,0,0,0,parameters_fig_a)(1,1);
  bf_sym = bias_factor_estimator(z+1,0,0,0,parameters_fig_a)(1,1);
  to_plot_a=[to_plot_a;z+1,opt_sym];
  parameters_fig_b = parameters_fig_a;
  parameters_fig_b(2,1) = -(opt_sym-bf_sym);
  to_plot_b=[to_plot_b;z+1,opt_factor_estimator(z,0,0,1,parameters_fig_b)(1,1)];
end
 
scatter(to_plot_a(:,1),to_plot_a(:,2),'k','LineWidth',1.5)
hold on
scatter(to_plot_b(:,1),to_plot_b(:,2),'k','LineWidth',1.5,'filled')
  
legend('All rational','One naive',"location","southoutside","orientation","horizontal")
xlabel('Number of competitors')
ylabel('Shading Factor')
axis([0 8 1.3 2]);
print('figure6.png')
hold off

%Figure 7, Naive Bidders on Bias Factor
%======================================
display('Figure 7')
parameters_fig = parameters;
to_plot_a=[];
to_plot_b=[];

for z = 1:1:5
  [a,b,c,d]=deal(1,0,z,0);
  to_plot_a=[to_plot_a;z,bias_factor_estimator(a,b,c,d,parameters_fig)(1,1)];
  [a,b,c,d]=deal(1,z,0,0);
  to_plot_b=[to_plot_b;z,bias_factor_estimator(a,b,c,d,parameters_fig)(1,1)];
end
 
scatter(to_plot_a(:,1),to_plot_a(:,2),'k','LineWidth',1.5)
hold on
scatter(to_plot_b(:,1),to_plot_b(:,2),'k','LineWidth',1.5,'filled')

axis([0 6])
legend('All rational','One rational',"location","southoutside","orientation","horizontal")
xlabel('Number of competitors')
ylabel('Bias Factor')
print('figure7.png')
hold off