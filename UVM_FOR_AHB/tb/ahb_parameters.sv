package ahb_parameters;
	localparam number_of_masters = 2;
	localparam number_of_slaves = 3;

	localparam  P_HSEL0_START=32'h0,P_HSEL0_SIZE=32'h400;           //specifies which slave to select depending on address coming from master (start address and size of adresses).
	localparam  P_HSEL1_START=32'h400,P_HSEL1_SIZE=32'h400;
	localparam  P_HSEL2_START=32'h800,P_HSEL2_SIZE=32'h400;

	localparam CLK_PERIOD_HALF=5;

	localparam machine_learning_enhancement=3;  // '0' for no ML, 1 generate data for model prediction, 2 generate results for model training, 3 for using the model predictions.
	bit full_machine_learning=1;                // if '1'>> full model, '0' only decision tree
	int seed=19;                                //randomization seed for sequence generation
	int verbosity= 0;                           //0>none, 100>low, 200>medium, 300>high, 400>full, 500>debug
	int number_of_data_for_prediction=150000;
	int number_of_data_in_a_sequence=100000000;
	string to_python_csv_file_location_training="C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/to_python/training/bus_request.csv";   //handle the condition where you run multiple masters.
	string to_python_csv_file_location_prediction="C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/to_python/prediction/bus_request.csv";
	
	string from_python_csv_file_location[5]='{"C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/no_cluster/bus_request.csv",
		"C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/bus_request/cluster0_predicted_data.csv",
		"C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/bus_request/cluster1_predicted_data.csv",
		"C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/bus_request/cluster2_predicted_data.csv",
		"C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/cluster/bus_request/cluster3_predicted_data.csv"};
	localparam max_read_file_index=2;       //number of clusters
	int max_number_of_consecutive_items_without_coverage_hit_to_change_file=4;

	string test_name="bus_request_test";

endpackage