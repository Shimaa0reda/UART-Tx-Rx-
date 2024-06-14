module deserializer  (

 input   wire               deser_en_se,
 input   wire               sampled_bit_se,
 input   wire   [3:0]       edge_count_se,
 input   wire               clk_se,
 input   wire               rst_se,
 input   wire    [4:0]       prescale_se,
 output  reg    [7:0]       p_data_se=0
);
integer i=0;


always@(posedge clk_se or negedge rst_se)
begin
  if(!rst_se)
    begin
     p_data_se<=0;
    end
  else
    begin
      //if deserializer is enabled and edge count 
      //reach each max value which indicate that new samples
      //bit is on wire now so take this value to the output port
  if(deser_en_se && edge_count_se==(prescale_se-5'b1))
    
    begin
      
     p_data_se[i]<=sampled_bit_se;
	i<=i+1;
    end
    end
end
endmodule