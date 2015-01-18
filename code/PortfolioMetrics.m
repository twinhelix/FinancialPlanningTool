function [ avg_return avg_variance ] = PortfolioMetrics(  )


avg_return = mean(scenario_rets);
avg_var = mean(var(scenario_rets));
end

