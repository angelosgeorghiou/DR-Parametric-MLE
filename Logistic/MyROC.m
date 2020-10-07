%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Correct Classification Rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [x,y,AUC] = MyROC(x_c_true,y_c_true,w_aff,w)

    N = 1000;
    y = zeros(N,1);
    x = zeros(N,1);
    for j = 1:N
        threshold = 1-(N - j)/N;
        [y(j),x(j),CCR_val] = CCR(x_c_true,y_c_true,w_aff,w,threshold);
    end
    AUC = trapz(x, y);
end