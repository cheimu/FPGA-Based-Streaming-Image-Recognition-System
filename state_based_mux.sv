module state_based_mux #(WIDTH=1) (
	input [2:0] state,
	input [WIDTH-1:0] cam, conv, vga, copy,
	output [WIDTH-1:0] out);
	
	parameter [2:0] CAM=3'b000, CONV=3'b001, VGA=3'b010, VGA_WAIT=3'b011, COPY=3'b100;
	
	always_comb begin
		case (state)
			CAM: out = cam;
			CONV: out = conv;
			VGA: out = vga;
			VGA_WAIT: out = 0;
			COPY: out = copy;
			default: out = 0;
		endcase
	end
	
endmodule
