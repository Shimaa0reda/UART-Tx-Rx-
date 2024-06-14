module TOP_5(

  input wire  [7:0]      d_s_d,
  input wire        d_s_p,
  input wire        CLK,
  input wire        RST,
  input wire        busy,
  input wire        CLK_RX,

  //output reg        CLK_EN
 output wire  [7:0]      RD_DATA_FIFO,
  output wire            EMPTY,
  
  output wire  [7:0]      REG2,
  output wire  [7:0]      REG3

);


//internal connections
wire [7:0] DATA_SYNC_DATA;
wire DATA_SYNC_PULSE;
wire WrEN;
wire RdEN;
wire [3:0] Address;
wire [7:0] WrData;
wire [7:0] RdData;
wire RdData_valid;
wire [7:0] REG0;
wire [7:0] REG1;
wire [15:0] ALU_OUT;
wire        OUT_valid;
wire  [3:0] ALU_FUN;
wire        ALU_EN;
wire        WR_INC;
wire    pulse_sig_PULSE_GEN;
wire    [7:0] WR_DATA_FIFO;
wire          FIFO_FULL;
wire           RD_INC;
///////////////////////////////////////////////


SYS_CTRL U_SYS_CTRL(
.ALU_OUT(ALU_OUT),
.OUT_valid(OUT_valid),
.RX_D_VLD(DATA_SYNC_PULSE),
.RX_P_DATA(DATA_SYNC_DATA),
.RdData(RdData),
.RdData_valid(RdData_valid),
.CLK(CLK),
.RST(RST),
.ALU_EN(ALU_EN),
.ALU_FUN(ALU_FUN),
.Address(Address),
.WrEN(WrEN),
.RdEN(RdEN),
.WrData(WrData),
.WR_DATA_FIFO(WR_DATA_FIFO),
.WR_INC(WR_INC),
.FIFO_FULL(FIFO_FULL),
.CLKDIV_EN(CLKDIV_EN),
.CLKG_EN(CLKG_EN)

);


DATA_SYNC U_DATA_SYNC(
.CLK(CLK),
.RST(RST),
.unsync_bus(d_s_d),
.sync_bus(DATA_SYNC_DATA),
.bus_enable(d_s_p),
.enable_pulse(DATA_SYNC_PULSE)
);


reg_file U_reg_file(
.CLK(CLK),
.RST(RST),
.WrEn(WrEN),
.RdEn(RdEN),
.Address(Address),
.WrData(WrData),
.RdData(RdData),
.RdData_valid(RdData_valid),
.REG0(REG0),
.REG1(REG1),
.REG2(REG2),
.REG3(REG3)
);

 
ALU U_ALU(
.A(REG0),
.B(REG1),
.ALU_FUN(ALU_FUN),
.CLK(CLK),
.RST(RST),
.ALU_EN(ALU_EN),
.ALU_OUT(ALU_OUT),
.OUT_valid(OUT_valid)
);

PULSE_GEN U_PULSE_GEN (
.clk(CLK),
.rst(RST),
.lvl_sig(WR_INC),
.pulse_sig(pulse_sig_PULSE_GEN)
);
PULSE_GEN U_PULSE_GEN_FIFO (
.clk(CLK),
.rst(RST),
.lvl_sig(busy),
.pulse_sig(RD_INC)
);

Async_fifo U_Async_fifo(
.i_w_clk(CLK),
.i_w_rstn(RST),
.i_w_inc(pulse_sig_PULSE_GEN),
.i_r_clk(CLK_RX),
.i_r_rstn(CLK),
.i_r_inc(RD_INC),
.i_w_data(WR_DATA_FIFO),
.o_r_data(RD_DATA_FIFO),
.o_full(FIFO_FULL),
.o_empty(EMPTY)


);
 endmodule 

