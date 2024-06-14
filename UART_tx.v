module UART_tx(
  input   wire [7:0] P_DATA ,
  input   wire       Data_Valid, 
  input   wire       PAR_EN ,
  input   wire       CLK ,
  input   wire       RST ,
  input   wire       PAR_TYP,
  output  wire       TX_OUT,
  output  wire       busy);
  
  //internal connections
  wire ser_done,ser_en;
  wire ser_data,par_bit;
  wire [1:0] mux_sel;
  
  
FSM U_fsm (
.data_valid_fsm(Data_Valid),
.ser_done_fsm(ser_done),
.ser_en_fsm(ser_en),
.busy_fsm(busy),
.mux_sel_fsm(mux_sel),
.clk_fsm(CLK),
.rst_fsm(RST),
.par_en_fsm(PAR_EN)
);

Serializer U_serializar (
.p_data_se(P_DATA),
.ser_done_se(ser_done),
.ser_en_se(ser_en),
.ser_data_se(ser_data),
.clk_se(CLK),
.rst_se(RST)
);

Parity_calc U_parity_calc (
.clk_parity(CLK),
.rst_parity(RST),
.p_data_parity(P_DATA),
.data_valid_parity(Data_Valid),
.par_bit_parity(par_bit),
.par_typ_parity(PAR_TYP),
.par_en_parity(PAR_EN)
);


MUX U_mux (
.mux_sel_mux(mux_sel),
.par_bit_mux(par_bit),
.tx_out_mux(TX_OUT),
.ser_data_mux(ser_data),
.clk_mux(CLK),
.rst_mux(RST)
);

endmodule
