clear all
clc

%% Loading Data
data = csvread('../../data/Part1.csv',1,1);
data = data(1:3281,:);
daily_ret = data(2:end,:)./data(1:end-1,:)-1;
FTSE_ret = daily_ret(:,1);
GSCI_ret = daily_ret(:,2);
Bond_ret = daily_ret(:,3);
Stock_ret = daily_ret(:,4);
daily_ret = [FTSE_ret GSCI_ret Bond_ret Stock_ret];

%% Calculate Historical mean return and covariance for returns
TradingDays = 252;
ER  = (data(end,:)./data(1,:)).^(1/12.5) -1 ;
ER1 = mean(daily_ret)*TradingDays;
stdev = std(daily_ret)*sqrt(TradingDays);
covar = cov(daily_ret)*TradingDays;

%% Testing with built-in function
%[PortRisk, PortReturn, PortWts]  = portopt(ER, covar)

%% Setting constraints
PortRisk_ = [.03:.01:.40]';
len = size(PortRisk_);
len = len(1);
A    = [1 1 0 0];
b    = 1;
Aeq  = [0 0 1 1];
beq  = 1;
PortWeights = ones(len,4);
PortReturn  = ones(len,1);
PortRisk    = ones(len,1);

%% Setting options for the optimizer
options	  = optimset('Algorithm', 'active-set', 'MaxIter',4*6000, 'MaxFunEvals', 4*6000, 'TolFun', 10^-11);

%% Running optimizer
for i = 1:len
    weights = 0.5*ones(1,4);
    risk = PortRisk_(i);
    [x,fval] = fmincon(@(weights)Portfolio_Return(weights,ER),weights,A,b,Aeq,beq,[],[],@(weights)confun(weights,covar,risk),options);
    PortWeights(i,:) = x;
    PortReturn(i) = -fval;
    PortRisk(i) = sqrt(x*covar*x');
end

%% Drawing Efficient Frontier
Sharpe = (PortReturn-.03)./ PortRisk
scatter(stdev*100, ER1*100)
hold on
plot(PortRisk*100,PortReturn*100,'DisplayName','PortReturn vs. PortRisk','XDataSource','PortRisk','YDataSource','PortReturn');
figure(gcf)
xlabel('Risk (Standard Deviation)%')
ylabel('Expected Return%')
title('Mean-Variance-Efficient Frontier')
grid on


%% Calculating max drawdown and Ulcer Index
period = size(daily_ret);
period = period(1);
frontier_dailyret = zeros(period,len);
frontier_value    = zeros(period,len);
frontier_drawdown = zeros(period,len);
%Calculate the daily return for each frontier
for i = 1:len
    frontier_dailyret(:,i) = sum(bsxfun(@times, daily_ret,PortWeights(i,:)),2);
end
frontier_dailyret = frontier_dailyret+1;
%Calculate the portfolio value for each frontier
for i = 1:period
    frontier_value(i,:) = 1*prod(frontier_dailyret(1:i,:),1);
end
%Calculate drawdowns for each frontier
for i = 1:period
    value = frontier_value(i,:);
    max_value = max(value,[],1);
    frontier_drawdown(i,:) = (max_value-value)/max_value;
end
frontier_Maxdrawdown = max(frontier_drawdown,[],1)


