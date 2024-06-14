 module fifo_mem(
    input  wire                  full_mem,
    input  wire                   w_clk_mem,
    input  wire                   w_rst_mem,
    input  wire  [2:0] wr_addr_mem,
    input  wire  [2:0] rd_addr_mem,
    input  wire                    w_inc_mem,
    input  wire  [7:0]  wr_data_mem, 
    output wire   [7:0]  rd_data_mem
);
  
reg [7:0] memory [7:0];
 integer i=0;
 


always @(posedge w_clk_mem or negedge w_rst_mem) 
	  begin
	    if (!w_rst_mem)
	      begin
          memory[0]<=8'b0;
         memory[1]<=8'b0;
         memory[2]<=8'b0;
         memory[3]<=8'b0;
         memory[4]<=8'b0;
         memory[5]<=8'b0;
         memory[6]<=8'b0;
         memory[7]<=8'b0;
end
     else
       begin
       
         if (w_inc_mem&&!full_mem) 
		  begin
            memory[wr_addr_mem] <= wr_data_mem;
		  end
end
       
end
assign rd_data_mem= memory[rd_addr_mem];  
         
endmodule
