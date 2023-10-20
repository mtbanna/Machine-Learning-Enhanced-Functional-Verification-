module read_and_write_a_file_example;

	int file_handle,y;
	int j=4;
	string line;
	string an_item_value="00000"; //5 chars cause the max number of elements in a read data is four, so we will signal the end from the unchannged 'e',
	// as SV doesn't have lots of useful methods

	initial begin
		file_handle=$fopen("C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/csv_files/from_python/predicted/no_cluster/bus_request.csv","r+"); //open file, change given argument "r+" for different purposes.
		if (file_handle!==0)
			$display("File was opened successfully");
		else
			$display("file opening failed");

		/*$fdisplay(file_handle,"we are alive");   //writes a line in the file.
		$fclose(file_handle);                       //it's important to close all opened files to ensure the completeness of writing content.
		file_handle=$fopen("C:/Users/Dell/Desktop/trial.txt","r");
*/
		$fgets(line,file_handle);
		while ($feof(file_handle)==0) begin              // returns 16 when end of file is reached, otherwise 0.
			$fgets(line,file_handle);
			$display(line);
			$display("line length: %0d",line.len());
			for (int i = line.len(); i >= 0; i--) begin
				if(line[i-1]=="," || i==0) begin
					$display("%0s",an_item_value);
					$sformat(y,"%0s",an_item_value.atoi());
					$display("Integer Value: %0d",y);
					$display("_______________________________________________________");
					an_item_value="00000";
					j=4;
				end
				else if (line[i-1]=="")
					continue;

				else begin
					an_item_value.putc(j,line[i-1]);
					j=j-1;
				end


			end
		end
		$fclose(file_handle);                       //it's important to close all opened files to ensure the completeness of writing content.
		$finish;
	end
endmodule
/*
we could add an argument to signal the end of a file
$fscanf helps us to search for certain data in a file
writing and reading without closing a file results in strange errors
add commas to the end of lines to have a csv file to be able to process it with python
*/