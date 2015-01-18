function [ target, Moving_Target, yearly_spending ] = TargetWealth( salaries, age, retirement_age, ...
    social, percentage_target, min_death_age, max_save)
% Calculate spending per year 
three_years_before_ret = (1:3) + retirement_age - 3 - age;

yearly_spending = (0.7 * mean(salaries(three_years_before_ret)) - social);

target = yearly_spending/percentage_target;


% Delay retirement she sacrifices 0.3% per year
delayed_target = zeros(1,min_death_age - retirement_age);

for i = 1:(100 - retirement_age)
    delayed_target(i) = yearly_spending/(percentage_target + 0.003*i);
end

% Early retirement account for 2.5% bond
early_target    = zeros(1,length(age:retirement_age));
early_target(1) = target;
BOND_RET        = 0.025;
effective_disc  = (BOND_RET*0.9)/4 + BOND_RET*3/4;

for i = 2:length(early_target)
    early_target(i) = early_target(i-1) * exp(-effective_disc);
    
    year_index = retirement_age - age + 2 - i;
    
    early_target(i) = early_target(i) - salaries(year_index) * max_save;
end

% Combine Targets
Moving_Target   =  [ early_target(end:-1:1) delayed_target];

end

