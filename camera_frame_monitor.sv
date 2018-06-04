module camera_frame_monitor(
	input clk, reset, unlatch,
	output cam_frame_complete, // a 1 if the camera has captured an entire frame, 0 otherwise
	// camera information
	input MIPI_PIXEL_VS,
	output [1:0] cam_state
	);
	
	parameter [1:0] RESET=2'b00, SOF=2'b01, EOF=2'b11;
	
	logic [1:0] ps, ns;
	assign cam_state = ps;
	
	always_ff @(posedge clk) begin
		if (reset) ps <= RESET;
		else ps <= ns;
	end
	
	// Stores the v_sync changes over time
	logic [1:0] v_sync_fifo;
	always_ff @(posedge clk) begin
		v_sync_fifo <= {v_sync_fifo[0], MIPI_PIXEL_VS};
	end
	
	
	// compute ns
	always_comb begin
		case (ps)
			RESET: begin
				if (v_sync_fifo == {1'b0, 1'b1}) ns <= SOF; // Rising Edge
				else ns <= RESET;
			end
			SOF: begin
				if (v_sync_fifo == {1'b1, 1'b0}) ns <= (unlatch) ? SOF : EOF;  //Falling Edge
				else ns <= SOF;
			end
			EOF: begin
				if (v_sync_fifo == {1'b0, 1'b1}) ns <= (unlatch) ? SOF : EOF; // latch in the eof state
				else ns <= EOF;
			end
			default: ns <= RESET;
		endcase
	end
	
	// output
	assign cam_frame_complete = (ps == EOF);
	
endmodule
