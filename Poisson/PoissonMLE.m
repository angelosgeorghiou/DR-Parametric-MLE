%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Poisson MLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [objective,w_aff,w] = PoissonMLE(C,N_c,x,y,lambda,norm_type)

disp(['status for PoissonMLE, lambda = ',num2str(lambda)])

[N_x,m] = size(x);
N = sum(N_c);

cvx_begin quiet
% cvx_solver SDPT3
cvx_solver Mosek
variable w(m)
variable w_aff
variable epigraph_obj(C)

objective = 0;
for i = 1:1:C
    for j = 1:1:N_c(i)
        objective = objective + epigraph_obj(i) - y{i}(j)*(w_aff + x(i,:)*w);
    end
end
objective = objective/N + lambda*norm(w,norm_type);


minimize( objective )
{w_aff + x*w,1,epigraph_obj} == exponential(C);

cvx_end
cvx_status



return

