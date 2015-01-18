function [c, ceq] = confun(x,covar,risk)
  
c = [];
ceq(1)= sqrt(x*covar*x')-risk;
