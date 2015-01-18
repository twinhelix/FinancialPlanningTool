function [ c,ceq ] = ConfunFixedMix( weights , cov, targ)

ceq = weights(1)+weights(2)+weights(4)-1;

c   = [weights(3)-.5;
    -weights(1);
    -weights(2);
    -weights(3);
    -weights(4);
    sqrt(weights*cov*weights')-targ];


end

