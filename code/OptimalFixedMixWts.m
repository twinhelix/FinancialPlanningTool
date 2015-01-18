function [ opt_w, opt_ret ] = OptimalFixedMixWts( rets, cov_ret, target_risk )

SCENARIOS   = size(rets,1);
TOTAL_YEARS = size(rets,3);
INIT_W      = [.5 .5 .5 0];

function [ r ] = FM_Returns( w )
   [r, s , ~] = FixedMix(rets,w);
   %returns = r/s;
end

function [ c, ceq ] = ConfunFixedMixWrap( w )
   [c, ceq] = ConfunFixedMix(w, cov_ret, target_risk);
end

 op = optimset('MaxFunEvals',100000, 'MaxIter', 100000, ...
        'TolX', 0.001,'Display', 'off');
[opt_w, opt_ret] = fmincon(@(w) (-FM_Returns(w)),...
    INIT_W,[],[],[],[],[],[],@(w) (ConfunFixedMixWrap(w)),op);
end


