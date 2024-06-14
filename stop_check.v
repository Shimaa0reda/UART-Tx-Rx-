module stop_check  (

 input   wire           stop_check_en_stpc,
 input   wire           sampled_bit_stpc,
 input   wire           clk_stpc,
 input   wire           rst_stpc,
 output  reg            stop_error_stpc=0
);


always@(posedge clk_stpc or negedge rst_stpc)
begin
  if(!rst_stpc)
    begin
     stop_error_stpc<=0;
    end
  else
    begin
      //if the stop check module is enabled
      //so if the sent stop bit=1 so stop check error=0
      //else stop check error =1
  if(stop_check_en_stpc)
    begin
      if(sampled_bit_stpc==1)
        begin
          stop_error_stpc<=0;
        end
    else
      begin
        stop_error_stpc<=1;
      end
    end
    end
end
endmodule
