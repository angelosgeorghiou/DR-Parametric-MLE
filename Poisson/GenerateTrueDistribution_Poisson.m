%%%%%%%%%%%%%%%%%%%%%%%%%
% true distribution
%%%%%%%%%%%%%%%%%%%%%%%%%
function [x_c,y_c,N_c] = GenerateTrueDistribution_Poisson(C_true,m,w_aff,w)

% Number of observations per x
N_c = ceil(10000*rand(C_true,1));
x_c = randn(C_true,m);       
for i = 1:C_true
    y_c{i} = poissrnd(exp(w_aff+ x_c(i,:)*w),1,N_c(i));
end
return