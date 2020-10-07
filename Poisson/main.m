clc;
clear;
% Fix seed
rng('default');
parpool('local',4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Setup cvx
% cd '/home/angelos/cvx'
% cvx_setup
% cd '/home/angelos/NeurIPS/Poisson'

% Data to generate true distribution
C_true = 100;
m = 10;
w_true = randn(m,1);
w_true = w_true/norm(w_true,1);
w_aff_true = 0;

% Generate True Distribution
[x_c_true,y_c_true,N_c_true] = GenerateTrueDistribution_Poisson(C_true,m,w_aff_true,w_true);
p_hat_OFS = (N_c_true/sum(N_c_true));
mean_y_c_OFS = zeros(C_true,1);
for i = 1:1:C_true
    mean_y_c_OFS(i) = mean(y_c_true{i});
end


Repeat = 100;
for seed = 1:Repeat
    rng(seed);
    
    % Generate sample distribution
    SampleSize = 50;
    [x_c_sample,y_c_sample,N_c_sample,C_sample] = GenerateSampleDistribution(x_c_true,y_c_true,N_c_true,C_true,SampleSize);
    
    
    % Use Example 2.3 Coherent Nominal Distribution to get theta
    [temp,w_aff_MLE,w_MLE] = PoissonMLE(C_sample,N_c_sample,x_c_sample,y_c_sample,0,1);
    theta_c = w_aff_MLE + x_c_sample*w_MLE;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DRO Poisson Regression
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Loss_OFS,alpha_vec,epsilon_vec] = BestAmbiguityDRO(C_true,p_hat_OFS,mean_y_c_OFS,x_c_true,C_sample,m,N_c_sample,x_c_sample,theta_c);
    
    writematrix(Loss_OFS,strcat('Loss_DRO_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    writematrix(epsilon_vec,strcat('epsilon_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    writematrix(alpha_vec,strcat('alpha_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Poisson Lasso
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Loss_norm1,Loss_norm2,lambda_vec] = BestLambdaRegularization(C_true,p_hat_OFS,mean_y_c_OFS,x_c_true,C_sample,N_c_sample,x_c_sample,y_c_sample);
    
    writematrix(Loss_norm1,strcat('Loss_norm1_N',int2str(SampleSize),'_C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    writematrix(Loss_norm2,strcat('Loss_norm2_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    writematrix(lambda_vec,strcat('lambda_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    
end
delete(gcp('nocreate'))

