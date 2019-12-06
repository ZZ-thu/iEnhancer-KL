clear
load('pstnp.mat');
data=pstnp;
data=zscore(data);

load('weight.mat');
data_lasso=[];  bestc_lasso=[];  Acc_lasso=[];   
MCC_lasso=[];   Sn_lasso=[];     Sp_lasso=[];
num_lasso=size(weight,1);

for j=1:num_lasso   
data_lasso=[data_lasso,data(:,weight(j))]; 
[bestc, bestacc, bestMCC, bestSn, bestSp] = svmcg(data_lasso,1,-5,10,0,0);
bestc_lasso=[bestc_lasso;bestc]; 
Acc_lasso=[Acc_lasso;bestacc];   MCC_lasso=[MCC_lasso;bestMCC];
Sn_lasso=[Sn_lasso;bestSn];      Sp_lasso=[Sp_lasso;bestSp];

end

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
