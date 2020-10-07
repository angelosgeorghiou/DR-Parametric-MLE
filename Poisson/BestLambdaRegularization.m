function [Loss_norm1,Loss_norm2,lambda_vec] =BestLambdaRegularization(C_true,p_hat_OFS,mean_y_c_OFS,x_c_true,C_sample,N_c_sample,x_c_sample,y_c_sample)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Poisson Lasso
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambda_discretization = 20;

lambda_vec = logspace(log10(0.0001), log10(1), lambda_discretization);

% save data
Loss_norm1 = zeros(lambda_discretization,1);
Loss_norm2 = zeros(lambda_discretization,1);

parfor ii = 1:1:lambda_discretization
    lambda = lambda_vec(ii);
    
    % Run norm1
    [obj_MLE,w_aff_1,w_MLE_1] = PoissonMLE(C_sample,N_c_sample,x_c_sample,y_c_sample,lambda,1);
    % Run norm2
    [obj_MLE,w_aff_2,w_MLE_2] = PoissonMLE(C_sample,N_c_sample,x_c_sample,y_c_sample,lambda,2);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Out of Sample
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:C_true
        Loss_norm1(ii) = Loss_norm1(ii) + p_hat_OFS(i)*(mean_y_c_OFS(i)*log(mean_y_c_OFS(i)) - mean_y_c_OFS(i)*(1 + w_aff_1 + x_c_true(i,:)*w_MLE_1) + exp(w_aff_1 + x_c_true(i,:)*w_MLE_1));
        Loss_norm2(ii) = Loss_norm2(ii) + p_hat_OFS(i)*(mean_y_c_OFS(i)*log(mean_y_c_OFS(i)) - mean_y_c_OFS(i)*(1 + w_aff_2 + x_c_true(i,:)*w_MLE_2) + exp(w_aff_2 + x_c_true(i,:)*w_MLE_2));
    end
end
