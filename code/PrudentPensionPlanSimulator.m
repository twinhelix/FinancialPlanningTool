function [ prudent_returns ] = PrudentPensionPlanSimulator( NAME, RETIRE_AGE, ...
    MIN_DEATH_AGE, RETURNS, BOND_RETS, lower_target_vector )

SOCIAL_SEC     = 30000;
PERC_TARGET    = 0.04;
FUND_RATIO_CAP = 1.01;

PLOT_NUM       = 15;
SCENARIOS      = size(RETURNS,2);
% Read in all data for named person
configs = getConfiguration(NAME);
[Age, Sex, Salary, SalaryIncr, MatchingContr,...
    AdditionContr, MaxSalarySaved, DCBal, SavingsBal] = GetValues(configs);

TOTAL_YEARS       = 100-Age;
years             = 0:TOTAL_YEARS;

% Calculate retirement goal
annual_salary = Salary*((1+SalaryIncr).^years);
[target_wealth, Moving_Target, yearly_spending ] = TargetWealth(annual_salary, Age, ...
    RETIRE_AGE, SOCIAL_SEC, PERC_TARGET, MIN_DEATH_AGE, MaxSalarySaved);
target_wealth
lower_target_wealth = target_wealth * 0.85;


RETIREMENT_INDEX = RETIRE_AGE - Age + 1;
Lower_Moving_Target = Moving_Target * 0.85;

% DO OPTIMISATION ON SAVINGS AND DC ALLOCATION
function [c, ceq] = DC_savings_confun(s_w)
    c = [s_w - (MaxSalarySaved - MatchingContr);
        (MaxSalarySaved - AdditionContr - MatchingContr)-s_w];
    ceq = [];
end

function [prob_achieve] = CalcProb(w)
    pw           = MaxSalarySaved - w + MatchingContr;
    DC_port      = PensionPort(DCBal, annual_salary, pw, RETURNS, Age);
    Savings_port = NonPensionPort(SavingsBal, annual_salary, w, RETURNS, Age);
    PENSION_PLAN = DC_port + Savings_port;
    prob_achieve = sum(PENSION_PLAN(RETIREMENT_INDEX,:)>target_wealth)/SCENARIOS;
end

op = optimset('MaxFunEvals',100000, 'MaxIter', 100000, ...
        'TolX', 0.001,'Display', 'off');
    
[opt_sw, ~]=fmincon(@(w) (-CalcProb(w)),...
    0.06,[],[],[],[],[],[],@(w) (DC_savings_confun(w)),op);

opt_pw       = (MaxSalarySaved + MatchingContr) - opt_sw;
DC_port      = PensionPort(DCBal, annual_salary, opt_pw, RETURNS, Age);
Savings_port = NonPensionPort(SavingsBal, annual_salary, opt_sw, RETURNS, Age);
PENSION_PLAN = DC_port + Savings_port;

% HISTOGRAMS
PlotPortHist(DC_port, Age, 'DC ', 'Prudent');
PlotPortHist(Savings_port, Age, 'Savings ', 'Prudent');

figure;
hold on;
hist(PENSION_PLAN(RETIREMENT_INDEX,:),20);
plot([target_wealth target_wealth],get(gca,'ylim'),'r');
title('Prudent Policy - Combined Histogram at 68');
xlabel('Portfolio Value');
hold off;

% SHE CAN LOWER BY 15% IF GOTTEN BIG HITS IN THE STOCK MARKET
adjusted_target_wealth = lower_target_vector * lower_target_wealth + ...
    (1-lower_target_vector) * target_wealth;
prob_achieve = sum(PENSION_PLAN(RETIREMENT_INDEX,:)>target_wealth)/SCENARIOS
prob_achieve_lower = ...
    sum(PENSION_PLAN(RETIREMENT_INDEX,:)>adjusted_target_wealth)/SCENARIOS

% SEE WHEN FUNDING RATIO IS ABOVE 1
TARGET_REACHED = PENSION_PLAN'>repmat(Moving_Target*FUND_RATIO_CAP,SCENARIOS,1);
ages_reached   = zeros(1,SCENARIOS);

for i = 1:SCENARIOS
    reach_index     = find(TARGET_REACHED(i,:) > 0.5,1);
    ages_reached(i) = reach_index+ Age - 1;
    TARGET_REACHED(i,reach_index:end) = 1;
end

EXPECTED_DELAYED_AGE         = mean(ages_reached(ages_reached>RETIRE_AGE))
MEAN_REACH_TARGET_AGE        = mean(ages_reached)
PROB_REACH_TARGET_BEFORE_RET = sum(ages_reached<=RETIRE_AGE)/SCENARIOS

figure;
hold on;
hist(ages_reached,20);
plot([RETIRE_AGE RETIRE_AGE],get(gca,'ylim'),'r');
title('Prudent Policy - Achieving Retirement Age');
xlabel('Age');
hold off;

% IMMUNISED 
immunised_port = ImmunisePolicy(PENSION_PLAN, TARGET_REACHED',...
    BOND_RETS, opt_pw, opt_sw, annual_salary, RETIREMENT_INDEX, yearly_spending);
% CALCULATE 80% CONF INTERVAL
QUANTILE    = 0.1;
Age_lower_Q = quantile(ages_reached,QUANTILE);
Age_upper_Q = quantile(ages_reached,1-QUANTILE);
Age_l_index = ceil(Age_lower_Q-Age+1);
Age_u_index = floor(Age_upper_Q-Age+1);

Plan_lower_Q = quantile(immunised_port(RETIREMENT_INDEX,:),QUANTILE);
Plan_upper_Q = quantile(immunised_port(RETIREMENT_INDEX,:),1-QUANTILE);
figure
hold on;
hline0 = plot(repmat(Age:MIN_DEATH_AGE,1,1)', ...
    immunised_port(1:(MIN_DEATH_AGE-Age+1),1),'k--');
set(hline0, 'color', [0.5 0.5 0.5])
hl = plot(repmat(Age:MIN_DEATH_AGE,PLOT_NUM-1,1)', ...
    immunised_port(1:(MIN_DEATH_AGE-Age+1),2:PLOT_NUM),'k--');
set(hl, 'color', [0.5 0.5 0.5])
hline1 = plot(Age:MIN_DEATH_AGE,Moving_Target(1:length(Age:MIN_DEATH_AGE)),'k-x');
hline2 = plot(Age:MIN_DEATH_AGE,Lower_Moving_Target(1:length(Age:MIN_DEATH_AGE)),'y-x');
hline3 = plot([RETIRE_AGE RETIRE_AGE],get(gca,'ylim'),'b-');
hline4 = plot([Age_lower_Q RETIRE_AGE],[Moving_Target(Age_l_index) Plan_lower_Q],'r-x');
plot([Age_lower_Q RETIRE_AGE],[Moving_Target(Age_l_index) Plan_upper_Q],'r-x');
plot([Age_upper_Q RETIRE_AGE],[Moving_Target(Age_u_index) Plan_lower_Q],'r-x');
plot([Age_upper_Q RETIRE_AGE],[Moving_Target(Age_u_index) Plan_upper_Q],'r-x');
title('Standard Policy: Sample Paths & Retirement Diamond');
xlabel('Age');
ylabel('Portfolio Value');
legend([hline0, hline1,hline2,hline3,hline4],...
    'Scenarios','Target Wealth','Lowered Target','Retirement Age 68',...
    'Policy Diamond','Location','northwest')
hold off;

prudent_returns = immunised_port;
end

