
module Async_fifo 
 (
   input                    i_w_clk,              // write domian operating clock
   input                    i_w_rstn,             // write domian active low reset  
   input                    i_w_inc,              // write control signal 
   input                    i_r_clk,              // read domian operating clock
   input                    i_r_rstn,             // read domian active low reset 
   input                    i_r_inc,              // read control signal
   input   [7:0]     i_w_data,             // write data bus 
   output  [7:0]     o_r_data,             // read data bus
   output                   o_full,               // fifo full flag
   output                   o_empty               // fifo empty flag

);


wire [2:0] r_addr , w_addr ;
wire [3:0] w2r_ptr , r2w_ptr ;
wire [3:0] gray_w_ptr , gray_rd_ptr ;
//wire              full ;

/*fifo_mem u_fifo_mem (
.w_clk(i_w_clk),              
.w_rstn(i_w_rstn),
.w_inc(i_w_inc),                             
.w_full(o_full),              
.w_addr(w_addr),            
.r_addr(r_addr),
.w_data(i_w_data),                        
.r_data(o_r_data)
);*/
  
fifo_mem u_fifo_mem (
.w_clk_mem(i_w_clk),              
.w_rst_mem(i_w_rstn),
.w_inc_mem(i_w_inc),                             
.full_mem(o_full),              
.wr_addr_mem(w_addr),            
.rd_addr_mem(r_addr),
.wr_data_mem(i_w_data),                        
.rd_data_mem(o_r_data)
); 

FIFO_RD U_fifo_rd  (
.r_clk_rd(i_r_clk),              
.r_rst_rd(i_r_rstn),             
.r_inc_rd(i_r_inc),              
.rq2_wptr_rd(w2r_ptr),                
.rd_addr_rd(r_addr),            
.rd_ptr_rd(gray_rd_ptr),        
.empty_rd(o_empty)
);
/*
fifo_rd U_fifo_rd  (
.r_clk(i_r_clk),              
.r_rstn(i_r_rstn),             
.r_inc(i_r_inc),              
.sync_wr_ptr(w2r_ptr),                
.rd_addr(r_addr),            
.gray_rd_ptr(gray_rd_ptr),        
.empty(o_empty)
);
*/
        
BIT_SYNC_FIFO  u_w2r_sync (
.clk(i_r_clk) ,
.rst(i_r_rstn) ,
.async(gray_w_ptr) ,
.sync(w2r_ptr)
);

fifo_wr U_fifo_wr(            
.wr_clk_wr(i_w_clk),              
.wr_rst_wr(i_w_rstn),             
.wr_inc_wr(i_w_inc),            
.wq2_rptr_wr(r2w_ptr),                
.wr_addr_wr(w_addr),            
.wr_ptr_wr(gray_w_ptr),        
.full_wr(o_full)
);               
/*
fifo_wr U_fifo_wr(            
.w_clk(i_w_clk),              
.w_rstn(i_w_rstn),             
.w_inc(i_w_inc),            
.sync_rd_ptr(r2w_ptr),                
.w_addr(w_addr),            
.gray_w_ptr(gray_w_ptr),        
.full(o_full)
);
 */
 BIT_SYNC_FIFO  u_r2w_sync
(
.clk(i_w_clk) ,
.rst(i_w_rstn) ,
.async(gray_rd_ptr) ,
.sync(r2w_ptr)
);

endmodule
