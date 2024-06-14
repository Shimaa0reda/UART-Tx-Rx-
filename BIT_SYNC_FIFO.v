//NUM STAGES refer to Number of Flip Flop Stages
  //BUS_WIDTH  refer to Width of synchronized signal

/*module BIT_SYNC_FIFO#(parameter DATA_WIDTH = 8,parameter MEM_DEPTH=8
    , parameter ADDR_WIDTH=3)*/

 module BIT_SYNC_FIFO(
  input wire [3:0] async,
  input wire                   clk,
  input wire                   rst,
  output reg [3:0] sync                   
  );
  

   
   //contain number of stages and number of flip flops 
   //per stage
   
  reg [1:0] sync_flop [3:0];
   
   integer i =0;
   
  always @(posedge clk or negedge rst)
  begin
    if(!rst)
      begin
       for(i=0;i<4;i=i+1)
       begin
         sync_flop[i] <= 'b0 ;
     end 
      end
    else
      begin
       for(i=0;i<4;i=i+1)
       //the output is all the values on flip flops 
      //of the stages and final bits =required value
      //to be the output on BIT_SYNC
         sync_flop[i] <=  {sync_flop[i][1:0],async[i]}; 
      
      end
  end
//sequential output of bit_sunc
//the last bits of the reg(sync_flop)  
  always @(*)
  begin
    for (i=0; i<4; i=i+1)
    sync[i] = sync_flop[i][1] ; 
  end
  
endmodule


