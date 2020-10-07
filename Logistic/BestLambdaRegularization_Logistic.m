function [CCR1_test,CCR2_test,AUC1_test,AUC2_test]= BestLambdaRegularization_Logistic(DataSetName,seed,x_c_train,y_c_train,x_c_valid,y_c_valid,x_c_test,y_c_test)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Logistic Lasso
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambda_discretization = 10;
lambda_vec = logspace(log10(0.0001), log10(1), lambda_discretization);

% save data
CCR1_valid = zeros(lambda_discretization,1);
CCR2_valid = zeros(lambda_discretization,1);
AUC1_valid = zeros(lambda_discretization,1);
AUC2_valid = zeros(lambda_discretization,1);

CCR1_test = zeros(lambda_discretization,1);
CCR2_test = zeros(lambda_discretization,1);
AUC1_test = zeros(lambda_discretization,1);
AUC2_test = zeros(lambda_discretization,1);
parfor ii = 1:1:lambda_discretization
    lambda = lambda_vec(ii);
    
    % Run norm1
    [obj_MLE,w_aff_1,w_MLE_1] = LogisticMLE(x_c_train,y_c_train,lambda,1);
    
    % Run norm2
    [obj_MLE,w_aff_2,w_MLE_2] = LogisticMLE(x_c_train,y_c_train,lambda,2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CCR and AUC
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    [TPR,FPR,CCR1_valid(ii)] = CCR(x_c_valid,y_c_valid,w_aff_1,w_MLE_1,0.5);
    [TPR,FPR,CCR2_valid(ii)] = CCR(x_c_valid,y_c_valid,w_aff_2,w_MLE_2,0.5);
    
    % ROC and AUC
    [x,y,AUC1_valid(ii)] = MyROC(x_c_valid,y_c_valid,w_aff_1,w_MLE_1);
    [x,y,AUC2_valid(ii)] = MyROC(x_c_valid,y_c_valid,w_aff_2,w_MLE_2);
    
    
    % testing data
    [TPR,FPR,CCR1_test(ii)] = CCR(x_c_test,y_c_test,w_aff_1,w_MLE_1,0.5);
    [TPR,FPR,CCR2_test(ii)] = CCR(x_c_test,y_c_test,w_aff_2,w_MLE_2,0.5);
    
    % ROC and AUC
    [x,y,AUC1_test(ii)] = MyROC(x_c_test,y_c_test,w_aff_1,w_MLE_1);
    [x,y,AUC2_test(ii)] = MyROC(x_c_test,y_c_test,w_aff_2,w_MLE_2);
    
    
end

% write the training results just in case
writematrix(AUC1_valid,strcat(DataSetName,'_AUC1_valid_seed', int2str(seed),'.csv'));
writematrix(AUC2_valid,strcat(DataSetName,'_AUC2_valid_seed', int2str(seed),'.csv'));
writematrix(CCR1_valid,strcat(DataSetName,'_CCR1_valid_seed', int2str(seed),'.csv'));
writematrix(CCR2_valid,strcat(DataSetName,'_CCR2_valid_seed', int2str(seed),'.csv'));

writematrix(AUC1_test,strcat(DataSetName,'_AUC1_test_seed', int2str(seed),'.csv'));
writematrix(AUC2_test,strcat(DataSetName,'_AUC2_test_seed', int2str(seed),'.csv'));
writematrix(CCR1_test,strcat(DataSetName,'_CCR1_test_seed', int2str(seed),'.csv'));
writematrix(CCR2_test,strcat(DataSetName,'_CCR2_test_seed', int2str(seed),'.csv'));


writematrix(lambda_vec,strcat(DataSetName,'_lambda_seed', int2str(seed),'.csv'));


% Testing phase CCR
% Get the lambda and to evaluate performance in the Testing sample
[M1,I1] = max(CCR1_valid);
[M2,I2] = max(CCR2_valid);

% resolve using the training data - (no need, I could have saved it above)
[objective,w_aff1,w1] = LogisticMLE(x_c_train,y_c_train,lambda_vec(I1),1);
[objective,w_aff2,w2] = LogisticMLE(x_c_train,y_c_train,lambda_vec(I2),2);

[TPR,FPR,CCR1_test] = CCR(x_c_test,y_c_test,w_aff1,w1,0.5);
[TPR,FPR,CCR2_test] = CCR(x_c_test,y_c_test,w_aff2,w2,0.5);


% Testing phase AUC
% Get the lambda and to evaluate performance in the Testing sample
[M1,I1] = max(AUC1_valid);
[M2,I2] = max(AUC2_valid);

% resolve using the training data - (no need, I could have saved it above)
[objective,w_aff1,w1] = LogisticMLE(x_c_train,y_c_train,lambda_vec(I1),1);
[objective,w_aff2,w2] = LogisticMLE(x_c_train,y_c_train,lambda_vec(I2),2);

[x,y,AUC1_test] = MyROC(x_c_test,y_c_test,w_aff1,w1);
[x,y,AUC2_test] = MyROC(x_c_test,y_c_test,w_aff2,w2);

return


