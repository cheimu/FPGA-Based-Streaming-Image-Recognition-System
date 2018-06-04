// Converts a raw data point {R G} or {G B} to an approximate grayscale
module raw_grayscale(
	input [9:0] raw_data,
	output [7:0] gray_data);

	logic [9:0] temp;
	assign temp = raw_data[4:0] + raw_data[9:5];

	assign gray_data = temp[8:1];
	
endmodule
