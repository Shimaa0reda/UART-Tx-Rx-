
module Serializer(

input  wire [7:0] p_data_se ,
input  wire       ser_en_se ,
input  wire       clk_se,
input  wire       rst_se,
output reg        ser_done_se,
output reg        ser_data_se
  );
  
reg [3:0] ser_count;

always @(posedge clk_se or negedge rst_se)
begin
  if(!rst_se)
    begin
      ser_data_se<=0;
      ser_count<=0;
    end
    else if(ser_en_se)
      begin
        if(ser_count== 4'b1000)
          begin
            ser_count<=0;
            end
        else
          begin
            ser_data_se<=p_data_se[ser_count];
            ser_count<=ser_count+1;
            end
            
        end
        else
          begin
            ser_count<=0;
            end
end
 
 
 always @(*)
 begin
   if(ser_count==4'b1000)
     begin
       ser_done_se=1;
     end
   else
     begin
       ser_done_se=0;
     end
 end
endmodule