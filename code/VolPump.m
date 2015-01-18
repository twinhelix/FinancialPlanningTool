function [ avg_return, avg_std, yearly_returns ] = VolPump( rets , PUMP_AMT, w , THRESHOLD )
SCENARIOS   = size(rets,1);
NUM_ASSETS  = size(rets,2);
TOTAL_YEARS = size(rets,3);
%THRESHOLD   = -.3;
%PUMP_AMT    = .05;
%w           = [.7, .3, .5, 0];
BigHit      = zeros(1, SCENARIOS);
HitCounter  = zeros(1, SCENARIOS);
lookup      = .4:(PUMP_AMT):1;
lookup_vect = zeros(length(lookup), 2);
wts_array   = zeros(SCENARIOS,NUM_ASSETS,TOTAL_YEARS);

lookup_vect(:,1) = 1:(-PUMP_AMT):.4;
lookup_vect(:,2) = 1-lookup_vect(:,1);
startt           = (length(lookup_vect)+1)/2;
HitCounter(:)       = startt;
wts_array(1:SCENARIOS,1,1) = w(1);
wts_array(1:SCENARIOS,2,1) = w(2);
wts_array(1:SCENARIOS,3,1) = w(3);
wts_array(1:SCENARIOS,4,1) = w(4);

avg_scenario_ret = zeros(NUM_ASSETS,1);
avg_scenario_var = zeros(NUM_ASSETS,1);

yearly_returns = zeros(TOTAL_YEARS,SCENARIOS);

for i = 1:SCENARIOS
    
    scenario_rets    = reshape(rets(i,:,:),NUM_ASSETS,TOTAL_YEARS);
    for j = 2: TOTAL_YEARS
        
        if scenario_rets(1,j) < THRESHOLD
            
            BigHit(i)     = BigHit(i) + 1;
            HitCounter(i) = min(length(lookup),HitCounter(i) + 1);
            
        elseif scenario_rets(1,j) > -THRESHOLD
            
            HitCounter(i) = max(1,HitCounter(i) - 1);
        
        end
        
        wts_array(i,1,j) = lookup_vect(HitCounter(i),1);
        wts_array(i,2,j) = lookup_vect(HitCounter(i),2);
        wts_array(i,3,j) = w(3);
        wts_array(i,4,j) = w(4);
    end
    
    wtd_ret_array = reshape(wts_array(i,:,:),NUM_ASSETS,TOTAL_YEARS).*scenario_rets;
    yearly_returns(:,i) = sum(wtd_ret_array,1)+1;
    
    avg_scenario_ret(i) = geomean(yearly_returns(:,i))-1;
    avg_scenario_var(i) = var(yearly_returns(:,i));
    
end

avg_return = (mean(avg_scenario_ret));
avg_std    = sqrt(mean(avg_scenario_var));

end

