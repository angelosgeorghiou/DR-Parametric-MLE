clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot graphs for Poisson Regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m = 10;
C_true = 100;
Runs = 100;
%%%%%%%%%%%%%%%%%%% 50 Samples
SampleSize = 50;


L1 = zeros(Runs,20);
L2 = zeros(Runs,20);
DRO = zeros(Runs,20);


DRO_min = zeros(Runs,1);
L1_min = zeros(Runs,1);
L2_min = zeros(Runs,1);
MLE = zeros(Runs,1); 
for seed = 1:Runs
    
    Loss_DRO = csvread(strcat('Loss_DRO_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    Loss_L1 = csvread(strcat('Loss_norm1_N',int2str(SampleSize),'_C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    Loss_L2 = csvread(strcat('Loss_norm2_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    
    
    lambda_vec = csvread(strcat('lambda_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    alpha_vec = csvread(strcat('alpha_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    epsilon_vec = csvread(strcat('epsilon_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    
    DRO(seed,:) = Loss_DRO(:,20)';
    L1(seed,:) = Loss_L1';
    L2(seed,:) = Loss_L2';
    
    MLE(seed) = Loss_L2(1);
    
    DRO_min(seed) = min(min(Loss_DRO));
    L1_min(seed) = min(Loss_L1);
    L2_min(seed) = min(Loss_L2);
  
end

figure(1)
f1 = subplot(1,3,1);
loglog(alpha_vec, prctile(DRO,90)); hold on;
loglog(alpha_vec, prctile(DRO,10)); hold on;
patch([alpha_vec fliplr(alpha_vec)], [prctile(DRO,10) fliplr(prctile(DRO,90))], [0.6 0.8 1.0])
loglog(alpha_vec, median(DRO),'b','linewidth',2); hold on;
title('50 training samples', 'FontSize', 16)
xlabel('a', 'FontSize', 16)
ylabel('out-of-sample divergence', 'FontSize', 16)
axis square
ylim([0,0.15])
xlim([0.0001,0.1])
grid on;

v1 = median(DRO);
(v1(1) - min(median(DRO)))/(2*(v1(1) + min(median(DRO))))

CI_DRO_vs_L1 = CI(100*(DRO_min - L1_min)./L1_min)
CI_DRO_vs_L2 = CI(100*(DRO_min - L2_min)./L2_min)
CI_DRO_vs_MLE = CI(100*(DRO_min - MLE)./MLE)

CVaR(DRO_min)
CVaR(L1_min)
CVaR(L2_min)
CVaR(MLE)

%%%%%%%%%%%%%%%%%%% 100 Samples
SampleSize = 100;


L1 = zeros(Runs,20);
L2 = zeros(Runs,20);
DRO = zeros(Runs,20);

DRO_min = zeros(Runs,1);
L1_min = zeros(Runs,1);
L2_min = zeros(Runs,1);
MLE = zeros(Runs,1); 
for seed = 1:Runs
    
    Loss_DRO = csvread(strcat('Loss_DRO_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    Loss_L1 = csvread(strcat('Loss_norm1_N',int2str(SampleSize),'_C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    Loss_L2 = csvread(strcat('Loss_norm2_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    
    
    lambda_vec = csvread(strcat('lambda_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    alpha_vec = csvread(strcat('alpha_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    epsilon_vec = csvread(strcat('epsilon_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    
    DRO(seed,:) = Loss_DRO(:,20)';
    L1(seed,:) = Loss_L1';
    L2(seed,:) = Loss_L2';
    
    DRO_min(seed) = min(min(Loss_DRO));
    L1_min(seed) = min(Loss_L1);
    L2_min(seed) = min(Loss_L2);
  
    MLE(seed) = Loss_L2(1);
end


figure(1)
f2 = subplot(1,3,2);
loglog(alpha_vec, prctile(DRO,90)); hold on;
loglog(alpha_vec, prctile(DRO,10)); hold on;
patch([alpha_vec fliplr(alpha_vec)], [prctile(DRO,10) fliplr(prctile(DRO,90))], [0.6 0.8 1.0])
loglog(alpha_vec, median(DRO),'b','linewidth',2); hold on;
title('100 training samples', 'FontSize', 16)
xlabel('a', 'FontSize', 16)
ylabel('out-of-sample divergence', 'FontSize', 16)
axis square
ylim([0,0.15])
xlim([0.0001,0.1])
grid on;

v1 = median(DRO);
(v1(1) - min(median(DRO)))/(2*(v1(1) + min(median(DRO))))

CI_DRO_vs_L1 = CI(100*(DRO_min - L1_min)./L1_min)
CI_DRO_vs_L2 = CI(100*(DRO_min - L2_min)./L2_min)
CI_DRO_vs_MLE = CI(100*(DRO_min - MLE)./MLE)

CVaR(DRO_min)
CVaR(L1_min)
CVaR(L2_min)
CVaR(MLE)

%%%%%%%%%%%%%%%%%%% 500 Samples
SampleSize = 500;

L1 = zeros(Runs,20);
L2 = zeros(Runs,20);
DRO = zeros(Runs,20);

DRO_min = zeros(Runs,1);
L1_min = zeros(Runs,1);
L2_min = zeros(Runs,1);
MLE = zeros(Runs,1); 
for seed = 1:Runs
    
    Loss_DRO = csvread(strcat('Loss_DRO_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    Loss_L1 = csvread(strcat('Loss_norm1_N',int2str(SampleSize),'_C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    Loss_L2 = csvread(strcat('Loss_norm2_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    
    
    lambda_vec = csvread(strcat('lambda_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    alpha_vec = csvread(strcat('alpha_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
    epsilon_vec = csvread(strcat('epsilon_N',int2str(SampleSize),'C',int2str(C_true),'_m',int2str(m),'_seed', int2str(seed),'.csv'));
  
    DRO(seed,:) = Loss_DRO(:,20)';
    L1(seed,:) = Loss_L1';
    L2(seed,:) = Loss_L2';
    
    MLE(seed) = Loss_L2(1);
    
    DRO_min(seed) = min(min(Loss_DRO));
    L1_min(seed) = min(Loss_L1);
    L2_min(seed) = min(Loss_L2);
  
end

figure(1)
f3 = subplot(1,3,3);
loglog(alpha_vec, prctile(DRO,90)); hold on;
loglog(alpha_vec, prctile(DRO,10)); hold on;
patch([alpha_vec fliplr(alpha_vec)], [prctile(DRO,10) fliplr(prctile(DRO,90))], [0.6 0.8 1.0])
loglog(alpha_vec, median(DRO),'b','linewidth',2); hold on;
title('500 training samples', 'FontSize', 16)
xlabel('a', 'FontSize', 16)
ylabel('out-of-sample divergence', 'FontSize', 16)
axis square
ylim([0,0.15])
xlim([0.0001,0.1])
grid on

v1 = median(DRO);
(v1(1) - min(median(DRO)))/(2*(v1(1) + min(median(DRO))))


CI_DRO_vs_L1 = CI(100*(DRO_min - L1_min)./L1_min)
CI_DRO_vs_L2 = CI(100*(DRO_min - L2_min)./L2_min)
CI_DRO_vs_MLE = CI(100*(DRO_min - MLE)./MLE)

CVaR(DRO_min)
CVaR(L1_min)
CVaR(L2_min)
CVaR(MLE)