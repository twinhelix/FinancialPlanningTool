function [ DC_normalised_portfolio ] = NonPensionPort( initial_value, salaries, ...
    contribution, returns, age )

portfolio = zeros(size(returns,1), size(returns,2));
TAX           = 0.3;
CAP_GAINS_TAX = 0.1;

REAL_GAINS    = 1 - CAP_GAINS_TAX;
% Set initial value
portfolio(1,:) = initial_value .* (returns(1,:) * REAL_GAINS);

for i = (age+1):100
    index_now = i - age + 1;
    
    portfolio(index_now,:) = portfolio(index_now-1,:) ...
        + salaries(index_now-1) * contribution * (1-TAX);
    
    portfolio(index_now,:) = portfolio(index_now,:) ...
        .* (1+((returns(index_now,:)-1)*REAL_GAINS));
end

DC_normalised_portfolio = portfolio / (1-TAX);

end

