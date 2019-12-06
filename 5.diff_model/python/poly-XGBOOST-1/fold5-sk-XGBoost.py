import scipy.io as scio
import xgboost as xgb
from matplotlib import pyplot as plt
import numpy as np
from sklearn.externals import joblib

# scio.savemat('saveddata.mat', {'xi': test_label})
dataFile = r'C:\workspace\PycharmProjects\task-2019-9-11\poly-XGBOOST-1\pstnp.mat'
data = scio.loadmat(dataFile)
X = data['pstnp']
labelFile = r'C:\workspace\PycharmProjects\task-2019-9-11\poly-XGBOOST-1\label.mat'
label = scio.loadmat(labelFile)
y = label['label']
rankFile = r'C:\workspace\PycharmProjects\task-2019-9-11\poly-XGBOOST-1\indices.mat'
indices = scio.loadmat(rankFile)
indices = indices['indices']

Sn = [];
Sp = [];
Acc = [];
MCC = [];

for k in range(1, 6):
    # 5-flod
    X_train = [];
    X_test = [];
    y_train = [];
    y_test = [];
    for i in range(len(indices)):
        if indices[i] == 1:
            y_test.append(y[i])
            X_test.append(X[i])
        if indices[i] != 1:
            y_train.append(y[i])
            X_train.append(X[i])
    X_train = np.array(X_train);
    X_test = np.array(X_test)
    y_train = np.array(y_train);
    y_test = np.array(y_test)
    # training model
'''
    params = {'learning_rate':0.01,'n_estimators': 40, 'max_depth': 9, 'min_child_weight': 5, 
              'seed': 0,'subsample': 0.6, 'colsample_bytree': 0.6, 'gamma': 0.1, 
              'reg_alpha': 0.5, 'reg_lambda': 0.03}     #pstnp

    params = {'learning_rate':0.01,'n_estimators': 70, 'max_depth': 9, 'min_child_weight': 2,
              'seed': 0,'subsample': 0.4, 'colsample_bytree': 0.2, 'gamma': 0.7,
              'reg_alpha': 0.5, 'reg_lambda': 0.008}  # t_p
    
    params = {'learning_rate':0.01,'n_estimators': 60, 'max_depth': 7, 'min_child_weight': 2,
                    'seed': 0, 'subsample': 0.4, 'colsample_bytree': 0.2, 'gamma': 0.5,
                    'reg_alpha': 0.5, 'reg_lambda': 0.001}  # t_m

params = {'learning_rate': 0.01, 'n_estimators': 80, 'max_depth': 6, 'min_child_weight': 2,
          'seed': 0, 'subsample': 0.4, 'colsample_bytree': 0.2, 'gamma': 0.7,
          'reg_alpha': 0.5, 'reg_lambda': 0.01}  # psKNC

params = {'learning_rate': 0.01, 'n_estimators': 200, 'max_depth': 2, 'min_child_weight': 10,
                    'seed': 0, 'subsample': 0.4, 'colsample_bytree': 0.2, 'gamma': 0.1,
                    'reg_alpha': 0.5, 'reg_lambda': 0.01}  # ATGC

params = {'learning_rate': 0.0008, 'n_estimators': 140, 'max_depth': 4, 'min_child_weight': 5,
          'seed': 0, 'subsample': 0.4,'colsample_bytree': 0.2, 'gamma': 0.01,
          'reg_alpha': 0.5, 'reg_lambda': 0.03}  # pseEIIP
'''
params = {'learning_rate': 0.0008, 'n_estimators': 1480, 'max_depth': 7,
                    'min_child_weight': 5,'seed': 0, 'subsample': 0.4,
                    'colsample_bytree': 0.2, 'gamma': 0.01,'reg_alpha': 0.05, 'reg_lambda': 0.0001}  # pseEIIP

model = xgb.XGBClassifier(**params)
XGB = model.fit(X_train, y_train)
ans = XGB.predict(X_test)
joblib.dump(XGB, 'XGBoost-pstnp.model')

# evaluation
TP = 0;
FN = 0;
FP = 0;
TN = 0
for i in range(len(y_test)):
    if ans[i] == 1 and y_test[i] == 1:
        TP += 1
    if ans[i] == 0 and y_test[i] == 1:
        FN += 1
    if ans[i] == 1 and y_test[i] == 0:
        FP += 1
    if ans[i] == 0 and y_test[i] == 0:
        TN += 1
Sn.append(TP / (TP + FN))
Sp.append(TN / (TN + FP))
Acc.append((TP + TN) / (TP + TN + FP + FN))
MCC.append((TP * TN - FP * FN) / (((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN))) ** 0.5)

total = np.row_stack((Sn, Sp, Acc, MCC))
print(total.mean(axis=1))
