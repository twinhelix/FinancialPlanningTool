function [ MATRIX ] = MortalityEngine( sex, scenarios, age)
data = csvread('../data/MortTable.csv',1,0);
AGES = data(:,1);
M_PX = data(:,2);
M_LE = data(:,3);
F_PX = data(:,4);
F_LE = data(:,5);

% Sex:1 = Male % Sex:0 = Female
if sex == 1
    PROBS = M_PX;
else 
    PROBS = F_PX;
end

years = 100 - age;
index = find(AGES == age);

transition_prob = PROBS(index:(index+years-1));
MATRIX = zeros(years, scenarios);

MATRIX(1,:) = rand(1,scenarios) < (1-transition_prob(1));
for i = 2:years
    MATRIX(i,:) = MATRIX(i-1,:) .* (rand(1,scenarios) < (1-transition_prob(i)));
end
end

