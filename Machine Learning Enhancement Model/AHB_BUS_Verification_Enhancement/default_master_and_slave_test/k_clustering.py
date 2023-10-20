from sklearn.cluster import KMeans
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from matplotlib import pyplot as plt
import sklearn.model_selection as model_selection
from time import time
starting_time=time()

#%% Read Data
training_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/to_python/training/default_master_and_slave.csv',sep=',')
training_file=training_file.sample(frac=1,random_state=31).reset_index(drop=True) #shuffle

#%% Check Dataframe types
training_file_data_types=training_file.dtypes
print(training_file['Coverage'].unique())

#%% Divide Data
x=training_file.drop(columns=['Coverage'],axis=1).copy()   #to make a deep copy (not by reference)
y=training_file.loc[:,['Coverage']].copy()   # not used here (unsupervised algorithm)

#%% Scalling Parameters
my_scalar=MinMaxScaler()
strings=["M_HADDR","M_HBURST","M_HWDATA"]         # array of columns' names that must be scalled
for string in strings:
    my_scalar.fit(x[[string]])
    x[string]=my_scalar.transform(x[[string]])
    
#%% Determining number of clusters   
SSEs=[]              # Sum of Square Error     
for i in range(1,10):
    k_model=KMeans(n_clusters=i, random_state=31, algorithm='auto')
    training_data_cluster=k_model.fit_predict(x)
    SSEs.append([i, k_model.inertia_])    
SSE_vs_clusters=pd.DataFrame(SSEs,columns=['N_Clusters','SSE'])
SSE_vs_clusters.plot(x='N_Clusters',y='SSE')
# From graph, using the elbow method, 4 is a good n_cluster
#%% Final KMean Model
k_model=KMeans(n_clusters=4, random_state=31, algorithm='auto')
training_data_cluster=k_model.fit_predict(x)
training_data_after_cluster=x.copy()
for string in strings:                                              
    training_data_after_cluster[string]=training_file[string]

training_data_after_cluster['Cluster']=training_data_cluster
training_data_after_cluster['Coverage']=y

#%% Load & Predict Prediction CSV File
prediction_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/to_python/prediction/default_master_and_slave.csv',sep=',')
x_prediction=prediction_file.copy()
for string in strings:                               #scale for prediction
    my_scalar.fit(x_prediction[[string]])
    x_prediction[string]=my_scalar.transform(x_prediction[[string]])
cluster_prediction=k_model.predict(x_prediction)
for string in strings:                               #unscale after prediction               
    x_prediction[string]=prediction_file[string]
x_prediction['Cluster']=cluster_prediction

#%% Export Prediction and Training Data after Clustering
x_prediction.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/default_master_and_slave/prediction_data_after_cluster.csv', index=False)
starting_time=time()
training_data_after_cluster.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/default_master_and_slave/training_data_after_cluster.csv', index=False)
finishing_time=time()
print("simulation_cycles_consumed=", (finishing_time-starting_time))

