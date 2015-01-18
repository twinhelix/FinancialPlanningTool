function [c, ceq] = confun(w, covar, target_risk)
PortfolioRisk    = @(w,cov) (w*cov*w');

% Nonlinear inequality constraints
c   =  [-w'; w(3) - 0.5];

% Nonlinear equality constraints
ceq = [w(1) + w(2) + w(4) - 1 ;
       sqrt(PortfolioRisk(w,covar)) - target_risk];
end