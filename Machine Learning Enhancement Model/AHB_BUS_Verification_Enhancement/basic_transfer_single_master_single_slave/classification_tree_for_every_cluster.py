import pandas as pd                                    
import matplotlib.pyplot as plot      
import numpy as np                    # to calculate mean and standard deviation
import sklearn.tree as tree            
import sklearn.model_selection as model_selection
import sklearn.metrics as metrics
from time import process_time
starting_time=process_time()

#%% Load & Divide Clusters of Training/Prediction CSV File
training_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/basic_transfer_single_master_single_slave/training_data_after_cluster.csv',sep=',')
prediction_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/basic_transfer_single_master_single_slave/prediction_data_after_cluster.csv',sep=',')
print(training_file['Cluster'].unique())
cluster0_training= training_file[training_file.Cluster== 0].reset_index(drop=True)
cluster1_training= training_file[training_file.Cluster== 1].reset_index(drop=True)
cluster2_training= training_file[training_file.Cluster== 2].reset_index(drop=True)
cluster3_training= training_file[training_file.Cluster== 3].reset_index(drop=True)
cluster0_training=cluster0_training.sample(frac=1,random_state=31).reset_index(drop=True) #shuffle
cluster1_training=cluster1_training.sample(frac=1,random_state=31).reset_index(drop=True)
cluster2_training=cluster2_training.sample(frac=1,random_state=31).reset_index(drop=True)
cluster3_training=cluster3_training.sample(frac=1,random_state=31).reset_index(drop=True)

cluster0_prediction=prediction_file[prediction_file.Cluster== 0].reset_index(drop=True)
cluster1_prediction=prediction_file[prediction_file.Cluster== 1].reset_index(drop=True)
cluster2_prediction=prediction_file[prediction_file.Cluster== 2].reset_index(drop=True)
cluster3_prediction=prediction_file[prediction_file.Cluster== 3].reset_index(drop=True)
cluster0_prediction=cluster0_prediction.sample(frac=1,random_state=31).reset_index(drop=True) #shuffle
cluster1_prediction=cluster1_prediction.sample(frac=1,random_state=31).reset_index(drop=True)
cluster2_prediction=cluster2_prediction.sample(frac=1,random_state=31).reset_index(drop=True)
cluster3_prediction=cluster3_prediction.sample(frac=1,random_state=31).reset_index(drop=True)

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

# #%% Pruning
# path=classification_tree0.cost_complexity_pruning_path(x_train, y_train)
# ccp_alphas=path.ccp_alphas
# ccp_alphas=ccp_alphas[:-1]
# classification_trees=[]
# for ccp_alpha in ccp_alphas:
#     classification_tree=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ccp_alpha)
#     classification_tree.fit(x_train, y_train)
#     classification_trees.append(classification_tree0)
# train_scores=[classification_tree.score(x_train, y_train) for classification_tree in classification_trees]
# test_scores=[classification_tree.score(x_test, y_test) for classification_tree in classification_trees]

# #%% Plot
# fig, ax= plot.subplots()
# ax.set_xlabel('alpha')
# ax.set_ylabel('accuracy')
# ax.set_title('Accuracy vs Alpha')
# ax.plot(ccp_alphas,train_scores,marker='o',label='train',drawstyle='steps-post')
# ax.plot(ccp_alphas,test_scores,marker='o',label="test",drawstyle="steps-post")
# ax.legend()
# plot.show()

# #%% Cross Validation for all alphas, check mean & standard deviation of accuracy and choose the best one
# alpha_loop_values=[]
# for ccp_alpha in ccp_alphas:
#     classification_tree=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ccp_alpha)
#     scores=model_selection.cross_val_score(classification_tree,x_train,y_train,cv=5)
#     alpha_loop_values.append([ccp_alpha, np.mean(scores), np.std(scores)]) 
# alpha_results=pd.DataFrame(alpha_loop_values,columns=['alpha','mean_accuracy',"standard_deviation"])
# alpha_results.plot(x='alpha',y='mean_accuracy',yerr='standard_deviation',marker='o',linestyle='--')   #yerr for error bar (standard deviation of accuracy values). The shorter (less spread) the better
# #%% Get best alpha (SEARCH AN AUTO WAY TO GET THE BEST ALPHA)
# ideal_ccp_alpha=0.0002942
#   #from graph

# #%% Final constructing of tree
# pruned_classification_tree0=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ideal_ccp_alpha)
# pruned_classification_tree0.fit(x_train, y_train)
# result=pruned_classification_tree0.predict(x_test)
# print("Accuracy:",metrics.accuracy_score(y_test, result))
# plot.figure(figsize=(15,7.5))
# tree.plot_tree(pruned_classification_tree0,filled=True,rounded=True,feature_names=x.columns);

#%% Prepare & Predict Prediction Data
x_prediction=cluster0_prediction.drop(columns=['Cluster'],axis=1).copy()
prediction_result=classification_tree0.predict(x_prediction)
x_prediction['Coverage']=prediction_result
x_prediction.sort_values(by="Coverage",axis=0,inplace=True, ascending=False)
x_prediction.reset_index(drop=True,inplace=True)
x_prediction.drop(columns=["Coverage"],axis=1, inplace=True)
#%% Export Data to CSV
x_prediction.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/basic_transfer_single_master_single_slave/cluster0_predicted_data.csv', index=False)

#TREE FOR CLUSTER 1
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

# #%% Pruning
# path=classification_tree1.cost_complexity_pruning_path(x_train, y_train)
# ccp_alphas=path.ccp_alphas
# ccp_alphas=ccp_alphas[:-1]
# classification_trees=[]
# for ccp_alpha in ccp_alphas:
#     classification_tree=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ccp_alpha)
#     classification_tree.fit(x_train, y_train)
#     classification_trees.append(classification_tree0)
# train_scores=[classification_tree.score(x_train, y_train) for classification_tree in classification_trees]
# test_scores=[classification_tree.score(x_test, y_test) for classification_tree in classification_trees]

# #%% Plot
# fig, ax= plot.subplots()
# ax.set_xlabel('alpha')
# ax.set_ylabel('accuracy')
# ax.set_title('Accuracy vs Alpha')
# ax.plot(ccp_alphas,train_scores,marker='o',label='train',drawstyle='steps-post')
# ax.plot(ccp_alphas,test_scores,marker='o',label="test",drawstyle="steps-post")
# ax.legend()
# plot.show()

# #%% Cross Validation for all alphas, check mean & standard deviation of accuracy and choose the best one
# alpha_loop_values=[]
# for ccp_alpha in ccp_alphas:
#     classification_tree=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ccp_alpha)
#     scores=model_selection.cross_val_score(classification_tree,x_train,y_train,cv=5)
#     alpha_loop_values.append([ccp_alpha, np.mean(scores), np.std(scores)]) 
# alpha_results=pd.DataFrame(alpha_loop_values,columns=['alpha','mean_accuracy',"standard_deviation"])
# alpha_results.plot(x='alpha',y='mean_accuracy',yerr='standard_deviation',marker='o',linestyle='--')   #yerr for error bar (standard deviation of accuracy values). The shorter (less spread) the better
# #%% Get best alpha (SEARCH AN AUTO WAY TO GET THE BEST ALPHA)
# ideal_ccp_alpha=0.000296607
#   #from graph

# #%% Final constructing of tree
# pruned_classification_tree1=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ideal_ccp_alpha)
# pruned_classification_tree1.fit(x_train, y_train)
# result=pruned_classification_tree1.predict(x_test)
# print("Accuracy:",metrics.accuracy_score(y_test, result))
# plot.figure(figsize=(15,7.5))
# tree.plot_tree(pruned_classification_tree1,filled=True,rounded=True,feature_names=x.columns);

#%% Prepare & Predict Prediction Data
x_prediction=cluster1_prediction.drop(columns=['Cluster'],axis=1).copy()
prediction_result=classification_tree1.predict(x_prediction)
x_prediction['Coverage']=prediction_result
x_prediction.sort_values(by="Coverage",axis=0,inplace=True, ascending=False)
x_prediction.reset_index(drop=True,inplace=True)
x_prediction.drop(columns=["Coverage"],axis=1, inplace=True)
#%% Export Data to CSV
x_prediction.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/basic_transfer_single_master_single_slave/cluster1_predicted_data.csv', index=False)

#TREE FOR CLUSTER 2
#%% Prepare Data
x=cluster2_training.drop(columns=['Coverage','Cluster'],axis=1).copy()   #to make a deep copy (not by reference)
y=cluster2_training.loc[:,['Coverage']].copy()
x_train, x_test, y_train, y_test =model_selection.train_test_split(x, y, random_state=31)  
x_train.reset_index(drop=True,inplace=True) 
y_train.reset_index(drop=True,inplace=True)
x_test.reset_index(drop=True,inplace=True)
y_test.reset_index(drop=True,inplace=True)

#%% Create, Train & Plot Tree
classification_tree2=tree.DecisionTreeClassifier(random_state=31,criterion='entropy')   #put the cursor on the function name, and check the parameters of the tree
classification_tree2=classification_tree2.fit(x_train, y_train)
plot.figure(figsize=(15,7.5))
tree.plot_tree(classification_tree2,filled=True,rounded=True, feature_names=x.columns) #class names only for 2 categories outputs
test_result=classification_tree2.predict(x_test)
print('Accuracy:',metrics.accuracy_score(y_test, test_result))

# #%% Pruning
# path=classification_tree2.cost_complexity_pruning_path(x_train, y_train)
# ccp_alphas=path.ccp_alphas
# ccp_alphas=ccp_alphas[:-1]
# classification_trees=[]
# for ccp_alpha in ccp_alphas:
#     classification_tree=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ccp_alpha)
#     classification_tree.fit(x_train, y_train)
#     classification_trees.append(classification_tree0)
# train_scores=[classification_tree.score(x_train, y_train) for classification_tree in classification_trees]
# test_scores=[classification_tree.score(x_test, y_test) for classification_tree in classification_trees]

# #%% Plot
# fig, ax= plot.subplots()
# ax.set_xlabel('alpha')
# ax.set_ylabel('accuracy')
# ax.set_title('Accuracy vs Alpha')
# ax.plot(ccp_alphas,train_scores,marker='o',label='train',drawstyle='steps-post')
# ax.plot(ccp_alphas,test_scores,marker='o',label="test",drawstyle="steps-post")
# ax.legend()
# plot.show()

# #%% Cross Validation for all alphas, check mean & standard deviation of accuracy and choose the best one
# alpha_loop_values=[]
# for ccp_alpha in ccp_alphas:
#     classification_tree=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ccp_alpha)
#     scores=model_selection.cross_val_score(classification_tree,x_train,y_train,cv=5)
#     alpha_loop_values.append([ccp_alpha, np.mean(scores), np.std(scores)]) 
# alpha_results=pd.DataFrame(alpha_loop_values,columns=['alpha','mean_accuracy',"standard_deviation"])
# alpha_results.plot(x='alpha',y='mean_accuracy',yerr='standard_deviation',marker='o',linestyle='--')   #yerr for error bar (standard deviation of accuracy values). The shorter (less spread) the better
# #%% Get best alpha (SEARCH AN AUTO WAY TO GET THE BEST ALPHA)
# ideal_ccp_alpha=0.0000313897
#   #from graph

# #%% Final constructing of tree
# pruned_classification_tree2=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ideal_ccp_alpha)
# pruned_classification_tree2.fit(x_train, y_train)
# result=pruned_classification_tree2.predict(x_test)
# print("Accuracy:",metrics.accuracy_score(y_test, result))
# plot.figure(figsize=(15,7.5))
# tree.plot_tree(pruned_classification_tree2,filled=True,rounded=True,feature_names=x.columns);

#%% Prepare & Predict Prediction Data
x_prediction=cluster2_prediction.drop(columns=['Cluster'],axis=1).copy()
prediction_result=classification_tree2.predict(x_prediction)
x_prediction['Coverage']=prediction_result
x_prediction.sort_values(by="Coverage",axis=0,inplace=True, ascending=False)
x_prediction.reset_index(drop=True,inplace=True)
x_prediction.drop(columns=["Coverage"],axis=1, inplace=True)
#%% Export Data to CSV
x_prediction.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/basic_transfer_single_master_single_slave/cluster2_predicted_data.csv', index=False)

#TREE FOR CLUSTER 3
#%% Prepare Data
x=cluster3_training.drop(columns=['Coverage','Cluster'],axis=1).copy()   #to make a deep copy (not by reference)
y=cluster3_training.loc[:,['Coverage']].copy()
x_train, x_test, y_train, y_test =model_selection.train_test_split(x, y, random_state=31)  
x_train.reset_index(drop=True,inplace=True) 
y_train.reset_index(drop=True,inplace=True)
x_test.reset_index(drop=True,inplace=True)
y_test.reset_index(drop=True,inplace=True)

#%% Create, Train & Plot Tree
classification_tree3=tree.DecisionTreeClassifier(random_state=31,criterion='entropy')   #put the cursor on the function name, and check the parameters of the tree
classification_tree3=classification_tree3.fit(x_train, y_train)
plot.figure(figsize=(15,7.5))
tree.plot_tree(classification_tree3,filled=True,rounded=True, feature_names=x.columns) #class names only for 2 categories outputs
test_result=classification_tree3.predict(x_test)
print('Accuracy:',metrics.accuracy_score(y_test, test_result))

#%% Pruning
path=classification_tree3.cost_complexity_pruning_path(x_train, y_train)
ccp_alphas=path.ccp_alphas
ccp_alphas=ccp_alphas[:-1]
classification_trees=[]
for ccp_alpha in ccp_alphas:
    classification_tree=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ccp_alpha)
    classification_tree.fit(x_train, y_train)
    classification_trees.append(classification_tree0)
train_scores=[classification_tree.score(x_train, y_train) for classification_tree in classification_trees]
test_scores=[classification_tree.score(x_test, y_test) for classification_tree in classification_trees]

#%% Plot
fig, ax= plot.subplots()
ax.set_xlabel('alpha')
ax.set_ylabel('accuracy')
ax.set_title('Accuracy vs Alpha')
ax.plot(ccp_alphas,train_scores,marker='o',label='train',drawstyle='steps-post')
ax.plot(ccp_alphas,test_scores,marker='o',label="test",drawstyle="steps-post")
ax.legend()
plot.show()

#%% Cross Validation for all alphas, check mean & standard deviation of accuracy and choose the best one
alpha_loop_values=[]
for ccp_alpha in ccp_alphas:
    classification_tree=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ccp_alpha)
    scores=model_selection.cross_val_score(classification_tree,x_train,y_train,cv=5)
    alpha_loop_values.append([ccp_alpha, np.mean(scores), np.std(scores)]) 
alpha_results=pd.DataFrame(alpha_loop_values,columns=['alpha','mean_accuracy',"standard_deviation"])
alpha_results.plot(x='alpha',y='mean_accuracy',yerr='standard_deviation',marker='o',linestyle='--')   #yerr for error bar (standard deviation of accuracy values). The shorter (less spread) the better
#%% Get best alpha (SEARCH AN AUTO WAY TO GET THE BEST ALPHA)
ideal_ccp_alpha=0.000298213
  #from graph

#%% Final constructing of tree
pruned_classification_tree3=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ideal_ccp_alpha)
pruned_classification_tree3.fit(x_train, y_train)
result=pruned_classification_tree3.predict(x_test)
print("Accuracy:",metrics.accuracy_score(y_test, result))
plot.figure(figsize=(15,7.5))
tree.plot_tree(pruned_classification_tree3,filled=True,rounded=True,feature_names=x.columns);

#%% Prepare & Predict Prediction Data
x_prediction=cluster3_prediction.drop(columns=['Cluster'],axis=1).copy()
prediction_result=classification_tree3.predict(x_prediction)
x_prediction['Coverage']=prediction_result
x_prediction.sort_values(by="Coverage",axis=0,inplace=True, ascending=False)
x_prediction.reset_index(drop=True,inplace=True)
x_prediction.drop(columns=["Coverage"],axis=1, inplace=True)
#%% Export Data to CSV
x_prediction.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/basic_transfer_single_master_single_slave/cluster3_predicted_data.csv', index=False)
finishing_time=process_time()
print("simulation_cycles_consumed=", (finishing_time-starting_time))



