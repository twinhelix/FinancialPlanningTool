%% Financial Risk Management - Final Project
% Lu Xin, Edward Stivers     - Jan 19, 2015 
clc; clear all;
load('ftp_scenario');

%% Max_DD Rule %%
targetMaxDD = .2;
[ DD_opt_w, DD_opt_ret ] = OptimalDDWts( rets, cov_ret, TARGET_RISK, targetMaxDD );

[DD_rbar, DD_vol, DD_Returns] = FixedMix(rets , DD_opt_w);
DD_rbar
DD_vol
DD_SR = DD_rbar/DD_vol
Max_DD = mean(maxDD(DD_Returns))

%% Simulate Standard Pension Plan - Invest in CASH after Retirement
[PensionPortfolio ]= ...
PensionPlanSimulator(NAME, RETIRE_AGE, MIN_DEATH_AGE, DD_Returns, ...
CASH_RETS, lower_target_vector);

PortSaving = PensionPortfolio(1:RETIRE_AGE-Age+1,:);
Returns    = diff(PortSaving)./PortSaving(1:end-1,:);
MaxDD      = mean(maxDD(Returns+1))

%% Surf Standard Pension Plan Paths
[~, sort_ind] = sort(PensionPortfolio(end,:));
figure
X_AXIS = 1:size(PensionPortfolio,2);
Y_AXIS = (1:size(PensionPortfolio,1)) + Age - 1;
[X Y] = meshgrid(X_AXIS, Y_AXIS);
surf(X,Y,PensionPortfolio(:,sort_ind));
title('Standard Bogle Retirement - Scenario Paths');
xlabel('Scenarios');
ylabel('Age');
zlabel('Portfolio Value');


%% NEXT POLICY: 


%% Simulate Prudent Pension Plan - Invest in Bonds After FR = 1.05
[PensionPortfolioPrudent ]= ...
PrudentPensionPlanSimulator(NAME, RETIRE_AGE, MIN_DEATH_AGE, DD_Returns, ...
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
title('Prudent Bogle Retirement - Scenario Paths');
xlabel('Scenarios');
ylabel('Age');
zlabel('Portfolio Value');
