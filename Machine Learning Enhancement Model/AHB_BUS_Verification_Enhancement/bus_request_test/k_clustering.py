from sklearn.cluster import KMeans
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from matplotlib import pyplot as plt
import sklearn.model_selection as model_selection
from time import process_time
starting_time=process_time()

#%% Read Data
training_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/to_python/training/bus_request.csv',sep=',')
training_file=training_file.sample(frac=1,random_state=31).reset_index(drop=True) #shuffle

#%% Check Dataframe types
training_file_data_types=training_file.dtypes
print(training_file['Coverage'].unique())

#%% Scatter Plot   
plt.scatter(training_file['M_HBUSREQ'],training_file['M_HWRITE'])

#%% Divide Data
x=training_file.drop(columns=['Coverage'],axis=1).copy()   #to make a deep copy (not by reference)
y=training_file.loc[:,['Coverage']].copy()   # not used here (unsupervised algorithm)

#%% Kmean Model
# ADD MIN_MAX_SCALAR to scale values to [0:1] AND Sum of Square Error to find the best n_clusters
# in other files, as we don't need them here (k_model.inertia_ for SSE, then plot vs n_clusters) 
k_model=KMeans(n_clusters=2, random_state=31, algorithm='auto')
training_data_cluster=k_model.fit_predict(x)
training_data_after_cluster=x.copy()
training_data_after_cluster['Cluster']=training_data_cluster
training_data_after_cluster['Coverage']=y

#%% Load & Predict Prediction CSV File
prediction_file=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/to_python/prediction/bus_request.csv',sep=',')
x_prediction=prediction_file.copy()
cluster_prediction=k_model.predict(x_prediction)
x_prediction['Cluster']=cluster_prediction

#%% Export Prediction and Training Data after Clustering
x_prediction.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/bus_request/prediction_data_after_cluster.csv', index=False)
training_data_after_cluster.to_csv(path_or_buf='C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/bus_request/training_data_after_cluster.csv', index=False)
finishing_time=process_time()
print("simulation_cycles_consumed=", (finishing_time-starting_time))

