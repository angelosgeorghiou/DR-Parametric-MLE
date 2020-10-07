function [Loss_OFS,alpha_vec,epsilon_vec] = BestAmbiguityDRO(C_true,p_hat_OFS,mean_y_c_OFS,x_c_true,C_sample,m,N_c_sample,x_c_sample,theta_c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DRO Poisson Regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AmbSizeDiscrete_alpha = 20;
AmbSizeDiscrete_epsilon = 20;  % for ambiguity size
alpha_vec = logspace(log10(0.0001), log10(1), AmbSizeDiscret_alpha);
epsilon_vec = zeros(AmbSizeDiscrete_alpha,AmbSizeDiscrete_epsilon);
% save data
Loss_OFS = zeros(AmbSizeDiscrete_alpha,AmbSizeDiscrete_epsilon);
for ii = 1:1:AmbSizeDiscrete_alpha
    alpha = alpha_vec(ii);
    
    % construct epsilon
    p_hat_c = (N_c_sample/sum(N_c_sample));
    rho_c = alpha./(N_c_sample);
    epsilon_min = rho_c'*p_hat_c;
    epsilon_vec(ii,:) = logspace(log10(epsilon_min), log10(1), AmbSizeDiscret_epsilon);
    
    parfor jj = 1:1:AmbSizeDiscrete_epsilon
        epsilon = epsilon_vec(ii,jj);

        % Run DRO
        [obj,w_aff,w] = PoissonDRO(C_sample,m,N_c_sample,alpha,epsilon,x_c_sample,theta_c);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Out of Sample
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i = 1:C_true
            Loss_OFS(ii,jj) = Loss_OFS(ii,jj) + p_hat_OFS(i)*(mean_y_c_OFS(i)*log(mean_y_c_OFS(i)) - mean_y_c_OFS(i)*(1 + w_aff + x_c_true(i,:)*w) + exp(w_aff + x_c_true(i,:)*w));
        end
    end
end
return