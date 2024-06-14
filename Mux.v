
module MUX(

input  wire   [1:0]   mux_sel_mux ,
input  wire           ser_data_mux ,
input  wire           par_bit_mux ,
input  wire           clk_mux,
input  wire           rst_mux,
output reg            tx_out_mux
  );
reg tx_out_internal;
always @(*)
begin
  case(mux_sel_mux)
    //start bit
    2'b00:begin
      tx_out_internal=0;
    end
    //stop_bit
    2'b01:begin
      tx_out_internal=1;
    end
    //data
    2'b10:begin
      tx_out_internal=ser_data_mux;
    end
    //parity bit
    2'b11:begin
      tx_out_internal=par_bit_mux;
    end
    endcase
end

always @(posedge clk_mux or negedge rst_mux)
begin
if(!rst_mux)
tx_out_mux<=0;
else
tx_out_mux<= tx_out_internal;
end
  endmodule
