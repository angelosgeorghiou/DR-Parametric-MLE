function [CCRMLE_test,AUCMLE_test]= MLE(DataSetName,seed,x_c_train,y_c_train,x_c_valid,y_c_valid,x_c_test,y_c_test)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[obj_MLE,w_aff_MLE,w_MLE] = LogisticMLE(x_c_train,y_c_train,0.000001,1);

% resolve using the training data - (no need, I could have saved it above)
[TPR,FPR,CCRMLE_test] = CCR(x_c_test,y_c_test,w_aff_MLE,w_MLE,0.5);
[x,y,AUCMLE_test] = MyROC(x_c_test,y_c_test,w_aff_MLE,w_MLE);

return


