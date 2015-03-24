% Linear Model
function y = LinearModeler(p,x)
m=p(1);
c=p(2);
y=m*x+c;
