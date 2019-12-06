clear all
load('data.mat');
M=size(data,1); 
N=50; 
label=[ones(M/2,1);zeros(M/2,1)];
%% 5-fold
load('indices.mat');
cp = classperf(label);
for i = 1:5
    test = (indices == i);  
    train = ~test;  
    train_data=data(train,:); 
    train_label=label(train,:); 
    m=size(train_data,1);
    test_data=data(test,:); 
    test_label=label(test,:);
    P=rf(N,m,M,train_data,train_label,test_data);  
    classperf(cp,P,test);
end
[ Sn,Sp,Acc,MCC ] = perf( cp )
save result_rf

