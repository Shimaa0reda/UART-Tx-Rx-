


module FSM(

input  wire       data_valid_fsm ,
input  wire       ser_done_fsm ,
input  wire       clk_fsm,
input  wire       rst_fsm,
input  wire       par_en_fsm,
output reg        ser_en_fsm,
output reg        busy_fsm,
output reg    [1:0]    mux_sel_fsm
  );
  //fsm states
localparam [2:0] 
IDLE=3'b000,
START=3'b001,
DATA=3'b011,
PARITY=3'b010,
STOP=3'b110;

reg [2:0] current_state=0 ,next_state=0;

always @(posedge clk_fsm or negedge rst_fsm)
begin
  if(!rst_fsm)
    begin
      current_state<=IDLE;
    end
  else 
    begin
      current_state<=next_state;
    end
end  
//next state logic and output    
  always @(*)
  begin
    //initial values
    busy_fsm=0;
    ser_en_fsm=0;
    mux_sel_fsm=0;
    
    case(current_state)
      IDLE:begin
        busy_fsm=0;
        ser_en_fsm=0;
        mux_sel_fsm=2'b01;
        if(data_valid_fsm)
          begin
            next_state=START;
          end
        else
          begin
            next_state=IDLE;
          end
      end
      START:begin
        busy_fsm=1;
        ser_en_fsm=1;
        mux_sel_fsm=2'b00;
        next_state=DATA;
      end
      
      DATA:begin
        busy_fsm=1;
        ser_en_fsm=1;
        mux_sel_fsm=2'b10;
        if(ser_done_fsm)
          begin
            if(par_en_fsm)
              begin
                next_state = PARITY;
              end
            else
              begin
              next_state = STOP;
            end
          end
        else
          begin
            next_state = DATA;
          end
      end
      
      PARITY:begin
        busy_fsm=1;
        ser_en_fsm=0;
        mux_sel_fsm=2'b11;
        next_state = STOP;
      end
      
      STOP:begin
        busy_fsm=1;
        ser_en_fsm=0;
        mux_sel_fsm=2'b01;
        if(data_valid_fsm)
          begin
            next_state = START;
          end
        else
          begin
            next_state = IDLE;
          end
      end
      default:begin
        next_state=IDLE;
      end
    endcase
  end

endmodule


