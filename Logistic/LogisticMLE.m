%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MLE for Logistic Regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [objective,w_aff,w] = LogisticMLE(x,y,lambda,norm_type)

[N,m] = size(x);

cvx_begin quiet
cvx_solver Mosek
variable w(m)
variable w_aff
variable v(N)
variable u(N)
variable z(N)

objective = (sum(z) - sum(y.*(w_aff + x*w)))/N + lambda*norm(w,norm_type);
minimize( objective )
subject to
u + v <= ones(N,1);
{(w_aff + x*w)-z,1,u} == exponential(N);
{-z,1,v} == exponential(N);
cvx_end
disp(['status for MLE, lambda = ',num2str(lambda)])
cvx_status

return

