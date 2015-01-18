function [ max_dds ] = maxDD( returns )
% Get cumulative returns
max_dds  = zeros(1,size(returns,2));

for i = 1:length(max_dds)
port_ret = returns(:,i);
cum_ret  = cumprod(port_ret);

% Calculate difference with the max point
dd = @(index) ((max(cum_ret(1:index)) - cum_ret(index))...
    /max(cum_ret(1:index))); 

drawdowns = arrayfun (dd, 1:length(cum_ret));
max_dds(i) = max(drawdowns);
end
end

