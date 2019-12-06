import scipy.io as scio
import xgboost as xgb
from matplotlib import pyplot as plt
import numpy as np
from sklearn.externals import joblib

#scio.savemat('saveddata.mat', {'xi': test_label})
dataFile = r'C:\workspace\PycharmProjects\poly-XGBOOST-2\data_lasso.mat'
data = scio.loadmat(dataFile)
X=data['data_lasso']
labelFile=r'C:\workspace\PycharmProjects\poly-XGBOOST-2\label.mat'
label=scio.loadmat(labelFile)
y=label['label']
rankFile = r'C:\workspace\PycharmProjects\poly-XGBOOST-2\indices.mat'
indices= scio.loadmat(rankFile)
indices=indices['indices']

Sn=[];Sp=[];Acc=[];MCC=[];

for k in range(1,6):
    # 5-fold
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
    '''
    params = {'learning_rate': 0.0008, 'n_estimators': 450, 'max_depth': 2,
                    'min_child_weight': 15,'seed': 0, 'subsample': 0.4,
                    'colsample_bytree': 0.2, 'gamma': 0.001,'reg_alpha': 0.5, 'reg_lambda': 0.0001} #ATGC
    
    params = {'learning_rate': 0.0008, 'n_estimators': 110, 'max_depth': 3,
                    'min_child_weight': 8,'seed': 0, 'subsample': 0.4,
                    'colsample_bytree': 0.2, 'gamma': 0.001,'reg_alpha': 0.5, 'reg_lambda': 0.001} #t_p
'''
    params = {'learning_rate': 0.0008, 'n_estimators': 480, 'max_depth': 8,
                    'min_child_weight': 1,'seed': 0, 'subsample': 0.25,
                    'colsample_bytree': 0.3, 'gamma': 0.001,'reg_alpha': 0.05, 'reg_lambda': 0.0004}  # data_lasso
    model = xgb.XGBClassifier(**params)
    XGB=model.fit(X_train, y_train)
    joblib.dump(XGB,'XGBoost-data_lasso.model')
    ans = XGB.predict(X_test)

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
