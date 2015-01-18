function [ opt_w, opt_ret ] = OptimalDDWts( rets, cov, targ, targetDD )

SCENARIOS   = size(rets,1);
TOTAL_YEARS = size(rets,3);
INIT_W      = [.5 .5 .5 0];

function [ r ] = FM_Returns( w )
   [r, s , ~] = FixedMix(rets,w);
   %returns = r/s;
end

function [ c, ceq ] = ConfunFixedMixWrap( w )
   [c, ceq] = DDConFun( w , cov, targ, rets, targetDD );
end

 op = optimset('MaxFunEvals',100000, 'MaxIter', 100000, ...
        'TolX', 0.001,'Display', 'off');
[opt_w, opt_ret] = fmincon(@(w) (-FM_Returns(w)),...
    INIT_W,[],[],[],[],[],[],@(w) (ConfunFixedMixWrap(w)),op);


maxDD   = mean(max(DrawDown(opt_w,rets)))
end


