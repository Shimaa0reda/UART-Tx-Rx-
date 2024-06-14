

module Parity_calc(
input   wire                  clk_parity,
 input   wire                  rst_parity,
 input   wire                  par_en_parity,
input  wire  [7:0]     p_data_parity ,
input  wire           data_valid_parity ,
input  wire           par_typ_parity,
output reg            par_bit_parity
  );
integer i;
reg  [3:0] xor_data;
reg  [7:0] p_data_internal;

always @(posedge clk_parity or negedge rst_parity)
begin
  if(!rst_parity)
    begin
      p_data_internal<=0;
    end
    else
      begin
        if(par_en_parity)
          begin
            p_data_internal<=p_data_parity;
            end
        end
end 

always @(*)
begin
  if(par_en_parity)
    begin
      xor_data = ^p_data_internal;
      
      if(par_typ_parity && !xor_data)
        begin
          par_bit_parity=1;
        end
      else if(!par_typ_parity && xor_data)
        begin
          par_bit_parity=1;
        end
      else
        begin
          par_bit_parity=0;
        end
    end
    else
      begin
        xor_data=0;
        par_bit_parity=0;
        end
end
endmodule