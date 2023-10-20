import uvm_pkg::*;
import a_test_package::*;
import ahb_parameters::*;
`include "uvm_macros.svh"

virtual class master_sequence  extends uvm_sequence #(master_sequence_item);

	`uvm_object_param_utils(master_sequence)
	master_sequence_item my_item;
	int file_handle[max_read_file_index+1];                            //read file handles
	int file_handle2, an_item_integer, next_item_in_sequence, j;
	string file_line, an_item_value, which_file_to_read, file_text;
	bit terminate_test, change_reading_file;
	bit read_empty_files [max_read_file_index:1];                      //every bit signals an empty file
	int local_seed=seed;
	int opened_read_file_index=full_machine_learning;

	function new (string name="Sequence");
		super.new(name);
	endfunction

	virtual task body();
		`uvm_info("Sequence","Starting Sequence",UVM_MEDIUM)

		for (int i = 0; i <= max_read_file_index; i++) begin                      // opening all read files
			file_handle[i]=$fopen(from_python_csv_file_location[i],"r+");         // all must be opened to return back to the same line (simpler approach)
			if (file_handle[i]!==0)
				`uvm_info("Master Sequence","File was opened successfully", UVM_LOW)
			else begin
				$display("i:%0d ",i);
				`uvm_fatal("Master Sequence","File opening failed")
			end
			$fgets(file_line,file_handle[i]);                                                 // to remove the columns' names
		end

		if (machine_learning_enhancement==1 || machine_learning_enhancement==0)    // prediction and no ML are different than training data
			local_seed=local_seed+1;
		void'($urandom(local_seed));

		my_item=master_sequence_item::type_id::create("my_item",null);

		if(machine_learning_enhancement==1)
			generate_csv_file();

		else if(machine_learning_enhancement==0 || machine_learning_enhancement==2)
			for(int i=0; i<number_of_data_in_a_sequence;i++)
				begin
					if(terminate_test==1)
						break;
					else begin
						wait_for_grant();
						randomize_item(my_item);
						send_request(my_item);
						wait_for_item_done();
					end
				end
		else if (machine_learning_enhancement==3 )
			while(terminate_test!=1) begin
				wait_for_grant();
				read_an_item_from_csv_file();
				send_request(my_item);
				wait_for_item_done();
			end

		for (int i = 0; i <= max_read_file_index; i++)                        // closing all read files
			$fclose(file_handle[i]);

	endtask

	virtual function void generate_csv_file();
		file_handle2=$fopen(to_python_csv_file_location_prediction,"a");
		if (file_handle2!==0)
			uvm_report_info("Master Sequence", "File was opened successfully", UVM_MEDIUM);
		else
			uvm_report_fatal("Master Sequence", "File wasn't opened");

		$fdisplay(file_handle2,"M_HBUSREQ,M_HADDR,M_HTRANS,M_HSIZE,M_HBURST,M_HPROT,M_HLOCK,M_HWRITE,M_HWDATA");
		for (int i = 0; i < number_of_data_for_prediction; i++) begin
			randomize_item(my_item);
			$sformat(file_text,"%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",my_item.HBUSREQ,my_item.HADDR,my_item.HTRANS,my_item.HSIZE,my_item.HBURST,my_item.HPROT,
				my_item.HLOCK,my_item.HWRITE,my_item.HWDATA);
			$fdisplay(file_handle2,file_text);
		end
		$fclose(file_handle2);
	endfunction

	virtual function void add_to_local_seed(int number);
		this.local_seed=local_seed+number;
	endfunction

	pure virtual function automatic void randomize_item(ref master_sequence_item item);

	virtual function void read_an_item_from_csv_file();
		if($feof(file_handle[opened_read_file_index])!=0 || change_reading_file==1)  
			adjust_read_csv_file();

		if(terminate_test==1)
			return;

		$fgets(file_line,file_handle[opened_read_file_index]);
		for (int i = file_line.len(); i >= 0; i--) begin
			if(file_line[i-1]=="," || i==0) begin
				$sformat(an_item_integer,"%0s",an_item_value.atoi());
				set_an_item(an_item_integer);
				an_item_value="00000";
				j=4;
			end
			else if (file_line[i-1]=="")
				continue;

			else begin
				an_item_value.putc(j,file_line[i-1]);
				j=j-1;
			end
		end

	endfunction

	virtual function  void set_an_item(int an_item_value);
		case (next_item_in_sequence)
			8: this.my_item.HBUSREQ=an_item_value;
			7: this.my_item.HADDR=an_item_value;
			6: this.my_item.HTRANS=an_item_value;
			5: this.my_item.HSIZE=an_item_value;
			4: this.my_item.HBURST=an_item_value;
			3: this.my_item.HPROT=an_item_value;
			2: this.my_item.HLOCK=an_item_value;
			1: this.my_item.HWRITE=an_item_value;
			0: this.my_item.HWDATA=an_item_value;
			default: ;
		endcase

		if (next_item_in_sequence!=8)
			next_item_in_sequence=next_item_in_sequence+1;
		else
			next_item_in_sequence=0;

	endfunction

	virtual function void adjust_read_csv_file();

		if($feof(file_handle[opened_read_file_index])!=0)              // if our file is empty add it to the list indicating empty files
			read_empty_files[opened_read_file_index]=1'b1;

		for (int i = 1; i <= max_read_file_index; i++) begin       // terminate test if all files are empty
			if(read_empty_files[i]!=1)
				break;
			else if(i==max_read_file_index)
				terminate_test=1;
		end

		if(opened_read_file_index==max_read_file_index)            // change index
			opened_read_file_index=1;
		else
			opened_read_file_index=opened_read_file_index+1;

		while(read_empty_files[opened_read_file_index]==1)begin     // changing index again if a file is empty
			if(opened_read_file_index==max_read_file_index)
				opened_read_file_index=1;
			else
				opened_read_file_index=opened_read_file_index+1;
		end
		`uvm_info("Master Sequence",$sformatf("Changed file name: %0s",from_python_csv_file_location[opened_read_file_index]), UVM_LOW);
		change_reading_file=0;
	endfunction

endclass