function [ avg_return, avg_std, yearly_returns ] = VarFixMix(rets, CURRENT_AGE, new_age, VAR_TIME, w)
% Fixed Mix over different periods of time
%  eg change fixed mix every n years
startt   = (new_age - CURRENT_AGE +1);
endt     = min((new_age - CURRENT_AGE + VAR_TIME),65);
sub_rets = rets(:,:,(startt:endt));

SCENARIOS   = size(sub_rets,1);
NUM_ASSETS  = size(sub_rets,2);
TOTAL_YEARS = size(sub_rets,3);

avg_scenario_ret = zeros(NUM_ASSETS,1);
avg_scenario_var = zeros(NUM_ASSETS,1);
total_returns    = zeros(TOTAL_YEARS,SCENARIOS);
yearly_returns   = zeros(TOTAL_YEARS,SCENARIOS);

for i = 1:SCENARIOS
    
    scenario_rets    = reshape(sub_rets(i,:,:),NUM_ASSETS,TOTAL_YEARS);
    weighted_returns = scenario_rets' .* repmat(w,TOTAL_YEARS,1);
    
    yearly_returns(:,i) = sum(weighted_returns,2) + 1;
    total_returns(:,i)  = cumprod(yearly_returns(:,i));
        
    avg_scenario_ret(i) = geomean(yearly_returns(:,i))-1;
    avg_scenario_var(i) = var(yearly_returns(:,i));
    
end

avg_return = (mean(avg_scenario_ret));
avg_std    = sqrt(mean(avg_scenario_var));

end


