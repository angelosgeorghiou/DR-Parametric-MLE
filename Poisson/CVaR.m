function [objective] = CVaR(x,epsilon)
cvx_begin quiet
cvx_solver Mosek
variable beta_var 
objective =  beta_var + (1/epsilon)*sum(max(x-beta_var,0))/length(x); 
minimize(objective)
cvx_end
return