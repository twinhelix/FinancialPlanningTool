function [ portfolio ] = PensionPort( initial_value, salaries, contribution, returns, ...
    age)
portfolio = zeros(size(returns,1), size(returns,2));

% Set initial value
portfolio(1,:) = initial_value .* returns(1,:);

for i = (age+1):100
    index_now = i - age + 1;
    
    
    portfolio(index_now,:) = portfolio(index_now-1,:) ...
        + salaries(index_now-1) * contribution;
    
    portfolio(index_now,:) = portfolio(index_now,:) .* returns(index_now,:);   
end
end

