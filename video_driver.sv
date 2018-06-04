module video_driver
	#(parameter WIDTH = 640, parameter HEIGHT = 480)
	(CLOCK_50, reset, x, y, r, g, b, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS); 
	input CLOCK_50;
	input reset;
	output reg [9:0] x;
	output reg [8:0] y;
	input [7:0] r, g, b;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	localparam integer X_BLOCK = 640 / WIDTH;
	localparam integer Y_BLOCK = 480 / HEIGHT;
	localparam integer BLOCK = X_BLOCK < Y_BLOCK ? X_BLOCK : Y_BLOCK;
	localparam integer X_SPAN = WIDTH * BLOCK;
	localparam integer Y_SPAN = HEIGHT * BLOCK;
	localparam integer X_START = (640 - X_SPAN) / 2;
	localparam integer Y_START = (480 - Y_SPAN) / 2;
	localparam integer X_STOP = X_START + X_SPAN;
	localparam integer Y_STOP = Y_START + Y_SPAN;
	localparam integer BLOCK_STOP = BLOCK - 1;
	
	wire read_enable;
	wire end_of_active_frame;
	wire end_of_frame;
	wire vga_blank;
	wire vga_c_sync;
	wire vga_h_sync;
	wire vga_v_sync;
	wire vga_data_enable;
	
	reg read_enable_last;
	reg CLOCK_25;
	reg [9:0] xt;
	reg [8:0] yt;
	reg [9:0] xd;
	reg [8:0] yd;
	
	always @(posedge CLOCK_50)
		CLOCK_25 <= ~CLOCK_25;
	
	always @(posedge CLOCK_25) begin
		if(reset) begin
			xt <= 0;
			yt <= 0;
			xd <= 0;
			yd <= 0;
			x <= 0;
			y <= 0;
		end else begin
			read_enable_last <= read_enable;
			if(read_enable) begin
				xt <= xt + 1'b1;
				if(xt >= X_START && xt < X_STOP) begin
					if(xd == BLOCK_STOP) begin
						xd <= 10'b0;
						x <= x + 1'b1;
					end else begin
						xd <= xd + 1'b1;
					end
				end else begin
					xd <= 10'b0;
					x <= 10'b0;
				end
			end else begin
				xt <= 10'b0;
				xd <= 10'b0;
				x <= 10'b0;
			end
			if(end_of_active_frame) begin
				yt <= 9'b111111111;
				yd <= 9'b0;
				y <= 9'b0;
			end else begin
				if(read_enable_last & ~read_enable) begin
					yt <= yt + 1'b1;
					if(yt >= Y_START && yt < Y_STOP) begin
						if(yd == BLOCK_STOP) begin
							yd <= 9'b0;
							y <= y + 1'b1;
						end else begin
							yd <= yd + 1'b1;
						end
					end else begin
						yd <= 9'b0;
						y <= 9'b0;
					end
				end
			end
		end
	end
	
	assign VGA_BLANK_N = vga_blank;
	assign VGA_CLK = CLOCK_25;
	assign VGA_HS = vga_h_sync;
	assign VGA_SYNC_N = 1'b0;
	assign VGA_VS = vga_v_sync;
	
	reg [7:0] rout, gout, bout;
	
	always @(posedge CLOCK_25) begin
		if(xt >= X_START && xt < X_STOP && yt >= Y_START && yt < Y_STOP) begin
			rout <= r;
			gout <= g;
			bout <= b;
		end else begin
			rout <= 8'b0;
			gout <= 8'b0;
			bout <= 8'b0;
		end
	end
	
	altera_up_avalon_video_vga_timing video (
		// inputs
		.clk(CLOCK_25),
		.reset,

		.red_to_vga_display({rout,2'b00}),
		.green_to_vga_display({gout,2'b00}),
		.blue_to_vga_display({bout,2'b00}),
		.color_select(4'b1111),
		
		// outputs
		.read_enable,
		.end_of_active_frame,
		.end_of_frame,

		// dac pins
		.vga_blank,					//	VGA BLANK
		.vga_c_sync,				//	VGA COMPOSITE SYNC
		.vga_h_sync,				//	VGA H_SYNC
		.vga_v_sync,				//	VGA V_SYNC
		.vga_data_enable,			// VGA DEN
		.vga_red(VGA_R),			//	VGA Red[9:0]
		.vga_green(VGA_G),	 	//	VGA Green[9:0]
		.vga_blue(VGA_B),	   	//	VGA Blue[9:0]
		.vga_color_data()	   	//	VGA Color[9:0] for TRDB_LCM
	);
endmodule
