%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DRO Logistic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obj,w_aff,w] = DROLogistic(x_c_sample,theta_c,alpha,epsilon)

[SampleSize,m] = size(x_c_sample);

p_hat_c = (1/SampleSize)*ones(SampleSize,1);
rho_c = alpha * ones(SampleSize,1);  % since N_c = 1

% cvx version
% if y > 0 , y*exp(x/y) <= z as
% {x,y,z} == exponential(1)
% 0 <= y 

disp(['Solving DROLogistic, alpha = ',num2str(alpha),', epsilon = ',num2str(epsilon)])
cvx_begin quiet
%cvx_solver SDPT3
cvx_solver Mosek
variable w(m)
variable w_aff
variable gamma_var(SampleSize)
variable t(SampleSize)
variable epigraph_obj(SampleSize)
variable z1(SampleSize)
variable u1(SampleSize)
variable v1(SampleSize)
variable u2(SampleSize)
variable v2(SampleSize)
variable z2(SampleSize)
variable alpha_var
variable beta_var

objective = alpha_var + beta_var*epsilon + p_hat_c'*epigraph_obj;

minimize( objective )
subject to
gamma_var.*(rho_c - log(1 + exp(theta_c))) + z1  + z2  <= t;  

{t-alpha_var - rho_c*beta_var - beta_var,beta_var,epigraph_obj} == exponential(SampleSize);

u1 + v1 <= gamma_var;
{theta_c.*gamma_var - (w_aff + x_c_sample*w)-z1,gamma_var,u1} == exponential(SampleSize);
{-z1,gamma_var,v1} == exponential(SampleSize);

u2 + v2 <= 1;
{(w_aff + x_c_sample*w)-z2,1,u2} == exponential(SampleSize)
{-z2,1,v2} == exponential(SampleSize)


0.0001 <= beta_var 
0.0001 <= gamma_var 
cvx_end
cvx_status

obj = objective;

return

