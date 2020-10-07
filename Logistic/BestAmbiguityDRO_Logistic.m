function [CCR_test_val,AUC_test_val] = BestAmbiguityDRO_Logistic(DataSetName,seed,x_c_train,y_c_train,x_c_valid,y_c_valid,x_c_test,y_c_test)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DRO Logistic Regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use Example 2.3 Coherent Nominal Distribution to get theta 
[objective,w_aff_MLE,w_MLE] = LogisticMLE(x_c_train,y_c_train,0.001,1);
theta_c = w_aff_MLE + x_c_train*w_MLE;

% DRO
[SampleSize,m] = size(x_c_train);
AmbSizeDiscrete_alpha = 10;
alpha_vec = logspace(log10(0.0001), log10(10), AmbSizeDiscrete_alpha);

% save data
CCR_valid = zeros(AmbSizeDiscrete_alpha,1);
AUC_valid = zeros(AmbSizeDiscrete_alpha,1);
CCR_test = zeros(AmbSizeDiscrete_alpha,1);
AUC_test = zeros(AmbSizeDiscrete_alpha,1);
parfor ii = 1:1:AmbSizeDiscrete_alpha
    alpha = alpha_vec(ii);
    
    % construct epsilon
    p_hat_c = (1/SampleSize)*ones(SampleSize,1);
    rho_c = alpha * ones(SampleSize,1);
    epsilon_min = rho_c'*p_hat_c;
    epsilon = 2*epsilon_min;
    
    % Run DRO
    [obj,w_aff_DRO,w_DRO] = DROLogistic(x_c_train,theta_c,alpha,epsilon);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CCR and AUC
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % validation data
    [TPR,FPR,CCR_valid(ii,1)] = CCR(x_c_valid,y_c_valid,w_aff_DRO,w_DRO,0.5);
    [x,y,AUC_valid(ii,1)] = MyROC(x_c_valid,y_c_valid,w_aff_DRO,w_DRO);
      
end



% Testing phase
% Get the alpha and epsilon for testing
% Test 1 based on CCR criterion
maximum = max(max(CCR_valid));
[row_best_alpha, col_best_epsilon] =find(CCR_valid==maximum);
if (length(row_best_alpha) > 1)
    row_best_alpha = row_best_alpha(1);
end
p_hat_c = (1/SampleSize)*ones(SampleSize,1);
rho_c = alpha_vec(row_best_alpha) * ones(SampleSize,1);
epsilon_min = rho_c'*p_hat_c;
% Resolve the DRO problem so as to get the solution (could have saved it above)
[obj,w_aff_test,w_test] = DROLogistic(x_c_train,theta_c,alpha_vec(row_best_alpha),2*epsilon_min);

[TPR,FPR,CCR_test_val] = CCR(x_c_test,y_c_test,w_aff_test,w_test,0.5);


% Test 2 based on AUC criterion
maximum = max(max(AUC_valid));
[row_best_alpha, col_best_epsilon] = find(AUC_valid==maximum);
if (length(row_best_alpha) > 1)
    row_best_alpha = row_best_alpha(1);
end
p_hat_c = (1/SampleSize)*ones(SampleSize,1);
rho_c = alpha_vec(row_best_alpha) * ones(SampleSize,1);
epsilon_min = rho_c'*p_hat_c;
% Resolve the DRO problem so as to get the solution (could have saved it above)
[obj,w_aff_test,w_test] = DROLogistic(x_c_train,theta_c,alpha_vec(row_best_alpha),2*epsilon_min);

[x,y,AUC_test_val] = MyROC(x_c_test,y_c_test,w_aff_test,w_test);



return