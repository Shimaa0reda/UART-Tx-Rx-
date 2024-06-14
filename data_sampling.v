module data_sampling  (

 input   wire           RX_IN_ds,
 input   wire   [4:0]        prescale_ds,
 input   wire           data_samp_en_ds,
 input   wire   [3:0]   edge_count_ds,
 input   wire           clk_ds,
 input   wire           rst_ds,
 output  reg            sampled_bit_ds=0);
 
 //internal connections
 reg sample_1,sample_2,sample_3;
 wire [0:3] half;
 wire [0:3] half_plus;
 wire [0:2] half_minus;
 assign half =((prescale_ds>>1)-4'b1) ;
 assign half_plus=half+1;
 assign half_minus=half-1;
 
 always @ (posedge clk_ds or negedge rst_ds)
 begin
   if(!rst_ds)
     
begin
     sample_1<=0;
     sample_2<=0;
     sample_3<=0;
   end
   else
     begin
       //take 3 samples from input data to check 
       //the real value of the input bit
       if(data_samp_en_ds)
         begin
           if(edge_count_ds==half_minus)
           sample_1<=RX_IN_ds;
         else if(edge_count_ds==half) 
         sample_2<=RX_IN_ds;
         else if(edge_count_ds==half_plus) 
         sample_3<=RX_IN_ds;
       else 
       begin
     end       
     end
     
else
begin
  sample_1<=0;
     sample_2<=0;
     sample_3<=0;
end
   end
 end
 
 
 
   always @ (posedge clk_ds or negedge rst_ds)
 begin
   if(!rst_ds)
     begin
       sampled_bit_ds<=0;
     end
   else
     begin
       //decide the real value of the input bit
      if(data_samp_en_ds)
begin
   if(sample_1==1&&sample_2==1&&sample_3==1)
             sampled_bit_ds<=1;
             
            else if(sample_1==0&&sample_2==0&&sample_3==0)
            sampled_bit_ds<=0;
            
            else if(sample_1==1&&sample_2==1&&sample_3==0)
            sampled_bit_ds<=1;
            
            else if(sample_1==1&&sample_2==0&&sample_3==1)
            sampled_bit_ds<=1;
            
            else if(sample_1==0&&sample_2==1&&sample_3==1)
            sampled_bit_ds<=1;
            
            else if(sample_1==0&&sample_2==0&&sample_3==1)
            sampled_bit_ds<=0;
            
            else if(sample_1==0&&sample_2==1&&sample_3==0)
            sampled_bit_ds<=0;
          else
            sampled_bit_ds<=0;
         
end
else
sampled_bit_ds<=0;
end
 end
endmodule
