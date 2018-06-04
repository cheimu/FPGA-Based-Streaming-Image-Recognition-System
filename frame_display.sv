module frame_display(
	input						CLOCK_50,
	input						KEY0,
	input write_complete,
	output yield,
/*******************************************************************************
												SDRAM IO
*******************************************************************************/
	output read_enable,
	input [7:0] read_data,
	
/*******************************************************************************
												VGA IO
*******************************************************************************/
	output	[7:0]			VGA_R,	
	output	[7:0]			VGA_G,
	output	[7:0]			VGA_B,
	output					VGA_BLANK_N,
	output					VGA_CLK,
	output					VGA_HS,
	output					VGA_SYNC_N,
	output					VGA_VS
);

	parameter WIDTH = 640, HEIGHT = 480;
	
/*******************************************************************************
										  System Clocks
*******************************************************************************/
	reg						CLOCK_25;
	wire						CLOCK_25_p90;
	wire						CLOCK_143;

	assign CLOCK_25_p90 = CLOCK_50 ^ CLOCK_25;
	assign CLOCK_25_p180 = ~CLOCK_25;
	assign CLOCK_25_p270 = ~CLOCK_25_p90;
	
	always_ff@(posedge CLOCK_50) begin
		if(~rst_n) begin
			CLOCK_25 <= 1'b0; // Sync CLOCK_25 and CLOCK_50
		end
		else begin
			CLOCK_25 <= ~CLOCK_25;
		end
	end
		
/*******************************************************************************
										  Input Debounce
*******************************************************************************/
	reg					key_debounce, rst_n;
	
	always_ff@(posedge CLOCK_50) begin
		key_debounce	<= KEY0;
		rst_n				<= key_debounce;
	end
	
/*******************************************************************************
											 VGA Driver
*******************************************************************************/
	wire		[9:0]		PIXEL_X;
	wire		[8:0]		PIXEL_Y;
	
	wire		[7:0]		iRGB;
	
	video_driver #(WIDTH, HEIGHT) vga_driver(
		CLOCK_50,
		~rst_n,
		PIXEL_X,
		PIXEL_Y,
		iRGB,
		iRGB,
		iRGB,
		VGA_R,
		VGA_G,
		VGA_B,
		VGA_BLANK_N,
		VGA_CLK,
		VGA_HS,
		VGA_SYNC_N,
		VGA_VS
	);
	
	
// wait for write complete to start frame
	logic [1:0] ps, ns;
	parameter [1:0] WRITE = 2'b00, WAIT = 2'b01, GO = 2'b10;
	
	always_ff @(posedge CLOCK_50) begin
		if (~rst_n) ps <= WRITE;
		else ps <= ns;
	end
	
	assign yield = (ps == WRITE); // only yeild if the  VGA monitor  expects that someone is writing
	
	always_comb begin
		case (ps)
			WRITE: ns = (write_complete) ? WAIT : WRITE;
			WAIT: begin
				ns = (PIXEL_X == 0 && PIXEL_Y == 479) ? GO : WAIT;
			end
			GO: ns = (!write_complete && (PIXEL_X == 0 && PIXEL_Y == 479)) ? WRITE : GO;
			default: ns = WRITE;
		endcase
	end
	
/*******************************************************************************
											 SDRAM Module
*******************************************************************************/
	wire		[7:0]		odata;
	
	wire					re;
	
	// read enable on alternating states
	always_comb begin 
		re = ~(CLOCK_25 | CLOCK_50);
	end
	
	logic [9:0] old_x, new_x;
	always_ff @(posedge CLOCK_50) begin
		if (~rst_n) begin
			old_x <= 0;
			new_x <= 0;
		end else begin
			old_x <= new_x;
			new_x <= PIXEL_X;
		end
	end
	
	assign odata = read_data;
	assign read_enable = ((ps == GO) && (new_x != old_x) && (new_x != 0)) ? 1 : 0;

/*******************************************************************************
											 Line Buffer
*******************************************************************************/
	reg		[7:0]		temp_buf;
	
	always_ff@(negedge CLOCK_25) begin
		temp_buf <= odata;
	end

	line_cache	#(WIDTH) line_buf(
		CLOCK_50,
		PIXEL_X-1,
		temp_buf,
		~read_enable,
		PIXEL_X,
		iRGB
	);

endmodule
