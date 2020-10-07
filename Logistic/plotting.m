clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Table 2: UCI data sets AUC and CCR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Datasets = ["australian","banknote_authentication","climate_model",...
   "german_credit.csv","haberman","housing","ILPD","mammographic_mass"];


for DataSetName = Datasets

    CCR_DRO = csvread(strcat(DataSetName,'_CCR_DRO_test.csv'));
    AUC_DRO = csvread(strcat(DataSetName,'_AUC_DRO_test.csv'));
    CCR_L1 = csvread(strcat(DataSetName,'_CCR_L1_test.csv'));
    CCR_L2 = csvread(strcat(DataSetName,'_CCR_L2_test.csv'));
    AUC_L1 = csvread(strcat(DataSetName,'_AUC_L1_test.csv'));
    AUC_L2 = csvread(strcat(DataSetName,'_AUC_L2_test.csv'));
    CCR_MLE = csvread(strcat(DataSetName,'_CCR_MLE_test.csv'));
    AUC_MLE = csvread(strcat(DataSetName,'_AUC_MLE_test.csv'));
    
        
    AUC_DRO_mean = mean(100*AUC_DRO)
    AUC_L1_mean = mean(100*AUC_L1)
    AUC_L2_mean = mean(100*AUC_L2)
    AUC_MLE_mean = mean(100*AUC_MLE)  

    disp("===============================")    
     
    CCR_DRO_mean = mean(100*CCR_DRO)
    CCR_L1_mean = mean(100*CCR_L1)
    CCR_L2_mean = mean(100*CCR_L2)
    CCR_MLE_mean = mean(100*CCR_MLE)
end





