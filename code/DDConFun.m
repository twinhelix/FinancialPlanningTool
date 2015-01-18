function [c,ceq] = DDConFun( weights , cov, targ, rets, targetDD )
PortfolioRisk    = @(weights,cov) (weights*cov*weights');
dd               = DrawDown(weights, rets);
maxDD            = mean(max(dd));

ceq = weights(1)+weights(2)+weights(4)-1;

c   = [weights(3)-.5;
    -weights(1);
    -weights(2);
    -weights(3);
    -weights(4);
    sqrt(weights*cov*weights')-targ;
    (maxDD - targetDD)];


end

