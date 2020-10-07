function [CI_vec] = CI(x)

SEM = std(x)/sqrt(length(x));               % Standard Error
ts = tinv([0.025 0.5 0.975],length(x)-1);      % T-Score
% CI_vec = mean(x) + ts*SEM ;
CI_vec = [mean(x), ts(3)*SEM];
return