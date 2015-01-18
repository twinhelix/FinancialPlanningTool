function [ std_pension ] = StandardPolicy( pension_plan, target_reached,...
    cash_rets, dc_weight, savings_weight, salaries, retirement_id, spending )
cash_rets = 1+cash_rets;

CAP_GAINS_TAX = 0.1;
REAL_GAINS    = 1 - CAP_GAINS_TAX;

for i = 1:size(target_reached,2)
first = find(target_reached(:,i) > 0.5,1);
target_reached(first,i) = 0;
end

bool_multi = 1-target_reached;
bool_multi(1:retirement_id,:) = 1;
% PUT ALL IN CASH
std_pension = pension_plan .* bool_multi;

for s_id = 1:size(std_pension,2)
    start_index = find(std_pension(:,s_id) < 0.01, 1);

    for age_id = start_index:max(start_index,size(std_pension,1))
        std_pension(age_id, s_id) = std_pension(age_id-1, s_id) * ...
            cash_rets(age_id,s_id);
        std_pension(age_id, s_id) = std_pension(age_id, s_id) - spending;
    end
end
end
