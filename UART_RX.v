
module UART_RX 

(
 input   wire                          CLK,
 input   wire                          RST,
 input   wire                          RX_IN,
 input   wire                          PAR_EN,
 input   wire                          PAR_TYP,
 input   wire   [4:0]                  Prescale, 
 output  wire   [7:0]       p_data, 
 output  wire                          data_valid,
 output  wire                          par_error,
output  wire                           stop_error
);

//internal connections
wire   [3:0]           bit_count ;
wire   [3:0]           edge_count ;
wire                   edge_bit_en; 
wire                   deser_en; 
wire                   par_check_en; 
wire                   stop_check_en; 
wire                   start_check_en; 
wire                   start_glitch;
wire                   sampled_bit;
wire                   data_samp_en;




           
FSM_rx  U_FSM (
.clk_fsm(CLK),
.rst_fsm(RST),
.RX_IN_fsm(RX_IN),
.prescale_fsm(Prescale),
.bit_count_fsm(bit_count),
.PAR_EN_fsm(PAR_EN),
.edge_count_fsm(edge_count), 
.start_glitch_fsm(start_glitch),
.par_error_fsm(par_error),
.stop_error_fsm(stop_error), 
.start_check_en_fsm(start_check_en),
.edge_bit_en_fsm(edge_bit_en), 
.deser_en_fsm(deser_en), 
.par_check_en_fsm(par_check_en), 
.stop_check_en_fsm(stop_check_en),
.data_samp_en_fsm(data_samp_en),
.data_valid_fsm(data_valid)
);
 
 
edge_bit_counter U_edge_bit_counter (
.clk_ebc(CLK),
.rst_ebc(RST),
.prescale_ebc(Prescale),
.edge_bit_en_ebc(edge_bit_en),
.bit_count_ebc(bit_count),
.edge_count_ebc(edge_count) 
); 

data_sampling U_data_sampling (
.clk_ds(CLK),
.rst_ds(RST),
.RX_IN_ds(RX_IN),
.prescale_ds(Prescale),
.data_samp_en_ds(data_samp_en),
.edge_count_ds(edge_count),
.sampled_bit_ds(sampled_bit)
);

deserializer U_deserializer (
.clk_se(CLK),
.rst_se(RST),
.prescale_se(Prescale),
.sampled_bit_se(sampled_bit),
.deser_en_se(deser_en),
.edge_count_se(edge_count), 
.p_data_se(p_data)
);

start_check U_start_check(
.clk_strc(CLK),
.rst_strc(RST),
.sampled_bit_strc(sampled_bit),
.start_check_en_strc(start_check_en), 
.start_glitch_strc(start_glitch)
);

parity_check  U_parity_check (
.clk_pc(CLK),
.rst_pc(RST),
.PAR_TYP_pc(PAR_TYP),
.sampled_bit_pc(sampled_bit),
.par_check_en_pc(par_check_en), 
.p_data_pc(p_data),
.par_error_pc(par_error)
);

stop_check U_stop_check (
.clk_stpc(CLK),
.rst_stpc(RST),
.sampled_bit_stpc(sampled_bit),
.stop_check_en_stpc(stop_check_en), 
.stop_error_stpc(stop_error)
);


endmodule
 
