%% Financial Risk Management - Final Project
% Lu Xin, Edward Stivers     - Jan 19, 2015 
clc; clear all;
% SETTINGS
SCENARIOS     = 1000;

RETIRE_AGE    = 68;
MIN_DEATH_AGE = 75;
SAMPLE_SIZE   = 1000;

% INPUT NAME HERE
NAME = 'Jennifer';
% Read in all data for named person
configs = getConfiguration(NAME);
[Age, ~, ~, ~, ~, ~, ~, ~, ~] = GetValues(configs);

%% Get Data
% Returns
STOCKS_RET = 0.06;
BONDS_RET  = 0.025;
FTSE_RET   = 0.05;
CASH_RET   = 0.005;
GivenRets  = [STOCKS_RET BONDS_RET FTSE_RET CASH_RET];

% Historical Data
data = csvread('../data/Data.csv',1,1);

sp = 1; bonds = 2; ftse = 3; cash = 4;

%% Generation of Scenarios
% Calculate the Annual Salaries 
TOTAL_YEARS       = 100-Age;
years             = 0:TOTAL_YEARS;

WORKING_AGE_INDEX = 1:(RETIRE_AGE-Age+1);

have_generated = exist('rets');
if have_generated == 0
    [rets, cov_ret] = ScenarioGen (data, GivenRets, SAMPLE_SIZE, ...
        SCENARIOS, TOTAL_YEARS+1);
end
BOND_RETS   = reshape(rets(:,bonds,:),SCENARIOS,TOTAL_YEARS+1)';

%% Get fixed mix - EFF
% Get returns of years from present until retirement 
TARGET_RISK = 0.08:0.01:0.18;
EFF         = zeros(length(TARGET_RISK),3);

for i = 1:length(TARGET_RISK)

[w, ~] =OptimalFixedMixWts( rets(:,:,WORKING_AGE_INDEX),...
    cov_ret,TARGET_RISK(i));
[FM_rbar, FM_vol, ~] = FixedMix(rets,w);
EFF(i,1:2) = [FM_rbar FM_vol];
EFF(i,3)   = FM_rbar/FM_vol;
end

plot(EFF(:,2),EFF(:,1))
title('Fixed Mix Efficient Frontier');
xlabel('Volatility');
ylabel('Return');

%% Get variable fixed mix - EFF
VAR_TIME    = 10;
TARGET_RISK = 0.08:0.01:0.18;
EFF         = zeros(length(TARGET_RISK),3);

for i = 1:length(TARGET_RISK)

[w, ~] = OptimalVarFixedMixWts(rets, Age, RETIRE_AGE, ...
    VAR_TIME, cov_ret, TARGET_RISK(i));
[FM_rbar, FM_vol, ~] = VarFixMixOutput(rets, Age, VAR_TIME, w, RETIRE_AGE);
EFF(i,1:2) = [FM_rbar FM_vol];
EFF(i,3)   = FM_rbar/FM_vol;
end

plot(EFF(:,2),EFF(:,1))
title('10 Year Variable Fixed Mix Efficient Frontier');
xlabel('Volatility');
ylabel('Return');

EFF