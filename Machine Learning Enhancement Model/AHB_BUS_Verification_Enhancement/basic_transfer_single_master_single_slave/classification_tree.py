import pandas as pd                   # to load and manipulate data and for one hot encoding
import numpy as np                    # to calculate mean and standard deviation
import matplotlib.pyplot as plot        # to draw graphs
import sklearn.tree as tree            # for classifaction trees (you may need to omport only some functions)
import sklearn.model_selection as model_selection
import sklearn.metrics as metrics
from sklearn.preprocessing import MinMaxScaler
from time import process_time
starting_time=process_time()

#%% Load Training CSV File
training_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/to_python/training/basic_transfer_single_master_single_slave.csv',sep=',')
training_file=training_file.sample(frac=1,random_state=31).reset_index(drop=True) #shuffle

#%% Check Dataframe types
training_file_data_types=training_file.dtypes
print(training_file['Coverage'].unique())

#%% Divide Data
x=training_file.drop(columns=['Coverage'],axis=1).copy()   #to make a deep copy (not by reference)
y=training_file.loc[:,['Coverage']].copy()
my_scalar=MinMaxScaler()
strings=["M_HADDR","M_HWDATA"]         # array of columns' names that must be scalled
for string in strings:
    my_scalar.fit(x[[string]])
    x[string]=my_scalar.transform(x[[string]])

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

#%% Pruning
path=classification_tree.cost_complexity_pruning_path(x_train, y_train)
ccp_alphas=path.ccp_alphas
ccp_alphas=ccp_alphas[:-1]
classification_trees=[]
for ccp_alpha in ccp_alphas:
    classification_tree=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ccp_alpha)
    classification_tree.fit(x_train, y_train)
    classification_trees.append(classification_tree)
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
ideal_ccp_alpha=7.37311e-05
 #from graph

#%% Final constructing of tree
pruned_classification_tree=tree.DecisionTreeClassifier(random_state=31,ccp_alpha=ideal_ccp_alpha)
pruned_classification_tree.fit(x_train, y_train)
result=pruned_classification_tree.predict(x_test)
print("Accuracy:",metrics.accuracy_score(y_test, result))
plot.figure(figsize=(25,7.5))
tree.plot_tree(pruned_classification_tree,filled=True,rounded=True,feature_names=x.columns);

#%% Load & Predict Prediction CSV File
prediction_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/to_python/prediction/basic_transfer_single_master_single_slave.csv',sep=',')
x_prediction=prediction_file.copy()
for string in strings:
    my_scalar.fit(x_prediction[[string]])
    x_prediction[string]=my_scalar.transform(x_prediction[[string]])
prediction_result=pruned_classification_tree.predict(x_prediction)
for string in strings:                                              
    x_prediction[string]=prediction_file[string]
x_prediction['Coverage']=prediction_result
x_prediction.sort_values(by="Coverage",axis=0,inplace=True, ascending=False)
x_prediction.reset_index(drop=True, inplace=True)
x_prediction.drop(columns=["Coverage"],axis=1, inplace=True)
#%% Create CSV file for verification
x_prediction.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/no_cluster/basic_transfer_single_master_single_slave.csv', index=False)
finishing_time=process_time()
print("simulation_cycles_consumed=", (finishing_time-starting_time))


