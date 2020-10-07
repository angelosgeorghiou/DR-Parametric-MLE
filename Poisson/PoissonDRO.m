%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DRO Poisson Regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [obj,w_aff,w] = PoissonDRO(C,m,N_c,alpha,epsilon,x_c,theta_c)

p_hat_c = (N_c/sum(N_c));
rho_c = alpha./(N_c); % The alpha will control the size of the ambiguity set
%epsilon = rho_c*p_hat_c

% cvx version
% if y > 0 , y*exp(x/y) <= z as
% {x,y,z} == exponential(1)
% 0 <= y 

disp(['Solving DRO, alpha = ',num2str(alpha),', epsilon = ',num2str(epsilon)])
cvx_begin quiet
% cvx_solver sedumi
% cvx_solver SDPT3
cvx_solver Mosek
variable w(m)
variable w_aff
variable gamma_var(C)
variable t(C)
variable epigraph_obj(C)
variable epigraph_con(C)
variable epigraph_con2(C)
variable alpha_var
variable beta_var

objective = alpha_var + beta_var*epsilon + p_hat_c'*epigraph_obj;

minimize( objective )
subject to
{t-alpha_var - rho_c*beta_var - beta_var,beta_var,epigraph_obj} == exponential(C);
% gamma_var.*(rho_c - exp(theta_c)) +  epigraph_con + exp(w_aff + x_c*w) <= t;
gamma_var.*(rho_c - exp(theta_c)) +  epigraph_con + epigraph_con2 <= t;
{theta_c.*gamma_var - (w_aff + x_c*w),gamma_var,epigraph_con} == exponential(C);
{w_aff + x_c*w,1,epigraph_con2} == exponential(C);


% for c = 1:C
%     % beta*exp((t_c - alpha - rho_c*beta - beta)/beta) <= epigraph_obj
%     {t(c)-alpha_var - rho_c(c)*beta_var - beta_var,beta_var,epigraph_obj(c)} == exponential(1)
%     
%     %     gamma_var(c)*(rho_c(c) - exp(theta_c(c))) +  epigraph_con(c) + exp(w_aff + x_c(c,:)*w) <= t(c);
%     gamma_var(c)*(rho_c(c) - exp(theta_c(c))) +  epigraph_con(c) + epigraph_con2(c) <= t(c);
%     {theta_c(c)*gamma_var(c) - (w_aff + x_c(c,:)*w),gamma_var(c),epigraph_con(c)} == exponential(1)
%     
%     {w_aff + x_c(c,:)*w,1,epigraph_con2(c)} == exponential(1)
% end
0.000000001 <= beta_var 
0.000000001 <= gamma_var 
cvx_end
cvx_status


%t
%exp(theta_c).*(1 - w_aff-x_c*w)


obj = objective;

return

