%% Financial Risk Management - Final Project
% Lu Xin, Edward Stivers     - Jan 19, 2015 
clc; clear all;
% SETTINGS
SCENARIOS     = 1000;

RETIRE_AGE    = 68;
MIN_DEATH_AGE = 75;
SAMPLE_SIZE   = 2000;

TARGET_RISK   = 0.15;

% INPUT NAME HERE
NAME = 'Jennifer';
% Read in all data for named person
configs = getConfiguration(NAME);
[Age Sex Salary SalaryIncr MatchingContr...
    AdditionContr MaxSalarySaved DCBal SavingsBal] = GetValues(configs);


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

WORKING_AGE_INDEX = 1:(MIN_DEATH_AGE-Age+1);
VAR_TIME          = 10;

have_generated = exist('rets');
if have_generated == 0
    [rets cov_ret] = ScenarioGen (data, GivenRets, SAMPLE_SIZE, ...
        SCENARIOS, TOTAL_YEARS);
end
% reshape(rets(1,:,:),4,65)

%% Big Hits Vector
QUANTILE   = .25;
[Big_Hits] = BigHitsVector(rets, QUANTILE);

%% Get best fixed mix
% Get returns of years from present until retirement 

[w opt_ret] =OptimalFixedMixWts( rets(:,:,WORKING_AGE_INDEX),...
    cov_ret,TARGET_RISK);

[FM_rbar, FM_vol, FM_Returns] = FixedMix(rets(:,:,WORKING_AGE_INDEX),w);
FM_rbar;
FM_vol;

%% Get best fixed mix
% Get returns of years from present until retirement 

[ten_w ten_opt_ret] =OptimalFixedMixWts( rets(:,:,WORKING_AGE_INDEX),...
    cov_ret,TARGET_RISK);

[FM_rbar, FM_vol, FM_Returns] = FixedMix(rets(:,:,WORKING_AGE_INDEX),ten_w);
FM_rbar;
FM_vol;

%% Bogle Rule
%Get returns of years from present until retirement

[ Bog_ret, Bog_std, Bog_returns ] = Bogle( rets , WORKING_AGE_INDEX);

Bog_ret;
Bog_std;
Bog_returns;

%% Get best variable fixed mix
% Get returns of years from present until retirement 

[ Var_wts , Var_ret] = OptimalVarFixedMixWts(rets, Age, RETIRE_AGE, VAR_TIME,cov_ret, TARGET_RISK);
[ Var_avg_ret, Var_avg_std, Var_yearly_returns ] = VarFixMixOutput(rets, Age, VAR_TIME, Var_wts, RETIRE_AGE);
 
 
%% Vol Pump Strategy
% Get returns of years from present until retirement
% Pump values must divide cleanly into 60
PUMP   = [.01, .02, .05, .10,.15];
THRESH = .10:.05:.30;
Record = zeros(length(PUMP)*length(THRESH),5);
for i = 1:length(PUMP)
    for j = 1:length(THRESH)
        PUMP_AMT  = PUMP(i);
        THRESHOLD = -THRESH(j);
        [Vol_ret, Vol_std, Vol_returns] = VolPump(rets , PUMP_AMT, w , THRESHOLD);
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
Vol_returns;

%% DD Rule %%
targetDD = .2;
[ DD_opt_w, DD_opt_ret ] = OptimalDDWts( rets, cov_ret, TARGET_RISK, targetDD );

[DD_rbar, DD_vol, DD_Returns] = FixedMix(rets , DD_opt_w);
DD_rbar;
DD_vol;
%% Compare Returns

RetVect = [FM_rbar, Bog_ret, Var_avg_ret, Vol_ret, DD_rbar]
StdVect = [FM_vol, Bog_std, Var_avg_std, Vol_std, DD_vol]

%% Simulate Plan

%PensionPlanSimulator( NAME, RETIRE_AGE, FM_Returns );
%% Get Mortality Matrix
life = MortalityEngine( Sex, SCENARIOS, Age);

