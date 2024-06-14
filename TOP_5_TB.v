module TOP_5_TB ();




reg        CLK_TB;
reg        RST_TB;
reg   [7:0]      RX_P_DATA_TB;
 reg         RX_D_VLD_TB;
reg   busy_TB;
reg   RX_CLK_TB;
wire  [7:0]      RD_DATA_FIFO_TB;
wire  [7:0] REG2_TB;
wire  [7:0] REG3_TB ;  
wire        E_EMPTY_TB;
 
   

TOP_5  DUT
(

.d_s_d(RX_P_DATA_TB),
.d_s_p(RX_D_VLD_TB),
.busy(busy_TB),
.EMPTY(E_EMPTY_TB),
.RD_DATA_FIFO(RD_DATA_FIFO_TB),
.REG2(REG2_TB),
.REG3(REG3_TB),
.CLK(CLK_TB),
.RST(RST_TB),
.CLK_RX(RX_CLK_TB)
);

 
//clock generatiom
always #(12.5/2)  CLK_TB= ! CLK_TB ;
always #(20/2)    RX_CLK_TB=!RX_CLK_TB;
//initial block
initial
begin
  
  // Save Waveform
    $dumpfile("TOP_2.vcd");
    $dumpvars;
   
   initialize(); 
   RST_TB=0;
   #20
   RST_TB=1;
   /*
#30
RX_P_DATA_TB=8'hAA;
RX_D_VLD_TB=1;
#20
RX_D_VLD_TB=0;
#20
RX_P_DATA_TB=8'b00001010;
RX_D_VLD_TB=1;
#20
RX_D_VLD_TB=0;
#20
RX_P_DATA_TB=8'b10001000;
RX_D_VLD_TB=1;
#20
RX_D_VLD_TB=0;
busy_TB=1;
#500

RX_P_DATA_TB=8'hBB;
RX_D_VLD_TB=1;
#20
RX_D_VLD_TB=0;
#20
RX_P_DATA_TB=8'b00001010;
RX_D_VLD_TB=1;
#20
RX_D_VLD_TB=0;
busy_TB=1;
#10
busy_TB=0;
#10
busy_TB=1;
#10
busy_TB=0;
#300*/
#50
RX_P_DATA_TB=8'hCC;
RX_D_VLD_TB=1;
#20
RX_D_VLD_TB=0;
#50
RX_P_DATA_TB=8'b10001010;
RX_D_VLD_TB=1;
#20
RX_D_VLD_TB=0;
#20
RX_P_DATA_TB=8'b10101010;
RX_D_VLD_TB=1;
#20
RX_D_VLD_TB=0;
#20
RX_P_DATA_TB=8'b0000100;
RX_D_VLD_TB=1;
#20
RX_D_VLD_TB=0;

#200
RX_P_DATA_TB=8'hDD;
RX_D_VLD_TB=1;
#20
RX_D_VLD_TB=0;
#20
RX_P_DATA_TB=8'b00000000;
RX_D_VLD_TB=1;
#20
RX_D_VLD_TB=0;

#200
$finish ;
    
end
////////////////////////////////////////////////
task initialize ;
  begin

CLK_TB=0;
RST_TB=1;
RX_CLK_TB=0;
RX_P_DATA_TB=0;
RX_D_VLD_TB=0;
busy_TB=0;
	   end
endtask
endmodule












