
module RAW2RGB_L(	
//---ccd 
input	  [9:0]	 CCD_DATA,
input			    CCD_PIXCLK ,
input		       CCD_FVAL,
input		       CCD_LVAL,
input	  [15:0]	 X_Cont,
input	  [15:0]	 Y_Cont,
input			    DVAL,
input			    RST,
input           VGA_CLK, // 25M 
input           READ_EN ,
input           VGA_VS ,	
input   [12:0]  READ_Cont ,
input   [12:0]  V_Cont , 
output	 [7:0] oRed,
output 	 [7:0] oGreen,
output	 [7:0] oBlue,
output	   	 oDVAL

);
parameter D8M_VAL_LINE_MAX  = 620; 
parameter D8M_VAL_LINE_MIN  = 2; 

//----- WIRE /REG 
wire	   [9:0]	mDAT0_0;
wire	   [9:0]	mDAT0_1;
wire 		[9:0]	mCCD_R;
wire 		[9:0]	mCCD_G; 
wire 		[9:0]	mCCD_B;


//-------- RGB OUT ---- 
assign   oRed	 = mCCD_R[9:2];
assign  oGreen  = mCCD_G[9:2] ;
assign	oBlue	 =	mCCD_B[9:2];

//----3 2-PORT-LINE-BUFFER----  
Line_Buffer_J 	u0	(	
						.CCD_PIXCLK  ( CCD_PIXCLK ),
                  .mCCD_LVAL   ( CCD_LVAL) , 	
						.X_Cont      ( X_Cont) , 
						.mCCD_DATA   ( CCD_DATA),
						.VGA_CLK     ( VGA_CLK), 
                  .READ_Request( READ_EN ),
                  .READ_Cont   ( READ_Cont),					
						.taps0x      ( mDAT0_0),
						.taps1x      ( mDAT0_1)
						);					

	
wire    RD_EN ; 
assign RD_EN = (( READ_Cont > D8M_VAL_LINE_MIN ) && ( READ_Cont < D8M_VAL_LINE_MAX ))?1:0 ; 			

	
						
RAW_RGB_BIN  bin(
      .CLK  ( VGA_CLK ), 
      .RST_N( RD_EN  ) , 
      .D0   ( mDAT0_0),
      .D1   ( mDAT0_1),
      .X    ( READ_Cont[0]) ,
      .Y    ( V_Cont[0]),
      .R    ( mCCD_B),
      .G    ( mCCD_G), 
      .B    ( mCCD_R)
); 


endmodule
