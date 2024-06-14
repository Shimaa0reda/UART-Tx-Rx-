module parity_check  (

 input   wire           par_check_en_pc,
 input   wire           PAR_TYP_pc,
 input   wire           sampled_bit_pc,
 input   wire   [7:0]   p_data_pc,
 input   wire           clk_pc,
 input   wire           rst_pc,
 output  reg            par_error_pc=0
);

 reg parity_bit=0;
reg par_error_internal=0;
always @ (*)
 begin
     
    if (par_check_en_pc)
	 begin
	//calculate the parity of data to compare it with the sent parity bit   
	  case(PAR_TYP_pc)
	  1'b0 : begin   
//even parity              
	          parity_bit = ^p_data_pc ; 
	  
	         end
	  1'b1 : begin
//odd parity
	          parity_bit = ~^p_data_pc ;     
	         end		
	  endcase

//check if the calculated parity is equal to the sent parity bit

if(sampled_bit_pc==parity_bit) 
  begin
    par_error_internal=0;
  end
else
  begin
    par_error_internal=1;
  end	 
	 end
 end 

always @ (posedge clk_pc or negedge rst_pc)
begin
if(!rst_pc)
begin
par_error_pc<=0;
end
else
begin
if(par_check_en_pc)
begin
par_error_pc<=par_error_internal;
end
end
end
endmodule
