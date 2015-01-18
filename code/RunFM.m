%% Financial Risk Management - Final Project
% Lu Xin, Edward Stivers     - Jan 19, 2015 
clc; clear all;
load('ftp_scenario');

%% Get best Fixed Mix
% Get returns of years from present until retirement 

[w, ~] =OptimalFixedMixWts( rets(:,:,WORKING_AGE_INDEX),...
    cov_ret,TARGET_RISK);

[FM_rbar, FM_vol, FM_Returns] = FixedMix(rets,w);
FM_rbar
FM_vol
FM_SR = FM_rbar/FM_vol
FM_DD = mean(maxDD(FM_Returns))

%% Simulate FM Standard Pension Plan - Invest in CASH after Retirement
[FM_PensionPortfolio ]= ...
PensionPlanSimulator(NAME, RETIRE_AGE, MIN_DEATH_AGE, FM_Returns, ...
CASH_RETS, lower_target_vector);

PortSaving = FM_PensionPortfolio(1:RETIRE_AGE-Age+1,:);
Returns    = diff(PortSaving)./PortSaving(1:end-1,:);
MaxDD      = mean(maxDD(Returns+1))

%% Surf Standard Pension Plan Paths
[~, sort_ind] = sort(FM_PensionPortfolio(end,:));
figure
X_AXIS = 1:size(FM_PensionPortfolio,2);
Y_AXIS = (1:size(FM_PensionPortfolio,1)) + Age - 1;
[X Y] = meshgrid(X_AXIS, Y_AXIS);
surf(X,Y,FM_PensionPortfolio(:,sort_ind));
title('Standard FM Retirement - Scenario Paths');
xlabel('Scenarios');
ylabel('Age');
zlabel('Portfolio Value');

%% NEXT POLICY: 



%% Simulate FM Prudent Pension Plan - Invest in Bonds After FR = 1.05
[PensionPortfolioPrudent ]= ...
PrudentPensionPlanSimulator(NAME, RETIRE_AGE, MIN_DEATH_AGE, FM_Returns, ...
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
title('Prudent FM Retirement - Scenario Paths');
xlabel('Scenarios');
ylabel('Age');
zlabel('Portfolio Value');
%%
x = LongevityFinder(PensionPortfolioPrudent',Sex);
