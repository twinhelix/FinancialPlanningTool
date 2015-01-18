function [ Age Sex Salary SalaryIncr ...
   MatchingContr AdditionContr MaxSalarySaved DCBal SavingsBal] = GetValues( configs )

% GET AGE
if isfield(configs, 'Age') == 1
    Age           = str2double(configs.Age.Text);
else
    Age           = 25;
end

% GET SEX: 1 = MALE ; 0 = FEMALE
if isfield(configs, 'Sex') == 1
    Sex           = strcmp(configs.Age.Text,'M');
else
    Sex           = 'M';
end

% GET SALARY
if isfield(configs, 'Salary') == 1
    Salary        = str2double(configs.Salary.Text);
else
    Salary        = 100000;
end

% GET EXPECTED SALARY INCREASE
if isfield(configs, 'SalaryIncr') == 1
    SalaryIncr    = str2double(configs.SalaryIncr.Text);
else
    SalaryIncr    = 0.01;
end

% GET MATRCHING CONTRIBUTION
if isfield(configs, 'MatchingContr') == 1
    MatchingContr = str2double(configs.MatchingContr.Text);
else
    MatchingContr = 0.04;
end

% GET ADDITIONAL CONTRIBUTION
if isfield(configs, 'Age') == 1
    AdditionContr = str2double(configs.AdditionContr.Text);
else
    AdditionContr = 0.06;
end

% GET MAX SALARY CONTRIBUTION
if isfield(configs, 'MaxSalarySaved') == 1
    MaxSalarySaved = str2double(configs.MaxSalarySaved.Text);
else
    MaxSalarySaved = 0.06;
end


% GET DC PLAN BALANCE
if isfield(configs, 'DCBal') == 1
    DCBal         = str2double(configs.DCBal.Text);
else
    DCBal         = 0;
end

% GET NON-PENSION SAVINGS
if isfield(configs, 'SavingsBal') == 1
    SavingsBal    = str2double(configs.SavingsBal.Text);
else
    SavingsBal    = 0;
end
end
