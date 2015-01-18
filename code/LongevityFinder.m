function [ Term_Wealth ] = LongevityFinder( rets, Sex )
Age              = 75;
Sex              = 0;
SCENARIOS        = size(rets,1);
Term_Age         = zeros(1,SCENARIOS);
Term_Age(:)      = Term_Age(:) + 75;
Prob_Age         = zeros(100-Age,1);
Mortality_matrix = MortalityEngine( Sex ,SCENARIOS, Age);
Term_Wealth      = zeros(1,SCENARIOS);
BINS             = 15;

for i = 1:SCENARIOS
    if sum(Mortality_matrix(:,i))>0
    Term_Age(i)   = Term_Age(i) + find(Mortality_matrix(:,i),1,'last');
    else
    end       
end

for j = 1:(100-Age)
    Prob_Age(j) = sum(Mortality_matrix(j,:));
end
    Prob_Age = Prob_Age/SCENARIOS;
    figure;
    bar(Prob_Age,1);
    title('Longevity Histogram');
    xlabel('Age');
    labels = 76:1:100;
    set(gca, 'XTick', 1:length(labels));
    set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
   
    %for i = 1:65
    %rets(:,i)  = i;
    %end
    Find_Term_Age = Term_Age - Age + 41;
    
    for i = 1:SCENARIOS
    Term_Wealth(i) = rets(i,Find_Term_Age(i));
    end
       
    figure; hold on;
    [f,x]=hist(Term_Wealth,BINS);
    bar(x,f/sum(f));
    title('Terminal Wealth');
    xlabel('Wealth');
    ylabel('Probability');
    plot([0 0],get(gca,'ylim'),'r-');
    hold off;
end

