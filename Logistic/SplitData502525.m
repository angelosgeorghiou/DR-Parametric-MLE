function  [x_c_train,y_c_train,x_c_valid,y_c_valid,x_c_test,y_c_test] = SplitData502525(Data)

[Observations,attributes] = size(Data);

indices = datasplitind( Observations, 4, true );

training = indices <= 2;
validation = indices == 3;
testing = indices == 4;



x_c_train = Data(training,2:end);
y_c_train = Data(training,1);

x_c_valid = Data(validation,2:end);
y_c_valid = Data(validation,1);

x_c_test = Data(testing,2:end);
y_c_test = Data(testing,1);
end