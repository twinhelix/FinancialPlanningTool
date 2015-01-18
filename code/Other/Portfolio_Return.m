function [ Port_ret ] = Portfolio_Return( weights, ER )
%   Calculate the portfolio return

Port_ret = weights*ER';

end

