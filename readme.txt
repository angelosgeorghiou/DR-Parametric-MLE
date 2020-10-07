Code for numerical experiements
-------------------------------
The numerical experiements are carried out in MATLAB using the CVX interface. The solver used is MOSEK 9.2 which supports the exponential cone.

Software required:

  - Matlab (https://www.mathworks.com/products/matlab.html)
  - CVX (http://cvxr.com/cvx/)
  - Mosek 9 (https://mosek.com/)

Poisson Regression experiements
---------------------------------
 The code consists of 11 functions separated into 11 files:
  - main.m  is the function to be run. It controls all the experiments for Poisson regression in section 5.1.
  - PoissonMLE.m solves the maximum likelihood problem in equation (3a). In addition, by changing the arguments it can solve 1 and 2-norm regularization of a given regularization penalty weight.
  - PoissonDRO.m solves the problem (12) for given alpha and epsilon defining the size of the ambiguity.
  - GenerateTrueDistribution_Poisson.m is used to define the true distribution as discribed in beginning of section 5.1.
  - GenerateSampleDistribution.m is used to get a sample from the true distribution.
  - BestAmbiguityDRO.m solve the DRO problem (12) for changing values of alpha and epsilon and records the out-of-sample divergence loss given in section 5.1
  - BestLambdaRegularization.m solves the regularized MLE problem for both 1 and 2-norm for changing values of the penalty weight, recording for each the out-of-sample divergence loss.
  - writematrix.m is an auxiliary function used to print the results into csv file to be use later from the plotting function
  - CI.m computes  the confidence interval of the sample mean
  - CVaR.m computes the conditional value at risk for a given risk level.
  - plotting.m is used to produce Figure 1 and Table 1 by reading the csv files produced when the main function is run.
  
Procedure to produce results
 - Run the main.m function, by changing the SampleSize in line 34 to {50,100,500} samples. Each run will produce the csv files containing the necessary results for the out-of-sample divergence loss.
 - Run the plotting.m function to produce the graph and table.
 
 
 
Logistic Regression experiements
---------------------------------
 The code consists of 12 functions separated into 12 files:
  - main.m is the function to be run. It controls the experiment for Logistic regression in section 5.2.
  - MLE.m runs the logistic regression MLE.
  - LogisticMLE.m runs the 1 and 2-norm regularization Logistic MLE of a given regularization penalty weight.
  - DROLogistic.m solves the problem (13) for given alpha and epsilon defining the size of the ambiguity.
  - SplitData502525.m is used to split the data into training, validation, testing sets using the ratio 50-25-25. The function datasplitind.m is used within this procedure (written by Vahe Tshitoyan in 2017)
  - CCR.m computes the Correct Classification Rate (CCR) for the threshold 0.5.
  - MyROC.m computes the Receiver operating characteristic curve and returns the Area Under the Curve (AUC).
  - BestAmbiguityDRO_Logistic.m solve the DRO problem (12) for changing values of alpha and epsilon using the testing data, selects the best combination based on the validation test, and evaluates the performance based in the testing set. The function records the AUC and CCR metrics.
  - BestLambdaRegularization_Logistic.m solve the 1 and 2-norm regularization by changing the value of the penalty weight, selects the best weight based on the validation test, and evaluates the performance based in the testing set. The function records the AUC and CCR metrics.
  - writematrix.m is an auxiliary function used to print the results into csv file to be use later from the plotting function.
  - plotting.m is used to produce Table 2 by reading the csv files produced when the main function is run.

The data sets:
 - The first column is the label 0 or 1, and the rest are the covariates.
 - There are 8 data sets named accordingly.
 
Procedure to produce results
 - Run the main.m function. The function will produce the csv files containing the AUC and CCR metrics for each dataset.
 - Run the plotting.m function to produce the table.