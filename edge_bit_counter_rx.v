module edge_bit_counter  (
 input   wire           clk_ebc,
 input   wire           rst_ebc,
 input   wire           edge_bit_en_ebc,
 input   wire  [4:0]         prescale_ebc,
 output  reg   [3:0]         edge_count_ebc,
 output  reg   [3:0]         bit_count_ebc
);

always @(posedge clk_ebc or negedge rst_ebc)
   begin
     if(!rst_ebc)
       begin
         edge_count_ebc<=0;
       end
     else if(edge_bit_en_ebc)
       begin
         if(edge_count_ebc==(prescale_ebc-4'b1))
           begin
             edge_count_ebc<=0;
           end
         else
           begin
            edge_count_ebc<=edge_count_ebc+1; 
           end
          end
        else
          begin
           edge_count_ebc<=0 ;
          end
           
       end
  //////////////////////////////////////////////
  always @(posedge clk_ebc or negedge rst_ebc)
   begin
     if(!rst_ebc)
       begin
         bit_count_ebc<=0;
       end
     else if(edge_bit_en_ebc)
       begin
         if(edge_count_ebc==(prescale_ebc-4'b1))
           begin
             bit_count_ebc<=bit_count_ebc+1;
           end
          end
        else
          begin
          bit_count_ebc<=0 ;
          end
           
       end
  
 



endmodule

