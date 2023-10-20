import pandas as pd                                    
import matplotlib.pyplot as plot      
import numpy as np                    # to calculate mean and standard deviation
import sklearn.tree as tree            
import sklearn.model_selection as model_selection
import sklearn.metrics as metrics
from time import process_time
starting_time=process_time()

#%% Load & Divide Clusters of Training/Prediction CSV File
training_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/bus_request/training_data_after_cluster.csv',sep=',')
prediction_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/bus_request/prediction_data_after_cluster.csv',sep=',')
print(training_file['Cluster'].unique())
cluster0_training= training_file[training_file.Cluster== 0].reset_index(drop=True)
cluster1_training= training_file[training_file.Cluster== 1].reset_index(drop=True)
cluster0_training=cluster0_training.sample(frac=1,random_state=31).reset_index(drop=True) #shuffle
cluster1_training=cluster1_training.sample(frac=1,random_state=31).reset_index(drop=True)

cluster0_prediction=prediction_file[prediction_file.Cluster== 0].reset_index(drop=True)
cluster1_prediction=prediction_file[prediction_file.Cluster== 1].reset_index(drop=True)
cluster0_prediction=cluster0_prediction.sample(frac=1,random_state=31).reset_index(drop=True) #shuffle
cluster1_prediction=cluster1_prediction.sample(frac=1,random_state=31).reset_index(drop=True)

# TREE FOR CLUSTER 0
#%% Prepare Data
x=cluster0_training.drop(columns=['Coverage','Cluster'],axis=1).copy()   #to make a deep copy (not by reference)
y=cluster0_training.loc[:,['Coverage']].copy()
x_train, x_test, y_train, y_test =model_selection.train_test_split(x, y, random_state=31)  
x_train.reset_index(drop=True,inplace=True) 
y_train.reset_index(drop=True,inplace=True)
x_test.reset_index(drop=True,inplace=True)
y_test.reset_index(drop=True,inplace=True)

#%% Create, Train & Plot Tree
classification_tree0=tree.DecisionTreeClassifier(random_state=31,criterion='entropy')   #put the cursor on the function name, and check the parameters of the tree
classification_tree0=classification_tree0.fit(x_train, y_train)
plot.figure(figsize=(15,7.5))
tree.plot_tree(classification_tree0,filled=True,rounded=True, feature_names=x.columns) #class names only for 2 categories outputs
test_result=classification_tree0.predict(x_test)
print('Accuracy:',metrics.accuracy_score(y_test, test_result))
#no pruning, as we only have one node

#%% Prepare & Predict Prediction Data
x_prediction=cluster0_prediction.drop(columns=['Cluster'],axis=1).copy()
prediction_result=classification_tree0.predict(x_prediction)
x_prediction['Coverage']=prediction_result
x_prediction.sort_values(by="Coverage",axis=0,inplace=True, ascending=False)
x_prediction.reset_index(drop=True,inplace=True)
x_prediction.drop(columns=["Coverage"],axis=1, inplace=True)
#%% Export Data to CSV
x_prediction.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/bus_request/cluster0_predicted_data.csv', index=False)

# TREE FOR CLUSTER 1
#%% Prepare Data
x=cluster1_training.drop(columns=['Coverage','Cluster'],axis=1).copy()   #to make a deep copy (not by reference)
y=cluster1_training.loc[:,['Coverage']].copy()
x_train, x_test, y_train, y_test =model_selection.train_test_split(x, y, random_state=31)  
x_train.reset_index(drop=True,inplace=True) 
y_train.reset_index(drop=True,inplace=True)
x_test.reset_index(drop=True,inplace=True)
y_test.reset_index(drop=True,inplace=True)

#%% Create, Train & Plot Tree
classification_tree1=tree.DecisionTreeClassifier(random_state=31,criterion='entropy')   #put the cursor on the function name, and check the parameters of the tree
classification_tree1=classification_tree1.fit(x_train, y_train)
plot.figure(figsize=(15,7.5))
tree.plot_tree(classification_tree1,filled=True,rounded=True, feature_names=x.columns) #class names only for 2 categories outputs
test_result=classification_tree1.predict(x_test)
print('Accuracy:',metrics.accuracy_score(y_test, test_result))
#no pruning, as we only have one node

#%% Prepare & Predict Prediction Data
x_prediction=cluster1_prediction.drop(columns=['Cluster'],axis=1).copy()
prediction_result=classification_tree1.predict(x_prediction)
x_prediction['Coverage']=prediction_result
x_prediction.sort_values(by="Coverage",axis=0,inplace=True, ascending=False)
x_prediction.reset_index(drop=True,inplace=True)
x_prediction.drop(columns=["Coverage"],axis=1, inplace=True)
#%% Export Data to CSV
x_prediction.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/bus_request/cluster1_predicted_data.csv', index=False)
finishing_time=process_time()
print("simulation_cycles_consumed=", (finishing_time-starting_time))
