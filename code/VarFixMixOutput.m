function [ avg_return, avg_std, annual_rets ] = VarFixMixOutput(rets, CURRENT_AGE, VAR_TIME, wts, RETIRE_AGE)
new_age     = CURRENT_AGE;
SCENARIOS   = size(rets,1);
NUM_ASSETS  = size(rets,2);
TOTAL_YEARS = size(rets,3);
RETIRE_AGE  = 100;

opt_ret          = zeros(TOTAL_YEARS,1);
opt_std          = zeros(TOTAL_YEARS,1);
annual_rets      = zeros(TOTAL_YEARS,SCENARIOS);
avg_scenario_ret = zeros(NUM_ASSETS,1);
avg_scenario_var = zeros(NUM_ASSETS,1);

i = 1;
j = 1;
while new_age < RETIRE_AGE


  [avg_return, avg_std, yearly_returns] = VarFixMix(rets, CURRENT_AGE, new_age, VAR_TIME, wts(:,j)');
  
  endtt                           = min(65,(i+VAR_TIME)-1);
  opt_ret(i:(i+VAR_TIME))         = avg_return;
  opt_std(i:(i+VAR_TIME))         = avg_std;
  annual_rets(i:endtt,:)          = yearly_returns;
    
    
  new_age  = new_age + VAR_TIME;
  i        = i + VAR_TIME;
  j        = j + 1;
end

for i = 1:SCENARIOS
        
    avg_scenario_ret(i) = geomean(yearly_returns(:,i))-1;
    avg_scenario_var(i) = var(yearly_returns(:,i));
    
end

avg_return = (mean(avg_scenario_ret));
avg_std    = sqrt(mean(avg_scenario_var));

end

