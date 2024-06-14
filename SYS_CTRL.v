module SYS_CTRL(
  input wire [15:0] ALU_OUT,
  input wire        OUT_valid,
  input wire [7:0]  RX_P_DATA,
  input wire        RX_D_VLD,
  input wire [7:0]  RdData,
  input wire        RdData_valid,
  input wire        CLK,
  input wire        RST,
  input wire       FIFO_FULL,
  output reg        ALU_EN,
  output reg [3:0]  ALU_FUN,
  output reg        CLKG_EN=1,
  output reg [3:0]  Address,
  output reg        WrEN,
  output reg        RdEN,
  output reg [7:0]  WrData,
  output reg [7:0]  WR_DATA_FIFO,
  output reg        WR_INC,
  output reg        CLKDIV_EN=1
  );
  
  
//internal connections 
reg [7:0] internal_command =0; 
reg flag_3=0;
reg count=0;
reg flag_1=0;
reg flag_2=0;
reg flag_4=0;
reg flag_5=0;
reg flag_6=0;
reg flag_7=0;
/////////states////////////
localparam [3:0] 
IDEL=4'b0000,
FRAME_0=4'b0001,
WR_1=4'b0011,
WR_2=4'b0010,
RD_1=4'b0110,
ALU_OP_1=4'b1110,
ALU_OP_2=4'b1111,
ALU_OP_3=4'b0111,
ALU_NOP_1=4'b0101,
FIFO_STATE=4'b1101,
REG_FILE_STATE=4'b1100,
ALU_STATE=4'b1000;
////////////commands/////////////////
localparam [7:0]
RF_WR_CMD = 8'hAA,
RF_Rd_CMD = 8'hBB,
ALU_OPER_W_OP_CMD = 8'hCC,
ALU_OPER_W_NOP_CMD = 8'hDD;

//////////////////////////////////////////// 
reg [3:0]  current_state=0 ,next_state=0;
 
/////////////////////////////////////////////////
always @(posedge CLK or negedge RST)
begin
  if(!RST)
    begin
      current_state<=IDEL;
    end
  else 
    begin
      current_state<=next_state;
    end
end 
//////////////////////////////////////////////////

always @(*)
begin

    
    case(current_state)
      ////////////////IDEL STATE////////////
      IDEL:begin
       
    ALU_EN=0;
    ALU_FUN=0;
    //Address=0;
    WrEN=0;
    RdEN=0;
    WrData=0;
    WR_DATA_FIFO=0;
    WR_INC=0;
   //flag_3=0;
   flag_4=0;
flag_1=0; 
flag_2=0;
flag_5=0;
    internal_command=0;
    
    if(RX_D_VLD)
      begin
        internal_command=RX_P_DATA;
        next_state=FRAME_0;
      end
    else
      begin
        next_state=IDEL;
      end
      end
 
 FRAME_0:begin
   case(internal_command)
          RF_WR_CMD:begin
          if(RX_D_VLD)
            next_state=WR_1;
          else
            next_state=FRAME_0;
          end
          RF_Rd_CMD:begin
            if(RX_D_VLD)
            next_state=RD_1;
          else
            next_state=FRAME_0;
          
          end
         ALU_OPER_W_OP_CMD:begin
         if(RX_D_VLD)
            next_state=ALU_OP_1;
          else
            next_state=FRAME_0;
       end 
       ALU_OPER_W_NOP_CMD:begin
         if(RX_D_VLD)
            next_state=ALU_NOP_1;
          else
            next_state=FRAME_0;
       end
     endcase
     if(!RX_D_VLD)
       next_state=FRAME_0;
 end
 ///////////////////////////////////////////////////////////////////
 ////////////////////write states/////////////////////////////
  WR_1:begin
       
      if(RX_D_VLD)
         next_state=WR_2;
      else
        next_state=WR_1;
  end
  
  WR_2:begin
    WrEN=1;
    if(!flag_4)
    WrData=RX_P_DATA;
    flag_4=1;
         next_state=IDEL;
      
    end
    
    
 ///////////////////////////////////////////////////////////////////
 //////////////////read states//////////////////////////////
 RD_1:begin
   flag_1=1;
   RdEN=1;
      next_state=REG_FILE_STATE;
  end
  
  
 //////////////////////////////////////////////////////////////////////
 ////////////////////////ALU WITH ORERAND STATES/////////////
 ALU_OP_1:begin
    WrEN=1;
    WrData=RX_P_DATA;
    if(RX_D_VLD)
      begin
         //Address=4'b0001;
         next_state=ALU_OP_2;
       end
      else
        next_state=ALU_OP_1;
   
end
   
   
ALU_OP_2:begin
    WrEN=1;
    if(!flag_4)
    WrData=RX_P_DATA;
    flag_4=1;
    if(RX_D_VLD)
         next_state=ALU_OP_3;
      else
        next_state=ALU_OP_2;
   
end 
 
 ALU_OP_3:begin
   WrEN=0;
   ALU_EN=1;
   flag_2=1;
   if(!flag_5)
   ALU_FUN=RX_P_DATA[3:0];
   flag_5=1;
    
         next_state=ALU_STATE;
    
   end
 ///////////////////////////////////////////////////////////////
 ///////////////////ALU WITHOUT OPERANDS////////////////////
 ALU_NOP_1:begin
   ALU_EN=1;
   flag_2=1;  
   ALU_FUN=RX_P_DATA[3:0];
   
         next_state=ALU_STATE;
      
   
   end
   
   /////////////////////////////////////////////////
   //////////////////REG FILE STATE//////////////
    REG_FILE_STATE:begin
   if(RdData_valid&&flag_1)
     begin
       next_state=FIFO_STATE;
     WR_DATA_FIFO=RdData;
     WR_INC=1;
     flag_1=0;
   end
 else
   next_state=REG_FILE_STATE;
   
end 

//////////////////////////////////////////////////////
///////////ALU_STATE/////////////////////////////////
    ALU_STATE:begin
   if(OUT_valid&&flag_2)
     begin
      WR_DATA_FIFO=ALU_OUT;
     WR_INC=1;
      flag_2=0;
     next_state=FIFO_STATE;
   end
 else
   next_state=ALU_STATE;
  
end 
   //////////////////////////////////////////////////////
   //////////////FIFO STATE//////////////////////////
   FIFO_STATE:begin
     if(FIFO_FULL)
       next_state=FIFO_STATE;
     else
       next_state=IDEL;
   end
  endcase
  
end
////////////////////////////////////////////////////////////////
//////////////////address /////////////////////////////////////
always@(*)
begin

  if(internal_command==RF_WR_CMD&&current_state==WR_1&&flag_3==0||internal_command==RF_Rd_CMD&&current_state==RD_1&&flag_3==0)
     begin
     Address=RX_P_DATA[3:0];
     flag_3=1;
   end
else if(internal_command==ALU_OPER_W_OP_CMD&&current_state==ALU_OP_1&&flag_6==0)
   begin
         Address=0;
     flag_6=1;
   end
 else if(internal_command==ALU_OPER_W_OP_CMD&&current_state==ALU_OP_2&&flag_7==0)
   begin
         Address=1;
     flag_7=1;
   end
 else
   begin
     flag_3=0;
     flag_6=0;
     flag_7=0;
   end
 end
 
 //////////////////////////////////////////////////////////////////// 
 /////////////////always block for read & ALU states/////////////////

   
endmodule

