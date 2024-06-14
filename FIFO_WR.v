module fifo_wr(
 
    input  wire                   wr_inc_wr,
    input  wire                   wr_rst_wr, 
    input  wire                   wr_clk_wr,
    input  wire   [3:0]   wq2_rptr_wr,
    output wire                  full_wr,
    output reg  [2:0] wr_addr_wr,
    output  reg  [3:0]   wr_ptr_wr
);
 
 //internal connections
 
 reg [3:0] ptr_internal;
 
always @(posedge wr_clk_wr or negedge wr_rst_wr)
       begin
         if(!wr_rst_wr)
           begin
            ptr_internal<=0; 
           end
         else if(wr_inc_wr&&!full_wr)
           begin
            ptr_internal<= ptr_internal+1; 
           end
         else
           begin
             
           end
       end
/////////////////////////////////////////////

always @(posedge wr_clk_wr or negedge wr_rst_wr)
       begin
         if(!wr_rst_wr)
           begin
            wr_ptr_wr<=0;
             wr_addr_wr<=0; 
           end
         else
           begin
         case(ptr_internal)
           4'b0000:begin
             wr_ptr_wr<=4'b0000;
             wr_addr_wr<=3'b000;
           end
           4'b0001:begin
             wr_ptr_wr<=4'b0001;
             wr_addr_wr<=3'b001;
           end
           4'b0010:begin
             wr_ptr_wr<=4'b0011;
             wr_addr_wr<=3'b010;
           end
           4'b0011:begin
             wr_ptr_wr<=4'b0010;
             wr_addr_wr<=3'b011;
           end
           4'b0100:begin
             wr_ptr_wr<=4'b0110;
             wr_addr_wr<=3'b100;
           end
           4'b0101:begin
             wr_ptr_wr<=4'b0111;
             wr_addr_wr<=3'b101;
           end
           4'b0110:begin
             wr_ptr_wr<=4'b0101;
             wr_addr_wr<=3'b110;
           end
           4'b0111:begin
             wr_ptr_wr<=4'b0100;
             wr_addr_wr<=3'b111;
           end
           4'b1000:begin
             wr_ptr_wr<=4'b1100;
             wr_addr_wr<=3'b000;
           end
           4'b1001:begin
             wr_ptr_wr<=4'b1101;
             wr_addr_wr<=3'b001;
           end
           4'b1010:begin
             wr_ptr_wr<=4'b1111;
             wr_addr_wr<=3'b010;
           end
           4'b1011:begin
             wr_ptr_wr<=4'b1110;
             wr_addr_wr<=3'b011;
           end
           4'b1100:begin
             wr_ptr_wr<=4'b1010;
             wr_addr_wr<=3'b100;
           end
           4'b1101:begin
             wr_ptr_wr<=4'b1011;
             wr_addr_wr<=3'b101;
           end
           4'b1110:begin
             wr_ptr_wr<=4'b1001;
             wr_addr_wr<=3'b110;
           end
           4'b1111:begin
             wr_ptr_wr<=4'b1000;
             wr_addr_wr<=3'b111;
           end
         endcase
       end
       end
    //////////////////////////////////////////////   
       assign full_wr=(wq2_rptr_wr[3]!=wr_ptr_wr[3])&&(wq2_rptr_wr[2]!=wr_ptr_wr[2])&&(wq2_rptr_wr[1:0]==wr_ptr_wr[1:0]);
  
endmodule


