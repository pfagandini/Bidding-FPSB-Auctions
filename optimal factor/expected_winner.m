function f=expected_winner(a,b,c,d,parameters)
  
% THIS FUNCTION FINDS OPTIMAL SHADING

%a,b are competitors type I sophisticated and naive respectively.
%c,d are competitors type II sophisticated and naive respectively.
%Assume four groups.

m1 = parameters(1,1);
m2 = parameters(2,1);
sd1 = parameters(1,2);
sd2 = parameters(2,2);
of1 = parameters(3,1);
of2 = parameters(3,2);

[p1,p2,p1s,p2s] = deal(0,0,0,0);
[win1,win2,win1s,win2s] = deal(0,0,0,0);

if a>0
    f1s=@(x)normpdf(x,0,sd1).*normcdf(m1-of1-(m1-of1)+x,0,sd1).^(a-1)...
                            .*normcdf(m1-of1-(m1-0)+x,0,sd1).^b...
                            .*normcdf(m1-of1-(m2-of2)+x,0,sd2).^c...
                            .*normcdf(m1-of1-(m2-0)+x,0,sd2).^d;
    p1s=quadcc(f1s,-inf,inf); % Probability of winning
    win1s=quadcc(@(x)(of1-x).*f1s(x),-inf,inf)./p1s; %Expected winning profits
end

if b>0
    f1=@(x)normpdf(x,0,sd1).*normcdf(m1-0-(m1-of1)+x,0,sd1).^a...
                           .*normcdf(m1-0-(m1-0)+x,0,sd1).^(b-1)...
                           .*normcdf(m1-0-(m2-of2)+x,0,sd2).^c...
                           .*normcdf(m1-0-(m2-0)+x,0,sd2).^d;
    p1=quadcc(f1,-inf,inf);
    win1=quadcc(@(x)(0-x).*f1(x),-inf,inf)./p1;
end

if c>0
    f2s=@(x)normpdf(x,0,sd2).*normcdf(m2-of2-(m1-of1)+x,0,sd1).^a...
                            .*normcdf(m2-of2-(m1-0)+x,0,sd1).^b...
                            .*normcdf(m2-of2-(m2-of2)+x,0,sd2).^(c-1)...
                            .*normcdf(m2-of2-(m2-0)+x,0,sd2).^d;
    p2s=quadcc(f2s,-inf,inf);
    win2s=quadcc(@(x)(of2-x).*f2s(x),-inf,inf)./p2s;
end

if d>0
    f2=@(x)normpdf(x,0,sd2).*normcdf(m2-0-(m1-of1)+x,0,sd1).^a...
                           .*normcdf(m2-0-(m1-0)+x,0,sd1).^b...
                           .*normcdf(m2-0-(m2-of2)+x,0,sd2).^c...
                           .*normcdf(m2-0-(m2-0)+x,0,sd2).^(d-1);
    p2=quadcc(f2,-inf,inf);
    win2=quadcc(@(x)(0-x).*f2(x),-inf,inf)./p2;
end

f=[...
   a,win1s, p1s;...
   b,win1, p1;...
   c,win2s , p2s;...
   d,win2 , p2...
   ];