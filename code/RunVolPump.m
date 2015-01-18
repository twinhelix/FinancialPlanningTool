%% Financial Risk Management - Final Project
% Lu Xin, Edward Stivers     - Jan 19, 2015 
clc; clear all;
load('ftp_scenario');

%% Vol Pump Strategy
% Get returns of years from present until retirement
% Pump values must divide cleanly into 60

% USE WEIGHTS FROM BEST FM
[w, ~] =OptimalFixedMixWts( rets(:,:,WORKING_AGE_INDEX),...
    cov_ret,TARGET_RISK);

PUMP   = [.01, .02, .05, .10,.15];
THRESH = .10:.05:.30;
Record = zeros(length(PUMP)*length(THRESH),5);
for i = 1:length(PUMP)
    for j = 1:length(THRESH)
        PUMP_AMT  = PUMP(i);
        THRESHOLD = -THRESH(j);
        [Vol_ret, Vol_std, ~] = VolPump(rets , PUMP_AMT, w , THRESHOLD);
        y = 5*i + j - 5;
        Record(y,1) = PUMP_AMT; 
        Record(y,2) = THRESHOLD;
        Record(y,3) = Vol_ret;
        Record(y,4) = Vol_std;
        Record(y,5) = Vol_ret/Vol_std;
    end
end
Record;
[row, col] = find(ismember(Record, max(Record(:,5))));

[Vol_ret, Vol_std, Vol_returns] = VolPump(rets , Record(row,1), w , Record(row,2));
Vol_ret
Vol_std
Vol_SR = Vol_ret/Vol_std
Vol_DD = mean(maxDD(Vol_returns))

%% Simulate Standard Pension Plan - Invest in CASH after Retirement
[PensionPortfolio ]= ...
PensionPlanSimulator(NAME, RETIRE_AGE, MIN_DEATH_AGE, Vol_returns, ...
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
PrudentPensionPlanSimulator(NAME, RETIRE_AGE, MIN_DEATH_AGE, Vol_returns, ...
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

%% 
term_wealth = LongevityFinder(PensionPortfolioPrudent',Sex);

