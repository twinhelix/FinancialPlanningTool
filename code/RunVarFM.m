%% Financial Risk Management - Final Project
% Lu Xin, Edward Stivers     - Jan 19, 2015 
clc; clear all;
load('ftp_scenario');

%% Get best Variable Fixed Mix
% Get returns of years from present until retirement 
VAR_TIME = 10;

[Var_wts, Var_ret] = OptimalVarFixedMixWts(rets, Age, RETIRE_AGE, ...
    VAR_TIME,cov_ret, TARGET_RISK);
[ Var_avg_ret, Var_avg_std, Var_yearly_returns ] = VarFixMixOutput(rets, ...
    Age, VAR_TIME, Var_wts, RETIRE_AGE);

Var_avg_ret
Var_avg_std
Var_SR = Var_avg_ret/Var_avg_std
Var_DD = mean(maxDD(Var_yearly_returns))
%% Simulate Variable FM Standard Pension Plan - Invest in CASH after Retirement
[VarFM_PensionPortfolio ]= ...
PensionPlanSimulator(NAME, RETIRE_AGE, MIN_DEATH_AGE, Var_yearly_returns, ...
CASH_RETS, lower_target_vector);

PortSaving = VarFM_PensionPortfolio(1:RETIRE_AGE-Age+1,:);
Returns    = diff(PortSaving)./PortSaving(1:end-1,:);
MaxDD      = mean(maxDD(Returns+1))


%% Surf Standard Pension Plan Paths
[~, sort_ind] = sort(VarFM_PensionPortfolio(end,:));
figure
X_AXIS = 1:size(VarFM_PensionPortfolio,2);
Y_AXIS = (1:size(VarFM_PensionPortfolio,1)) + Age - 1;
[X Y] = meshgrid(X_AXIS, Y_AXIS);
surf(X,Y,VarFM_PensionPortfolio(:,sort_ind));
title('Standard VarFM Retirement - Scenario Paths');
xlabel('Scenarios');
ylabel('Age');
zlabel('Portfolio Value');


%% NEXT POLICY: 

%% Simulate Variable FM Prudent Pension Plan - Invest in Bonds After FR = 1.05
[PensionPortfolioPrudent ]= ...
PrudentPensionPlanSimulator(NAME, RETIRE_AGE, MIN_DEATH_AGE, Var_yearly_returns, ...
BOND_RETS,lower_target_vector);

PrudentPortSaving = PensionPortfolioPrudent(1:RETIRE_AGE-Age+1,:);
PrudentReturns    = diff(PrudentPortSaving)./PrudentPortSaving(1:end-1,:);
PrudentMaxDD      = mean(maxDD(PrudentReturns+1))

%% Surf Prudent Pension Plan Paths
[~, sort_ind] = sort(PensionPortfolioPrudent(end,:));
figure
X_AXIS = 1:size(PensionPortfolioPrudent,2);
Y_AXIS = (1:size(PensionPortfolioPrudent,1)) + Age - 1;
[X, Y] = meshgrid(X_AXIS, Y_AXIS);
surf(X,Y,PensionPortfolioPrudent(:,sort_ind));
title('Prudent Retirement - Scenario Paths');
xlabel('Scenarios');
ylabel('Age');
zlabel('Portfolio Value');