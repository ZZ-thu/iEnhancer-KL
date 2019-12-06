function [ Sn,Sp,Acc,MCC ] = perf( cp )
TP=cp.CountingMatrix(1,1);
FP=cp.CountingMatrix(1,2);
FN=cp.CountingMatrix(2,1);
TN=cp.CountingMatrix(2,2);
Sn=TP/(TP+FN);
Sp=TN/(TN+FP);
Acc=(TP+TN)/(TP+TN+FP+FN);
MCC=(TP*TN-FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
end

