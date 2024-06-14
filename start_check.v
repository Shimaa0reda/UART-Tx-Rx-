module start_check  (

 input   wire           start_check_en_strc,
 input   wire           sampled_bit_strc,
 input   wire           clk_strc,
 input   wire           rst_strc,
 output  reg            start_glitch_strc=0
);

always@(posedge clk_strc or negedge rst_strc)
begin
  if(!rst_strc)
    begin
     start_glitch_strc<=0; 
    end
  else
    begin
      //if the start check module is enabled
      //so if the sent stop bit=0 so start glitch=0
      //else start glitch =1

  if(start_check_en_strc)
    begin
      if(sampled_bit_strc==0)
        begin
          start_glitch_strc<=0;
        end
    else
      begin
        start_glitch_strc<=1;
      end
    end
end
end

endmodule
