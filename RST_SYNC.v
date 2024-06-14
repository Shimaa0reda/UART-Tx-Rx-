//NUM STAGES refer to Number of Flip Flop Stages
  
module RST_SYNC
 (
  input wire                   CLK,
  input wire                   RST,
  output reg              SYNC_RST             
  );
  
  //internal connections 
  reg [1:0] sync_flop ;
   
  
   
  always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
         sync_flop<= 'b0 ;
     
      end
    else
      begin
      //the output is all the values on flip flops 
      //of the stages and final bit =required value
      //to be the output on RST_SYNC
         sync_flop <= {sync_flop[0],1'b1} ; 
      
      end
  end
  
  always @(*)
  begin
    SYNC_RST = sync_flop[1] ; 
  end
  
endmodule

