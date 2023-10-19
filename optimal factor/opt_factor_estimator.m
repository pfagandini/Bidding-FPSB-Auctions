function f = opt_factor_estimator(a,b,c,d,parameters)
% a,b group 1, sophisticated and naive, c,d group 2, sophisticated and naive

%Parameters is a matrix with mean and sd for:
%GI normal                                            [m1 sd1]
%GII normal                                           [m2 sd2]
%Last row contains displacement of each distribution. [d1 d2]

%The algorithm first looks for an optimal shading, and later scales by the
%standard deviation in order to be a scale invariant measure.

st = dbstack;

iterations = 50; %This greater than zero is for the plots of convergence
tolerance = 0.0001; %
of_old = [];
of_new = [];

if (a + c) == 0
    f = [0,0]; %There is no optimal factor if there is no sophisticated bidders
else
  of_old = [2*tolerance,2*tolerance];%so the loop starts
  of_new = [0,0]; 

  desv = [abs(of_old(1,1)-of_new(1,1)) , abs(of_old(1,2)-of_new(1,2))];

  i = 0;

  store = [a,c;of_new]; %this saves the iterations

  while ((a>0)*abs(of_old(1,1)-of_new(1,1))>tolerance) || ((c>0)*abs(of_old(1,2)-of_new(1,2))>tolerance) % || i < iterations
      of_old=of_new;
      parameters(3,1)=of_old(1,1);
      parameters(3,2)=of_old(1,2);
      if a>0
          if c>0

              prof1=@(x)derivative(a,b,c,d,parameters,1,x);
              prof2=@(x)derivative(a,b,c,d,parameters,2,x);
              
              of_new(1,1)=fzero(prof1,0);
              of_new(1,2)=fzero(prof2,0);
              
              if max([abs(of_old(1,1)-of_new(1,1)), abs(of_old(1,2)-of_new(1,2))])>10.*max(desv) %This helps in case of non convergence giving an alternative starting point
                  of_new(1,1)=fzero(prof1,of_old(1,1));
                  of_new(1,2)=fzero(prof2,of_old(1,2));
              endif

          else
              
              prof1=@(x)derivative(a,b,c,d,parameters,1,x);
              
              of_new(1,1)=fzero(prof1,0);
              
              if max([abs(of_old(1,1)-of_new(1,1)), abs(of_old(1,2)-of_new(1,2))])>10.*max(desv)
                  of_new(1,1)=fzero(prof1,of_old(1,1));
              endif

          end
      else
          
          prof2=@(x)derivative(a,b,c,d,parameters,2,x);

          of_new(1,2)=fzero(prof2,0);
          
          if max([abs(of_old(1,1)-of_new(1,1)), abs(of_old(1,2)-of_new(1,2))])>10.*max(desv)
              of_new(1,2)=fzero(prof2,of_old(1,2));
          endif

      end
      i=i+1;
      store = [store;of_new(1,1),of_new(1,2)];
      desv = [abs(of_old(1,1)-of_new(1,1)), abs(of_old(1,2)-of_new(1,2))];
  end

########
# PLOT #
########

      data_length = i + 2
      size(store)
      size([0:i]')
      
      if (a>0 & c>0)
        plot([0:i]',store(2:data_length,1),'k','LineWidth',1.0,[0:i]',store(2:data_length,2),'k:','LineWidth',2.0)
        legend('Group I','Group II')
      else
        if a>0
          plot([0:i]',store(2:data_length,1),'k','LineWidth',1.0)
        elseif c>0
          plot([0:i]',store(2:data_length,2),'k','LineWidth',1.0)
        end
      end
       
      str = sprintf("Iterations for %d sophisticated bidders",a+c);
      title(str);
      
      xlabel("Iterations");
      ylabel("Optimal shading factor");
      fstr = sprintf("sym%d.png",a+c);
      print(fstr);  

    f=of_new;
end