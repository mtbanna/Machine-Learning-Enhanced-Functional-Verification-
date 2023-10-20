import matplotlib.pyplot as plot  
import pandas as pd
import numpy as np
from sklearn.preprocessing import MinMaxScaler
#%% Universal Comparison
all_tests_comparison=pd.DataFrame(columns=["No ML","Total ML","ML Time","ML"],index=range(0,5))
i=0

# Bus Request Test
#%% Adjust Data
no_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/NO_MACHINE_LEARNING/bus_request_test/timing.csv',sep=',')
half_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/DECISION_TREES_ONLY/bus_request/timing.csv',sep=',')
full_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/FULL_MACHINE_LEARNING/bus_request/timing.csv',sep=',')

all_tests_comparison["No ML"][i]=no_machine_learning_results["Cycles"][3]
all_tests_comparison["ML"][i]=full_machine_learning_results["Cycles"][3]
all_tests_comparison["ML Time"][i]=full_machine_learning_results["ML"][0]


half_machine_learning_results["Cycles"][3]=half_machine_learning_results["Cycles"][3]+half_machine_learning_results["ML"][0]
full_machine_learning_results["Cycles"][3]=full_machine_learning_results["Cycles"][3]+full_machine_learning_results["ML"][0]

all_tests_comparison["Total ML"][i]=full_machine_learning_results["Cycles"][3]
i=i+1

#%% Plot 
fig, ax= plot.subplots()
ax.set_xlabel('Simulation Cycles  (x10e06)')
ax.set_ylabel('Coverage Percentage')
ax.set_title('Coverage Percentage vs Simulation Cycles')
ax.plot(no_machine_learning_results["Cycles"],no_machine_learning_results["Coverage Percentage"],marker='s',label='no_machine_learning',color='green')
ax.plot(half_machine_learning_results["Cycles"],half_machine_learning_results["Coverage Percentage"],marker='^',label='half_machine_learning',color='blue')
ax.plot(full_machine_learning_results["Cycles"],full_machine_learning_results["Coverage Percentage"],marker='o',label='full_machine_learning',color='red')
ax.legend()
plot.show()

#Default Master and Slave
#%% Adjust Data
no_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/NO_MACHINE_LEARNING/default_master_and_slave_test/timing.csv',sep=',')
half_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/DECISION_TREES_ONLY/default_master_and_slave/timing.csv',sep=',')
full_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/FULL_MACHINE_LEARNING/default_master_and_slave/timing.csv',sep=',')

all_tests_comparison["No ML"][i]=no_machine_learning_results["Cycles"][3]
all_tests_comparison["ML"][i]=full_machine_learning_results["Cycles"][3]
all_tests_comparison["ML Time"][i]=full_machine_learning_results["ML"][0]


half_machine_learning_results["Cycles"][3]=half_machine_learning_results["Cycles"][3]+half_machine_learning_results["ML"][0]
full_machine_learning_results["Cycles"][3]=full_machine_learning_results["Cycles"][3]+full_machine_learning_results["ML"][0]

all_tests_comparison["Total ML"][i]=full_machine_learning_results["Cycles"][3]
i=i+1

#%% Plot 
fig, ax= plot.subplots()
ax.set_xlabel('Simulation Cycles  (x10e06)')
ax.set_ylabel('Coverage Percentage')
ax.set_title('Coverage Percentage vs Simulation Cycles')
ax.plot(no_machine_learning_results["Cycles"],no_machine_learning_results["Coverage Percentage"],marker='s',label='no_machine_learning',color='green')
ax.plot(half_machine_learning_results["Cycles"],half_machine_learning_results["Coverage Percentage"],marker='^',label='half_machine_learning',color='blue')
ax.plot(full_machine_learning_results["Cycles"],full_machine_learning_results["Coverage Percentage"],marker='o',label='full_machine_learning',color='red')
ax.legend()
plot.show()

# Basic Read
#%% Adjust Data
no_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/NO_MACHINE_LEARNING/basic_read_single_master_single_slave_test/timing.csv',sep=',')
half_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/DECISION_TREES_ONLY/basic_read_single_master_single_slave/timing.csv',sep=',')
full_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/FULL_MACHINE_LEARNING/basic_read_single_master_single_slave/timing.csv',sep=',')

all_tests_comparison["No ML"][i]=no_machine_learning_results["Cycles"][3]
all_tests_comparison["ML"][i]=full_machine_learning_results["Cycles"][3]
all_tests_comparison["ML Time"][i]=full_machine_learning_results["ML"][0]


half_machine_learning_results["Cycles"][3]=half_machine_learning_results["Cycles"][3]+half_machine_learning_results["ML"][0]
full_machine_learning_results["Cycles"][3]=full_machine_learning_results["Cycles"][3]+full_machine_learning_results["ML"][0]

all_tests_comparison["Total ML"][i]=full_machine_learning_results["Cycles"][3]
i=i+1

#%% Plot 
fig, ax= plot.subplots()
ax.set_xlabel('Simulation Cycles (x10e06)')
ax.set_ylabel('Coverage Percentage')
ax.set_title('Coverage Percentage vs Simulation Cycles')
ax.plot(no_machine_learning_results["Cycles"],no_machine_learning_results["Coverage Percentage"],marker='s',label='no_machine_learning',color='green')
ax.plot(half_machine_learning_results["Cycles"],half_machine_learning_results["Coverage Percentage"],marker='^',label='half_machine_learning',color='blue')
ax.plot(full_machine_learning_results["Cycles"],full_machine_learning_results["Coverage Percentage"],marker='o',label='full_machine_learning',color='red')
ax.legend()
plot.show()

#Basic Write
#%% Adjust Data
no_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/NO_MACHINE_LEARNING/basic_transfer_single_master_single_slave_test/timing.csv',sep=',')
half_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/DECISION_TREES_ONLY/basic_transfer_single_master_single_slave/timing.csv',sep=',')
full_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/FULL_MACHINE_LEARNING/basic_transfer_single_master_single_slave/timing.csv',sep=',')

all_tests_comparison["No ML"][i]=no_machine_learning_results["Cycles"][3]
all_tests_comparison["ML"][i]=full_machine_learning_results["Cycles"][3]
all_tests_comparison["ML Time"][i]=full_machine_learning_results["ML"][0]


half_machine_learning_results["Cycles"][3]=half_machine_learning_results["Cycles"][3]+half_machine_learning_results["ML"][0]
full_machine_learning_results["Cycles"][3]=full_machine_learning_results["Cycles"][3]+full_machine_learning_results["ML"][0]

all_tests_comparison["Total ML"][i]=full_machine_learning_results["Cycles"][3]
i=i+1

#%% Plot 
fig, ax= plot.subplots()
ax.set_xlabel('Simulation Cycles (x10e06)')
ax.set_ylabel('Coverage Percentage')
ax.set_title('Coverage Percentage vs Simulation Cycles')
ax.plot(no_machine_learning_results["Cycles"],no_machine_learning_results["Coverage Percentage"],marker='s',label='no_machine_learning',color='green')
ax.plot(half_machine_learning_results["Cycles"],half_machine_learning_results["Coverage Percentage"],marker='^',label='half_machine_learning',color='blue')
ax.plot(full_machine_learning_results["Cycles"],full_machine_learning_results["Coverage Percentage"],marker='o',label='full_machine_learning',color='red')
ax.legend()
plot.show()

#Locked Write
#%% Adjust Data
no_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/NO_MACHINE_LEARNING/locked_write_single_master_single_slave_test/timing.csv',sep=',')
half_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/DECISION_TREES_ONLY/locked_write_single_master_single_slave/timing.csv',sep=',')
full_machine_learning_results=pd.read_csv('C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/FULL_MACHINE_LEARNING/locked_write_single_master_single_slave/timing.csv',sep=',')

all_tests_comparison["No ML"][i]=no_machine_learning_results["Cycles"][2]
all_tests_comparison["ML"][i]=full_machine_learning_results["Cycles"][2]
all_tests_comparison["ML Time"][i]=full_machine_learning_results["ML"][0]

half_machine_learning_results["Cycles"][2]=half_machine_learning_results["Cycles"][2]+half_machine_learning_results["ML"][0]
full_machine_learning_results["Cycles"][2]=full_machine_learning_results["Cycles"][2]+full_machine_learning_results["ML"][0]

all_tests_comparison["Total ML"][i]=full_machine_learning_results["Cycles"][2]
i=i+1

#%% Plot 
fig, ax= plot.subplots()
ax.set_xlabel('Simulation Cycles (x10e06)')
ax.set_ylabel('Coverage Percentage')
ax.set_title('Coverage Percentage vs Simulation Cycles')
ax.plot(no_machine_learning_results["Cycles"],no_machine_learning_results["Coverage Percentage"],marker='s',label='no_machine_learning',color='green')
ax.plot(half_machine_learning_results["Cycles"],half_machine_learning_results["Coverage Percentage"],marker='^',label='half_machine_learning',color='blue')
ax.plot(full_machine_learning_results["Cycles"],full_machine_learning_results["Coverage Percentage"],marker='o',label='full_machine_learning',color='red')
ax.legend()
plot.show()

#%% Detailed Comparison
fig = plot.figure(figsize =(10, 7))
plot.bar(all_tests_comparison.columns.values, all_tests_comparison.loc[4].values)
plot.xlabel("Running Technique")
plot.ylabel("Simulation Cycles")
plot.title("Locked Write Test")
fig.show()
#%% Plotting All of Them (not efficient as ranges aren't close)
# barWidth = 0.25
# fig = plot.subplots(figsize =(15, 8))
 
# # Set position of bar on X axis
# br1 = np.arange(len(all_tests_comparison["No ML"].values))
# br2 = [x + barWidth for x in br1]
# br3 = [x + barWidth for x in br2]
# br4 = [x + barWidth for x in br3]
 
# # Make the plot
# plot.bar(br1,all_tests_comparison["No ML"].values , color ='r', width = barWidth,
#     edgecolor ='grey', label ='NO ML')
# plot.bar(br2, all_tests_comparison["Total ML"].values, color ='g', width = barWidth,
#         edgecolor ='grey', label ='Total ML')
# plot.bar(br3, all_tests_comparison["ML"].values, color ='b', width = barWidth,
#         edgecolor ='grey', label ='ML')
# plot.bar(br4, all_tests_comparison["ML Time"].values, color ='y', width = barWidth,
#         edgecolor ='grey', label ='ML Time')
 
# # Adding Xticks
# plot.xlabel('Tests', fontweight ='bold', fontsize = 15)
# plot.ylabel('Simulation Cycles', fontweight ='bold', fontsize = 15)
# #plot.xticks([r + barWidth for r in range(len(IT))],       ['2015', '2016', '2017', '2018', '2019'])
 
# plot.legend()
# plot.show()

