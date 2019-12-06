clear all;
close all;
clc;
ans=[];
load('data.mat');
num=size(data,1);
label=[ones(num/2,1);zeros(num/2,1)];
K=11;  
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
    P=knn_whole(K,train_data,train_label,test_data);  
    classperf(cp,P,test);
end
[ Sn,Sp,Acc,MCC ] = perf( cp )
save result_KNN
        
