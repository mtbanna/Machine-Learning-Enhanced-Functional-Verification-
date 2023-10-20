import pandas as pd                   # to load and manipulate data and for one hot encoding
import numpy as np                    # to calculate mean and standard deviation
import matplotlib.pyplot as plot        # to draw graphs
import sklearn.tree as tree            # for classifaction trees (you may need to omport only some functions)
import sklearn.model_selection as model_selection
import sklearn.metrics as metrics
from time import process_time
starting_time=process_time()

#%% Load Training CSV File
training_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/to_python/training/bus_request.csv',sep=',')
training_file=training_file.sample(frac=1,random_state=31).reset_index(drop=True) #shuffle

#%% Check Dataframe types
training_file_data_types=training_file.dtypes
print(training_file['Coverage'].unique())

#%% Divide Data
x=training_file.drop(columns=['Coverage'],axis=1).copy()   #to make a deep copy (not by reference)
y=training_file.loc[:,['Coverage']].copy()

#%% Assign train & test data
x_train, x_test, y_train, y_test =model_selection.train_test_split(x, y, random_state=31)  #package.module.function
x_train.reset_index(drop=True,inplace=True) 
y_train.reset_index(drop=True,inplace=True)
x_test.reset_index(drop=True,inplace=True)
y_test.reset_index(drop=True,inplace=True)
classification_tree=tree.DecisionTreeClassifier(random_state=31,criterion='entropy')   #put the cursor on the function name, and check the parameters of the tree
classification_tree=classification_tree.fit(x_train, y_train)

#%% Plot first tree 
plot.figure(figsize=(15,7.5))
tree.plot_tree(classification_tree,filled=True,rounded=True, feature_names=x.columns) #class names only for 2 categories outputs
test_result=classification_tree.predict(x_test)
metrics.plot_confusion_matrix(classification_tree,x_test,y_test,display_labels=['no hit','hits']) #supported only for 2 categories outputs
print('Accuracy:',metrics.accuracy_score(y_test, test_result))

#no pruning, as we only have one split

#%% Load & Predict Prediction CSV File
prediction_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/to_python/prediction/bus_request.csv',sep=',')
x_prediction=prediction_file.copy()
prediction_result=classification_tree.predict(x_prediction)
x_prediction['Coverage']=prediction_result
x_prediction.sort_values(by="Coverage",axis=0,inplace=True, ascending=False)
x_prediction.reset_index(drop=True, inplace=True)
x_prediction.drop(columns=["Coverage"],axis=1, inplace=True)
#%%
x_prediction.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/no_cluster/bus_request.csv', index=False)
finishing_time=process_time()
print("simulation_cycles_consumed=", (finishing_time-starting_time))























