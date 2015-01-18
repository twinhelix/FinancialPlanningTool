function [ var_opt_wts, var_opt_ret ] = OptimalVarFixedMixWts(rets, CURRENT_AGE, RETIRE_AGE, VAR_TIME, cov_ret, target_risk)
new_age     = CURRENT_AGE;
SCENARIOS   = size(rets,1);
NUM_ASSETS  = size(rets,2);
TOTAL_YEARS = size(rets,3);
INIT_W      = [0.8 0 0.2 0];
RETIRE_AGE = 100;
var_opt_wts  =  zeros(NUM_ASSETS,ceil((RETIRE_AGE-CURRENT_AGE)/10));
var_opt_ret  =  zeros(1,ceil((RETIRE_AGE-CURRENT_AGE)/10));

function [ r ] = FM_Returns( w )
   [r, s , ~] = VarFixMix(rets, CURRENT_AGE, new_age, VAR_TIME, w);
   
end

function [ c, ceq ] = ConfunFixedMixWrap( w )
   [c, ceq] = ConfunFixedMix(w, cov_ret, target_risk);
end

i = 1;

while new_age < RETIRE_AGE
    op = optimset('MaxFunEvals',100000, 'MaxIter', 100000, ...
        'TolX', 0.001,'Display', 'off');
    
    [opt_wts, opt_ret] = fmincon(@(w) (-FM_Returns(w)),...
        INIT_W,[],[],[],[],[],[],@(w) (ConfunFixedMixWrap(w)),op); 
    INIT_W = opt_wts;
    var_opt_wts(:,i) = opt_wts;
    var_opt_ret(i)   = opt_ret;
    
    new_age  = new_age + VAR_TIME;
    i       = i + 1;
end

end