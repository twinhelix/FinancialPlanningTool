function [ Big_Hits ] = BigHitsVector(rets, QUANTILE)
SCENARIOS   = size(rets,1);
TOTAL_YEARS = size(rets,3);

new_rets    = reshape(rets(:,1,:),SCENARIOS,TOTAL_YEARS);
Big_Hits    = zeros(1,SCENARIOS);
%QUANTILE    = .25;

for i = 1:SCENARIOS
    sorted_rets = sort(new_rets(i,:));
    
    index       = ceil(length(sorted_rets)*QUANTILE);

    Big_Hits(i) = sorted_rets(index);
end
end
