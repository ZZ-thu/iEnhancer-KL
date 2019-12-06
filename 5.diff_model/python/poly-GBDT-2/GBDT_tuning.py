import pandas as pd
import numpy as np
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.model_selection import GridSearchCV
import matplotlib.pylab as plt
import scipy.io as scio

dataFile = r'C:\workspace\PycharmProjects\task-2019-9-01\poly-GBDT-2\pstnp.mat'
data = scio.loadmat(dataFile)
X=data['pstnp']

labelFile=r'C:\workspace\PycharmProjects\task-2019-9-01\poly-GBDT-2\label.mat'
label=scio.loadmat(labelFile)

y=label['label']
rankFile = r'C:\workspace\PycharmProjects\task-2019-9-01\poly-GBDT-2\indices.mat'

indices= scio.loadmat(rankFile)
indices=indices['indices']

X_train=[];X_test=[];y_train=[];y_test=[];
# 5-flod
for i in range(len(indices)):
    if indices[i]==1:
        y_test.append(y[i])
        X_test.append(X[i])
    if indices[i]!=1:
        y_train.append(y[i])
        X_train.append(X[i])
X_train=np.array(X_train);  X_test=np.array(X_test)
y_train=np.array(y_train);  y_test=np.array(y_test)

##{'n_estimators':range(100,1001,100)}
##{'max_depth':range(1,15,2),'min_samples_split':range(100,801,200)}
##{'min_samples_leaf':range(10,101,10), 'subsample':[0.6,0.7,0.8,0.9]}
##{'learning_rate': [0.01,0.05, 0.1,0.2,0.5,1]}

param_test = {'n_estimators': range(1500,2001,10)}
# param_test = {'max_depth':range(1,15,2),'min_samples_split':range(100,801,200)}
# param_test = {'min_samples_leaf':range(100,301,10), 'subsample':[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]}
# param_test = {'learning_rate': [0.01,0.05, 0.1,0.2,0.5,1]}
gsearch = GridSearchCV(estimator = GradientBoostingClassifier(learning_rate=0.2, n_estimators=1810,
                max_depth=13,min_samples_split =120,min_samples_leaf =120, subsample=0.3),
               param_grid = param_test, scoring='accuracy',iid=False, cv=5)
gsearch.fit(X,y)

    
print('Results of each round of iteration:{0}'.format(gsearch.cv_results_))
print('The best value of the parameter:{0}'.format(gsearch.best_params_))
print('Best model score:{0}'.format(gsearch.best_score_))

