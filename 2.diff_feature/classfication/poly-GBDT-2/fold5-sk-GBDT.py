import scipy.io as scio
from matplotlib import pyplot as plt
from sklearn.ensemble import GradientBoostingClassifier
import numpy as np
from sklearn.externals import joblib

#scio.savemat('saveddata.mat', {'xi': test_label})
dataFile = r'C:\workspace\PycharmProjects\poly\poly-GBDT-2\pstnp.mat'
data = scio.loadmat(dataFile)
X=data['pstnp']

labelFile=r'C:\workspace\PycharmProjects\poly\poly-GBDT-2\label.mat'
label=scio.loadmat(labelFile)

y=label['label']
rankFile = r'C:\workspace\PycharmProjects\poly\poly-GBDT-2\indices.mat'

indices= scio.loadmat(rankFile)
indices=indices['indices']

Sn=[];Sp=[];Acc=[];MCC=[];

for k in range(1,6):
    # 5-flod
    X_train=[];X_test=[];y_train=[];y_test=[];
    for i in range(len(indices)):
        if indices[i]==1:
            y_test.append(y[i])
            X_test.append(X[i])
        if indices[i]!=1:
            y_train.append(y[i])
            X_train.append(X[i])
    X_train=np.array(X_train);X_test=np.array(X_test)
    y_train=np.array(y_train);y_test=np.array(y_test)
    # training model
    gb = GradientBoostingClassifier(learning_rate=0.2, n_estimators=1930,
                max_depth=13,min_samples_split =120,min_samples_leaf =120, subsample=0.3)
    
    gb.fit(X_train,y_train)
    ans = gb.predict(X_test)
    joblib.dump(gb,'GBDT-pstnp.model')


    # evaluation
    TP=0;FN=0;FP=0;TN=0
    for i in range(len(y_test)):
        if ans[i]==1 and y_test[i]==1:
            TP+=1
        if ans[i]==0 and y_test[i]==1:
            FN+=1
        if ans[i]==1 and y_test[i]==0:
            FP+=1
        if ans[i]==0 and y_test[i]==0:
            TN+=1
    Sn.append(TP/(TP+FN))
    Sp.append(TN/(TN+FP))
    Acc.append((TP+TN)/(TP+TN+FP+FN))
    MCC.append((TP*TN-FP*FN)/(((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN)))**0.5)
    
total=np.row_stack((Sn,Sp,Acc,MCC))
print(total.mean(axis=1))
