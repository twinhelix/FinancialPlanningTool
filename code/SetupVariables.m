%% Financial Risk Management - Final Project
% Lu Xin, Edward Stivers     - Jan 19, 2015 
clc; clear all;
% SETTINGS
SCENARIOS     = 1000;
RETIRE_AGE    = 68;
MIN_DEATH_AGE = 75;
SAMPLE_SIZE   = 1000;
TARGET_RISK   = 0.15;

BIG_HITS_QUANTILE = 0.20; 

% INPUT NAME HERE
NAME = 'Jennifer';
% Read in all data for named person
configs = getConfiguration(NAME);
[Age, Sex, ~, ~, ~, ~, ~, ~, ~] = GetValues(configs);

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
CASH_RETS   = reshape(rets(:,cash,:),SCENARIOS,TOTAL_YEARS+1)';

% 20% of time she experiences a hit at least this big
LARGE_STOCK_HITS = BigHitsVector(rets, BIG_HITS_QUANTILE);

% Allow her to lower her target wealth in worst 10% of cases
lower_target_vector = LARGE_STOCK_HITS<=quantile(LARGE_STOCK_HITS,0.1);


save('ftp_scenario')
