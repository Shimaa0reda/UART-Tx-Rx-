//NUM STAGES refer to Number of Flip Flop Stages
  //BUS_WIDTH  refer to Width of synchronized signal  
module DATA_SYNC

 (
  input wire                   CLK,
  input wire                   RST,
  input wire  [7:0] unsync_bus,
  input wire                   bus_enable,
  output reg   [7:0] sync_bus,
  output reg                    enable_pulse            
  );
  
   //internal connections
   reg   [2:0]    sync_flop;
   reg pulse_generator_flop;
   reg [7:0] sync_bus_internal;
   reg enable_pulse_internal;
//////////////////////////////////////////
   //output of multistages flipflops
  always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
         sync_flop<= 'b0 ;
     
      end
    else
      begin
       
         sync_flop <= {sync_flop[1:0],bus_enable} ; 
      
      end
  end
  
  //////////////////////////////////////////////
  //output of ff inside pulse generator
  always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        
         pulse_generator_flop<= 'b0 ;
     
      end
    else
      begin
       
         pulse_generator_flop <=sync_flop[2] ; 
      
      end
  end
////////////////////////////////////////////////
// combinational output of pulse generator 
always @(*)
  begin
     enable_pulse_internal=!pulse_generator_flop&&sync_flop[2];
     
  end
////////////////////////////////////////////////////
//sequential output of pulse generator
  always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
         enable_pulse<= 'b0 ;
     
      end
    else
      begin
       
         enable_pulse <=enable_pulse_internal ; 
      
      end
  end
///////////////////////////////////////////

//output of mux 

//while there is no pulse(selection=0) remain 

//the same value on output bus
always @(*)
  begin
    case(enable_pulse_internal)
      0:begin
        sync_bus_internal=sync_bus;
      end
      1:begin
        sync_bus_internal=unsync_bus;
      end
    endcase
      end
//////////////////////////////////////////////
//the final output of data sync
always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
         sync_bus<= 'b0 ;
     
      end
    else
      begin
       
         sync_bus <=sync_bus_internal ; 
      
      end
  end
endmodule



