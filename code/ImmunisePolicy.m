function [ imm_pension_plan ] = ImmunisePolicy( pension_plan, target_reached,...
    bond_rets, dc_weight, savings_weight, salaries, retirement_id, spending )
bond_rets = 1+bond_rets;

CAP_GAINS_TAX = 0.1;
REAL_GAINS    = 1 - CAP_GAINS_TAX;

for i = 1:size(target_reached,2)
first = find(target_reached(:,i) > 0.5,1);
target_reached(first,i) = 0;
end

% PUT ALL IN BONDS ONCE ABOVE LEVEL
imm_pension_plan = pension_plan .* (1-target_reached);

for s_id = 1:size(imm_pension_plan,2)
start_index = find(imm_pension_plan(:,s_id) < 0.01, 1);

for age_id = start_index:max(start_index,size(imm_pension_plan,1))
imm_pension_plan(age_id, s_id) = imm_pension_plan(age_id-1, s_id) * ...
    bond_rets(age_id,s_id);

% STILL CONTRIBUTE
if age_id <= retirement_id
imm_pension_plan(age_id, s_id) = imm_pension_plan(age_id, s_id) +...
        dc_weight * salaries(age_id) + ...
        (1 + (bond_rets(age_id,s_id)-1) * REAL_GAINS) ...
        * savings_weight * salaries(age_id);
else 
imm_pension_plan(age_id, s_id) = imm_pension_plan(age_id, s_id) - spending;
end

end
end
end

