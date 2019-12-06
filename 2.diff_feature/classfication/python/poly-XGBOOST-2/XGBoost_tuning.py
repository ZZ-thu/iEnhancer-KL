
import xgboost as xgb
from matplotlib import pyplot as plt
from sklearn.model_selection import GridSearchCV
import scipy.io as scio
import numpy as np
import pandas as pd

# read in the data
dataFile = r'C:\workspace\PycharmProjects\task-2019-9-01\poly-XGBOOST-2\pstnp.mat'
data = scio.loadmat(dataFile)
X = data['pstnp']
labelFile = r'C:\workspace\PycharmProjects\task-2019-9-01\poly-XGBOOST-2\label.mat'
label = scio.loadmat(labelFile)
y = label['label']
rankFile = r'C:\workspace\PycharmProjects\task-2019-9-01\poly-XGBOOST-2\indices.mat'
indices = scio.loadmat(rankFile)
indices = indices['indices']

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

# model
##{'n_estimators': [100,200,300,400,500,600,700,800,900]}
##{'max_depth': [1,2,3,4,5,6,7,8,9,10],'min_child_weight': [1,2,3,4,5,6,7,8,9,10]}
##{'gamma': [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]}
##{'subsample': [0.6, 0.7, 0.8, 0.9], 'colsample_bytree': [0.6, 0.7, 0.8, 0.9]}
##{'reg_alpha': [0.05, 0.1,0.5, 1, 2, 3], 'reg_lambda': [0.05, 0.1,0.5, 1, 2, 3]}
##'learning_rate': [0.01,0.05,0.07,0.1,0.2,0.5,1]

if __name__ == '__main__':
    cv_params ={'n_estimators': range(1000,2001,10)}
    # cv_params = {'max_depth': [1,2,3,4,5,6,7,8,9,10],'min_child_weight': range(1,20,1)}
    # cv_params ={'gamma': [0.001, 0.003, 0.006, 0.008, 0.01, 0.02, 0.04, 0.08, 0.09, 0.1]}
    # cv_params ={'subsample': [0.2, 0.25, 0.3, 0.4], 'colsample_bytree': [0.1, 0.2, 0.3, 0.8]}
    # cv_params ={'reg_alpha': [0.05, 0.1,0.5, 1, 2, 3], 'reg_lambda': [0.0001, 0.0003,0.001, 0.003, 0.01, 0.03]}
    # cv_params = {'learning_rate': [0.0001, 0.0004, 0.0008, 0.001, 0.0014]}
    other_params = {'learning_rate': 0.0008, 'n_estimators': 1000, 'max_depth': 8,
                    'min_child_weight': 1,'seed': 0, 'subsample': 0.25,
                    'colsample_bytree': 0.3, 'gamma': 0.001,'reg_alpha': 0.05, 'reg_lambda': 0.0004}

    model = xgb.XGBClassifier(**other_params)
    optimized_GBM = GridSearchCV(estimator=model, param_grid=cv_params, scoring='accuracy', cv=5, verbose=1, n_jobs=4)
    optimized_GBM.fit(X_train, y_train)
    evalute_result = optimized_GBM.cv_results_

    print('best result:{0}'.format(evalute_result))
    print('best parameter:{0}'.format(optimized_GBM.best_params_))
    print('best grades of model:{0}'.format(optimized_GBM.best_score_))
