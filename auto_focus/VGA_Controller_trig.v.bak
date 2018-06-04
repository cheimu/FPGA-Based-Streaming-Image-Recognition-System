

module VGA_Controller_trig(
    input     [15:0] H_Cont,
    input     [15:0] V_Cont,
    input		[7:0]	iRed,
    input		[7:0]	iGreen,
    input		[7:0]	iBlue,
    output		[7:0]	oVGA_R,
    output		[7:0]	oVGA_G,
    output		[7:0]	oVGA_B,
    output				oVGA_H_SYNC,
    output				oVGA_V_SYNC,
    output				oVGA_SYNC,
    output				oVGA_BLANK,
	 output            READ_Request , 

    
    //	Control Signal
    input				   iCLK,
    input				   iRST_N,
    output              oVGA_CLOCK

);

parameter V_MARK =9  ; 
`include "VGA_Param.h"
//=============================================================================
// REG/WIRE declarations
//=============================================================================
wire		[7:0]	mVGA_R;
wire		[7:0]	mVGA_G;
wire		[7:0]	mVGA_B;
wire				mVGA_H_SYNC;
wire				mVGA_V_SYNC;
wire				mVGA_SYNC;
wire				mVGA_BLANK;
//=======================================================
// Structural coding
//=======================================================   
assign oVGA_R     = mVGA_R;
assign oVGA_G      = mVGA_G;
assign oVGA_B      = mVGA_B;
assign oVGA_SYNC   = mVGA_SYNC;
assign oVGA_H_SYNC = mVGA_H_SYNC;
assign oVGA_V_SYNC = mVGA_V_SYNC;	

assign	mVGA_SYNC  =	1'b0;
		
assign  oVGA_CLOCK	 = iCLK ; 
//assign  READ_Request   = mVGA_H_SYNC & mVGA_V_SYNC; 

assign	 READ_Request	= (
                          (H_Cont > H_BLANK         && H_Cont<H_SYNC_TOTAL  )	&&
						        ( V_Cont> V_BLANK+V_MARK  && V_Cont<V_SYNC_TOTAL));


////////////////////////////////////////////////////////

assign	oVGA_BLANK	=	~((H_Cont < H_BLANK ) || ( V_Cont < V_BLANK ));

assign	mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						    V_Cont>=Y_START	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iRed	:	0;
assign	mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iGreen	:	0;
assign	mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iBlue	:	0;

				
assign mVGA_H_SYNC =	( ( H_Cont > (H_SYNC_FRONT ) )  &&  ( H_Cont <= (H_SYNC_CYC + H_SYNC_FRONT)))?0 :1 ; 
assign mVGA_V_SYNC =	( ( V_Cont > (V_SYNC_FRONT ) )  &&  ( V_Cont <= (V_SYNC_CYC + V_SYNC_FRONT)))?0 :1 ; 

endmodule
