clear
load('pstnp.mat');
data=zscore(pstnp);
% wr=0.5;
% wd=0.5;
% lasso_beta(data,wr,wd);

best_acc=0;
for wr=0.1:0.1:0.9
    wr
    wd=1-wr;
    weight=lasso_beta(data,wr,wd);
    data_lasso=data(:,weight(1:80));
    % [bestc, bestAcc, bestSn, bestSp, bestMCC] = svmcg( data ,cstep,cmin,cmax,c0,acc0)
    [c, acc] = svmcg(data_lasso,1,-5,3,0,0);
    if best_acc<=acc
        best_acc=acc;
        best_weight=weight;
        best_wr=wr;
    end

end
weight=best_weight;
save weight weight
save result

%% generates regression coefficient beta (weight)
% 1. data needs zscore standardization in advance
% 2. As a result, a beta.mat weight file is generated. 
% The absolute value needs to be taken and sorted in descending order.
function weight=lasso_beta(data,wr,wd)
[num,dimension]=size(data);
Y=[ones(num/2,1);zeros(num/2,1)];
for i=1:dimension
    X=data(:,i);
    x=sum(X)/num;
    y=sum(Y)/num;
% ---------- Calculate mR maximum correlation -----------
    for j=1:num
        tem_Sx(j)=(X(j)-x)^2;
        tem_Sy(j)=(Y(j)-y)^2;
        tem_Sxy(j)=(X(j)-x)*(Y(j)-y);
    end
    Sx=sqrt(sum(tem_Sx)/(num-1));
    Sy=sqrt(sum(tem_Sy)/(num-1));
    Sxy=sum(tem_Sxy)/(num-1);
    mRel(i)=Sxy/(Sx*Sy);
    
% ---------- Calculate the maximum distance of MR -----------
    index=1:dimension;
    rest_i=~(index==i);
    rest_X=data(:,rest_i);
    for k=1:dimension-1        
        tem_MDis(k)=MDis_func(X,rest_X(:,k));
    end
    MDis(i)=sum(tem_MDis)/(dimension-1);
    mRel_MDis(i)=(wr*mRel(i)+wd*MDis(i));
end

ori_beta=mRel_MDis;
abs_beta=abs(ori_beta);
[score weight]=sort(abs_beta);
weight=weight';
end

%% Calculate the maximum MD distance
function MDis=MDis_func(X,Y)
    num=size(X,1);
% Calculate ED
    for j=1:num
        tem_ED(j)=(X(j)-Y(j))^2;
        tem_L2_X(j)=X(j).^2;
        tem_L2_Y(j)=Y(j).^2;
    end
    ED=sqrt(sum(tem_ED));
% Calculate COS
    L2_X=sqrt(sum(tem_L2_X));
    L2_Y=sqrt(sum(tem_L2_Y));   
    COS=sum(X.*Y)/(L2_X*L2_Y);
% Calculate TC
    TC=sum(X.*Y)/(L2_X^2+L2_Y^2-sum(X.*Y));
    
    MDis=(ED+COS+TC)/3;
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
    cmd = [' -t ', num2str(0),' -c ',num2str( basenum^X(1,x))];
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
    if ( tem_Acc == bestAcc && bestc > basenum^X(1,x) )
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
