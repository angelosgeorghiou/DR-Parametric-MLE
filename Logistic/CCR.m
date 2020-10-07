%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Correct Classification Rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [TPR,FPR,CCR_val] = CCR(x_c_true,y_c_true,w_aff,w,threshold)

[N,m] = size(x_c_true);

Predict = (1./(1 + exp(-w_aff - x_c_true*w))) > 1 - threshold;

ConfusionMatrix = zeros(2,2);
for i = 1:1:N
    
    if (Predict(i)==1) && (y_c_true(i)==1)
        ConfusionMatrix(1,1)= ConfusionMatrix(1,1)+1;
    end
    if (Predict(i)==0) && (y_c_true(i)==1)
        ConfusionMatrix(1,2)= ConfusionMatrix(1,2)+1;
    end
    if (Predict(i)==1) && (y_c_true(i)==0)
        ConfusionMatrix(2,1)= ConfusionMatrix(2,1)+1;
    end
    if (Predict(i)==0) && (y_c_true(i)==0)
        ConfusionMatrix(2,2)= ConfusionMatrix(2,2)+1;
    end
    
    
end

CCR_val = (ConfusionMatrix(1,1) + ConfusionMatrix(2,2))/sum(sum(ConfusionMatrix));

% Matrix
% TP | FN
% FP | TN

% Sensitivity = TPR = True Positive Rate = TP/(TP + FN)
% Specificity = FPR = False Positive Rate = TN/(TN + FP)

TPR = ConfusionMatrix(1,1)/(ConfusionMatrix(1,1) + ConfusionMatrix(1,2));
FPR = 1 - ConfusionMatrix(2,2)/(ConfusionMatrix(2,2) + ConfusionMatrix(2,1));
end