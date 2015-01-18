function [ drawdowns ] = DrawDown( w, rets )
SCENARIOS   = size(rets,1);
NUM_ASSETS  = size(rets,2);
TOTAL_YEARS = size(rets,3);

drawdowns   = zeros(TOTAL_YEARS,SCENARIOS); 

for i = 1:SCENARIOS
    
port_ret = w * reshape(rets(1,:,:),NUM_ASSETS,TOTAL_YEARS) + 1;
cum_ret  = cumprod(port_ret);

% Calculate difference with the max point
dd = @(index) ((max(cum_ret(1:index)) - cum_ret(index))...
    /max(cum_ret(1:index))); 

drawdowns(:,i) = arrayfun (dd, 1:length(cum_ret));

end

end

