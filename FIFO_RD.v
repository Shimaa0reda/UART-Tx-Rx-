/*module FIFO_RD # (
    
    parameter DATA_WIDTH = 8,parameter MEM_DEPTH=8
    , parameter ADDR_WIDTH=3)*/

module FIFO_RD(
 
    input  wire           r_inc_rd,
    input  wire           r_rst_rd, 
    input  wire           r_clk_rd,
    input  wire  [3:0]    rq2_wptr_rd,
    output wire           empty_rd,
    output reg   [2:0]    rd_addr_rd,
    output  reg  [3:0]    rd_ptr_rd
);
 
 //internal connections
 
 reg [3:0] ptr_internal;
 
always @(posedge r_clk_rd or negedge r_rst_rd)
       begin
         if(!r_rst_rd)
           begin
            ptr_internal<=0; 
           end
         else if(r_inc_rd && !empty_rd)
           begin
            ptr_internal<=ptr_internal+1; 
           end
         else
           begin
             
           end
       end
/////////////////////////////////////////////
//assign rd_addr_rd=ptr_internal[2:0];
always @(posedge r_clk_rd or negedge r_rst_rd)
       begin
         if(!r_rst_rd)
           begin
            rd_ptr_rd<=0;
             rd_addr_rd<=0;
           end
         else 
           begin
         case(ptr_internal)
           4'b0000:begin
             rd_ptr_rd<=4'b0000;
             rd_addr_rd<=3'b000;
           end
           4'b0001:begin
             rd_ptr_rd<=4'b0001;
             rd_addr_rd<=3'b001;
           end
           4'b0010:begin
             rd_ptr_rd<=4'b0011;
             rd_addr_rd<=3'b010;
           end
           4'b0011:begin
             rd_ptr_rd<=4'b0010;
             rd_addr_rd<=3'b011;
           end
           4'b0100:begin
             rd_ptr_rd<=4'b0110;
             rd_addr_rd<=3'b100;
           end
           4'b0101:begin
             rd_ptr_rd<=4'b0111;
             rd_addr_rd<=3'b101;
           end
           4'b0110:begin
             rd_ptr_rd<=4'b0101;
             rd_addr_rd<=3'b110;
           end
           4'b0111:begin
             rd_ptr_rd<=4'b0100;
             rd_addr_rd<=3'b111;
           end
           4'b1000:begin
             rd_ptr_rd<=4'b1100;
             rd_addr_rd<=3'b000;
           end
           4'b1001:begin
             rd_ptr_rd<=4'b1101;
             rd_addr_rd<=3'b001;
           end
           4'b1010:begin
             rd_ptr_rd<=4'b1111;
             rd_addr_rd<=3'b010;
           end
           4'b1011:begin
             rd_ptr_rd<=4'b1110;
             rd_addr_rd<=3'b011;
           end
           4'b1100:begin
             rd_ptr_rd<=4'b1010;
             rd_addr_rd<=3'b100;
           end
           4'b1101:begin
             rd_ptr_rd<=4'b1011;
             rd_addr_rd<=3'b101;
           end
           4'b1110:begin
             rd_ptr_rd<=4'b1001;
             rd_addr_rd<=3'b110;
           end
           4'b1111:begin
             rd_ptr_rd<=4'b1000;
             rd_addr_rd<=3'b111;
           end
         endcase
       end
       end
    //////////////////////////////////////////////   
       assign empty_rd=(rq2_wptr_rd==rd_ptr_rd);
  
endmodule

