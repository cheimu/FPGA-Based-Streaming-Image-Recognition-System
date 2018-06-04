module D8M_SET (
   input       CLOCK_50,	
	input       RESET_SYS_N ,	
	output	   oRESET_N,
	output	   SCLK ,
	inout 	   SDATA,
	
	input [9:0]CCD_DATA  ,
	input       CCD_FVAL  ,
	input	      CCD_LVAL	 ,
	input	      CCD_PIXCLK,
	
   input       VGA_CLK ,
   input       VGA_HS  ,
   input       VGA_VS  ,
	input  READ_EN , 

	output [7:0]sCCD_R,
	output [7:0]sCCD_G,
	output [7:0]sCCD_B,
	output		sCCD_DVAL,
	output		CCD_DVAL, 
	output		CCD_LDVAL,
	output		CCD_FDVAL,
	output  [15:0] READ_Cont,
   output  [15:0] X_Cont,	
   output  [15:0] Y_Cont	,
   output  [15:0] X_WR_CNT	
 );

 
//=============================================================================
// REG/WIRE declarations
//=============================================================================
wire[9:0]  mCCD_DATA;



//-------CCD CA--- 
D8M_WRITE_COUNTER 	u3	(	
			.iCLK       ( CCD_PIXCLK ),
			.iRST       ( RESET_SYS_N ),
			.iFVAL      ( CCD_FVAL ),
			.iLVAL      ( CCD_LVAL ),
			.X_Cont     ( X_Cont ),
			.Y_Cont     ( Y_Cont ),
			.X_WR_CNT   (X_WR_CNT)
			
);
						
//--READ Counter --- 	
VGA_READ_COUNTER   cnt(
	.CLK   (VGA_CLK     ),
	.CLR_n (VGA_HS      ),
	.EN    (READ_EN),
	.CNT   (READ_Cont)
);

//--RAW TO RGB --- 							
RAW2RGB_L				u4	(	
							.RST          ( RESET_SYS_N ),
                     .CCD_PIXCLK   ( CCD_PIXCLK),
							.CCD_DATA     ( CCD_DATA ),
							.CCD_FVAL     ( CCD_FVAL ),
							.CCD_LVAL     ( CCD_LVAL ),
							.X_Cont       ( X_WR_CNT  ),
							.Y_Cont       ( Y_Cont    ),
							//-----------------------------------
                     .VGA_CLK      ( VGA_CLK),
                     .READ_EN      ( READ_EN ),
                     .VGA_VS       ( VGA_VS ),	
	                  .READ_Cont    ( READ_Cont ) , 
	                  .V_Cont       ( Y_Cont    ), 
	                  			
							.oRed         ( sCCD_R ),
							.oGreen       ( sCCD_G ),
							.oBlue        ( sCCD_B ),
							.oDVAL        ( sCCD_DVAL )
						);
						

endmodule

