clear
load('pstnp.mat');
data=zscore(pstnp);
lasso_beta(data);

%% generates regression coefficient beta (weight)
% 1.data needs zscore standardization in advance
% 2. As a result, a beta.mat weight file is generated. The absolute value needs to be taken and sorted in descending order.
function lasso_beta(data)
length=size(data,1);
label=[ones(length/2,1);zeros(length/2,1)];

best_acc=0;
best_Alpha=0;
for i=0.01:0.1:0.99
    i
[b fitinfo]=lassoglm(data,label,'poisson','Alpha',i,'CV',5);
% Alpha ¡Ê(0,1]
lam =fitinfo.Index1SE;       % find index of suggested lambda
ori_beta=b(:,lam);
abs_beta=abs(ori_beta);
[score weight]=sort(abs_beta);
data_lasso=data(:,weight(1:70)); 
[c, acc] = svmcg(data_lasso,1,-5,3,0,0);
if best_acc<=acc
    best_weight=weight;
    best_acc=acc;
    best_Alpha=i;
end

end
weight=best_weight;
save weight weight
save Alpha best_Alpha
end



%% svmcg function
function [bestc, bestAcc, bestMCC, bestSn, bestSp] = svmcg( data ,cstep,cmin,cmax, c0,acc0)
M=size(data,1);
label=[ones(M/2,1);zeros(M/2,1)];
[X,Y] = meshgrid(cmin:cstep:cmax);
[m,n] = size(X);
bestc = c0;
bestAcc = acc0;
basenum = 2;
bestSn=0;
bestSp=0;
bestMCC=0;
load('indices.mat');
for x = 1:m
    cmd = [' -t ', num2str(0),' -c ',num2str( basenum^X(x,1))];
    for i = 1:5
        test = (indices == i);
        train = ~test;  
        train_data=data(train,:); 
        train_label=label(train,:);
        test_data=data(test,:); 
        test_label=label(test,:);
        model = svmtrain( train_label, train_data, cmd );
        [predict_label] = svmpredict(test_label, test_data,model);
        [Sn_i,Sp_i,MCC_i,Acc_i]=perf(predict_label,test_label);
        Acc(1,i)=Acc_i;
        Sn(1,i)=Sn_i;
        Sp(1,i)=Sp_i;
        MCC(1,i)=MCC_i;
    end
    tem_Acc=sum(Acc)/5;
    tem_Sn=sum(Sn)/5;
    tem_Sp=sum(Sp)/5;
    tem_MCC=sum(MCC)/5;
    if tem_Acc > bestAcc
        bestAcc = tem_Acc;
        bestSn=tem_Sn;
        bestSp=tem_Sp;
        bestMCC=tem_MCC;
        bestc = basenum^X(x,1);
    end
    if ( tem_Acc == bestAcc && bestc > basenum^X(x,1) )
        bestAcc = tem_Acc;
        bestSn=tem_Sn;
        bestSp=tem_SP;
        bestMCC=tem_MCC;
        bestc = basenum^X(x,1);
    end
    
end
end

function [Sn,Sp,MCC,Acc]=perf(pre_label,label)
length=size(label,1);
TP=0;
FP=0;
TN=0;
FN=0;
for i=1:length
    if(label(i)==1)
        if(pre_label(i)==1)
            TP=TP+1;
        else
            FN=FN+1;
        end
        
    else if(label(i)==0)
            if(pre_label(i)==0)
                TN=TN+1;
            else
                FP=FP+1;
            end
        end
    end
end
P=TP+FN;
N=TN+FP;
Acc=(TP+TN)/(N+P);
Sn=TP/P;
Sp=TN/N;
MCC=(TP*TN-FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
end
