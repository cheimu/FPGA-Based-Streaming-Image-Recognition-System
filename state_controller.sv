module state_controller(
	// likely want input clock to be based on state
	input clk, reset, switch,
	output [2:0] state,
	// camera information
	input MIPI_PIXEL_VS,
	output [1:0] cam_state,
	// copy information
	input copy_finished,
	// convolution information
	input conv_finished,
	// vga information
	input VGA_VS);
	
	
	parameter [2:0] CAM=3'b000, CONV=3'b001, VGA=3'b010, VGA_WAIT=3'b011, COPY=3'b100;
	
	logic [1:0] ps, ns;
	assign state = ps;
	
	// camera logic variables
	logic cam_frame_complete;
	camera_frame_monitor cam_monitor(clk, reset, cam_frame_complete, MIPI_PIXEL_VS, cam_state);
	
	// Update state w/ ns
	always_ff @(posedge clk) begin
		if (switch && cam_frame_complete) begin
			ps <= CAM;
		end else begin
			ps <= ns;
		end
	end

	// conv logic variables
	logic conv_frame_complete;
	assign conv_frame_complete = conv_finished;
	
	// determine ns (currently stops at VGA)
	always_comb begin
		case (ps)
			CAM: begin
				if (cam_frame_complete) ns <= VGA;
				else ns <= CAM;
			end
			COPY: begin
				if (copy_finished) ns <= VGA;
				else ns <= COPY;
			end
			CONV: begin
				if (conv_frame_complete) ns <= VGA_WAIT;
				else ns <= CONV;
			end
			VGA_WAIT: begin
				if (!VGA_VS) ns <= VGA;
				else ns <= VGA_WAIT;
			end
			VGA: begin
				ns <= VGA;
			end
			default: ns <= CAM;
		endcase
	end
	
endmodule
