function [ SCENARIO_RETS , cov_ret] = ScenarioGen (data, GivenRets, SAMPLE_SIZE, ...
    SCENARIOS, TOTAL_YEARS)
daily_ret   = data(2:end,:) ./ data(1:end-1,:)-1;

% Generate random date points to calculate covariance
days           = size(data,1);
trading_days   = 252;
starting_days  = zeros(1,SAMPLE_SIZE)-1;
MAX_SAMPLE_DAY = days - 1 - trading_days;

for i = 1:SAMPLE_SIZE
    day = floor(rand * MAX_SAMPLE_DAY) + 1;
    while ismember(day, starting_days)
        day = floor(rand * MAX_SAMPLE_DAY) + 1;
    end    
    starting_days(i) = day;
end


getGeoRet    = @(start) prod(daily_ret(start:(start+trading_days),:)+1)-1;
data_rets    = arrayfun (@(x) getGeoRet(x), starting_days,'UniformOutput',false);
mean_rets    = cell2mat(data_rets');

cor_ret      = corr(mean_rets);
cor_ret(4,4) = 1;

cov_ret      = cov(mean_rets);
cov_ret(4,4) = 0.01^2;

% Cholesky Factorisation - F'*F = cov_ret
F = chol(cov_ret);    

%% Generate 1000 Scenarios
% Col 1 - Normal. Col 2 - Crash
antithetic_scenarios = SCENARIOS/2;

r_bar          = GivenRets;
SCENARIO_RETS  = zeros(SCENARIOS,4,TOTAL_YEARS);

for i = 1:antithetic_scenarios
    WT = randn(4,TOTAL_YEARS);
    SCENARIO_RETS(2*i-1,:,:) = repmat(r_bar',1,TOTAL_YEARS) + F * WT;
    SCENARIO_RETS(2*i,:,:)   = repmat(r_bar',1,TOTAL_YEARS) + F * (-WT);
end

end