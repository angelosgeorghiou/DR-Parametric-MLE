clc
clear
rng('default');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Setup cvx
% cd '/home/angelos/cvx'
% cvx_setup
% cd '/home/angelos/NeurIPS/Datasets'


parpool('local',4)

%%%%%%%%%%%%%%%%%%%%%
% Data sets
% australian.csv
% banknote_authentication.csv
% climate_model.csv
% german_credit.csv
% haberman.csv
% housing.csv
% ILPD.csv
% mammographic_mass.csv


Datasets = ["australian","banknote_authentication","climate_model",...
   "german_credit.csv","haberman","housing","ILPD","mammographic_mass"];

Repeat = 100;
for DataSetName = Datasets
 
    Data = csvread(strcat(DataSetName,'.csv'));
    
    % Save resulting data
    CCR_MLE = zeros(Repeat,1);
    AUC_MLE = zeros(Repeat,1);
    
    CCR_L1 = zeros(Repeat,1);
    CCR_L2 = zeros(Repeat,1);
    CCR_DRO = zeros(Repeat,1);
    
    AUC_L1 = zeros(Repeat,1);
    AUC_L2 = zeros(Repeat,1);
    AUC_DRO = zeros(Repeat,1);
    for seed = 1:1:Repeat
        rng(seed);
        % Split data
        [x_c_train,y_c_train,x_c_valid,y_c_valid,x_c_test,y_c_test] = SplitData502525(Data);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % MLE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
        [CCRMLE_test,AUCMLE_test]= MLE(DataSetName,seed,x_c_train,y_c_train,x_c_valid,y_c_valid,x_c_test,y_c_test);     
        CCR_MLE(seed) = CCRMLE_test;
        AUC_MLE(seed) = AUCMLE_test;
               
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % DRO Logistic Regression
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % DRO Logistic
        [CCR_test,AUC_test] = BestAmbiguityDRO_Logistic(DataSetName,seed,x_c_train,y_c_train,x_c_valid,y_c_valid,x_c_test,y_c_test);
        CCR_DRO(seed) = CCR_test;
        AUC_DRO(seed) = AUC_test;
         
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Logistic Lasso
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [CCR1_test,CCR2_test,AUC1_test,AUC2_test]= BestLambdaRegularization_Logistic(DataSetName,seed,x_c_train,y_c_train,x_c_valid,y_c_valid,x_c_test,y_c_test)
        CCR_L1(seed) = CCR1_test;
        CCR_L2(seed) = CCR2_test;
        AUC_L1(seed) = AUC1_test;
        AUC_L2(seed) = AUC2_test;
           
        % save data
        writematrix(CCR_MLE,strcat(DataSetName,'_CCR_MLE_test.csv'));
        writematrix(AUC_MLE,strcat(DataSetName,'_AUC_MLE_test.csv'));
        
        writematrix(CCR_DRO,strcat(DataSetName,'_CCR_DRO_test.csv'));
        writematrix(AUC_DRO,strcat(DataSetName,'_AUC_DRO_test.csv'));
        
        writematrix(CCR_L1,strcat(DataSetName,'_CCR_L1_test.csv'));
        writematrix(CCR_L2,strcat(DataSetName,'_CCR_L2_test.csv'));  
        writematrix(AUC_L1,strcat(DataSetName,'_AUC_L1_test.csv'));
        writematrix(AUC_L2,strcat(DataSetName,'_AUC_L2_test.csv'));
        
        
    end
    
end


delete(gcp('nocreate'))



exit














