//--RAW TO RGB --- 	
module VGA_READ_COUNTER  (
	input  CLK ,
	input  CLR_n ,
	input  EN ,
	output  [15:0] CNT 
);

reg [15:0] CNT_ ;

assign CNT = CNT_ ; 

always @ ( posedge CLK )
 if ( !CLR_n) CNT_ <=0; 
 else if ( EN ) CNT_ <=CNT_ +1 ; 

endmodule 