
module ALU(
  //port list
  input      [7:0] A,B,
  input      [3:0]  ALU_FUN,
  input             CLK,
  input             RST,
  input             ALU_EN,
  output reg [15:0] ALU_OUT,
  output reg        OUT_valid
  );
  reg [15:0] ALU_OUT_internal;
  reg        OUT_valid_internal;


   //make the value of the counter change only when there is posegde
  always@(posedge CLK or negedge RST)
begin
if(!RST)
begin
 ALU_OUT<=0;
 OUT_valid<=0;
end
else
begin

 ALU_OUT<=ALU_OUT_internal;
 OUT_valid<=OUT_valid_internal;
end
end



  always @(*)
  begin
    if(ALU_EN)
      begin
    case(ALU_FUN)
      
     4'b0000:begin
       OUT_valid_internal=1;
       ALU_OUT_internal=A+B;
     end 
     
     4'b0001:begin
       OUT_valid_internal=1;
       ALU_OUT_internal=A-B;
       
     end
      
     4'b0010:begin
       ALU_OUT_internal=A*B;
       OUT_valid_internal=1;
     end
      
     4'b0011:begin
       ALU_OUT_internal=A/B;
       OUT_valid_internal=1;
     end
     
     4'b0100:begin
       ALU_OUT_internal=A&B;
       OUT_valid_internal=1;
     end
      
     4'b0101:begin
      ALU_OUT_internal=A|B;
      OUT_valid_internal=1;
     end 
     
     4'b0110:begin
       ALU_OUT_internal=~(A&B);
       OUT_valid_internal=1;
     end
      
     4'b0111:begin
       ALU_OUT_internal=~(A|B);
       OUT_valid_internal=1;
     end
     
     4'b1000:begin
       ALU_OUT_internal=A^B;
       OUT_valid_internal=1;
     end
      
     4'b1001:begin
       ALU_OUT_internal=A~^B;
       OUT_valid_internal=1;
     end 
     
     4'b1010:begin
       if(A==B)
         begin
            ALU_OUT_internal=16'b1;
            OUT_valid_internal=1;
         end
       else
         begin
           ALU_OUT_internal=16'b0;
           OUT_valid_internal=1;
         end
     end 
     
     4'b1011:begin
       if(A>B)
         begin
            ALU_OUT_internal=16'b10;
            OUT_valid_internal=1;
         end
       else
         begin
           ALU_OUT_internal=16'b0;
           OUT_valid_internal=1;
         end
     end
     
     4'b1100:begin
       if(A<B)
         begin
           ALU_OUT_internal=16'b11;
           OUT_valid_internal=1;
         end
       else
         begin
           ALU_OUT_internal=16'b0;
           OUT_valid_internal=1;
         end
     end
      
     4'b1101:begin
       ALU_OUT_internal=A>>1;
       OUT_valid_internal=1;
     end 
     4'b1110:begin
       ALU_OUT_internal=A<<1;
       OUT_valid_internal=1;
     end
     
     default:
     begin
       ALU_OUT_internal=0;
      OUT_valid_internal=0;
     end
     
   endcase 
 end
   end

endmodule
