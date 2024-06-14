module FSM_rx  (

 input   wire           clk_fsm,
 input   wire           rst_fsm,
 input   wire    [3:0]  edge_count_fsm,
 input   wire           par_error_fsm,
 input   wire           start_glitch_fsm,
 input   wire           stop_error_fsm,
 input   wire     [3:0]  bit_count_fsm,
 input   wire           RX_IN_fsm,
 input   wire           PAR_EN_fsm,
 input   wire   [4:0]   prescale_fsm,
 output  reg            data_samp_en_fsm=0,
 output  reg            par_check_en_fsm=0,
 output  reg            start_check_en_fsm=0,
 output  reg            stop_check_en_fsm=0,
 output  reg            edge_bit_en_fsm=0,
 output  reg            deser_en_fsm=0,
 output  reg            data_valid_fsm=0
 );
 
 // gray state encoding
parameter   [2:0]      IDLE   = 3'b000,
                       start  = 3'b001,
					             data   = 3'b011,
					             parity = 3'b010,
					             stop   = 3'b110,
					             final  =3'b111;

reg         [2:0]      current_state , next_state ;

	reg flag=0;		
//state transiton 
always @ (posedge clk_fsm or negedge rst_fsm)
 begin
  if(!rst_fsm)
   begin
    current_state <= IDLE ;
   end
  else
   begin
    current_state <= next_state ;
   end
 end
 

// next state logic
always @ (*)
 begin
  case(current_state)
    
  ////////////IDLE STATE////////////  
  IDLE   : begin
      if(!RX_IN_fsm)
        begin
			 next_state = start ;
			 end
			else
			 next_state = IDLE ; 			
           end
     ////////////START STATE////////////        
           
  start  : begin
    if(bit_count_fsm==0&&edge_count_fsm==(prescale_fsm-5'b1))
      begin
       if(!start_glitch_fsm)
			 next_state = data ;     
         else
           begin
         next_state = IDLE ; 
           end
         end
       else
         begin
           next_state = start;
         end
       end
       
       
       ////////////DATA STATE////////////  
  data   : begin
      if(bit_count_fsm==4'b1000 && edge_count_fsm==(prescale_fsm-5'b1))
			 begin
			  if(PAR_EN_fsm)
			   next_state = parity ;
              else
			   next_state = stop ;		
			  end	  
			else
			 next_state = data ; 			
           end
       
       
       ////////////PARITY STATE////////////      
  parity : begin
    if(bit_count_fsm==4'b1001 && edge_count_fsm==(prescale_fsm-5'b1))
			 next_state = stop ; 
			 else
			   next_state = parity;
           end
         
         
       ////////////STOP STATE////////////    
        
  stop   : begin
    if(PAR_EN_fsm)
				begin
				  if(bit_count_fsm ==4'b1010 && edge_count_fsm == (prescale_fsm-5'b10))
			         next_state = final; 
          else
              next_state = stop; 
               
        end
      else
       if(bit_count_fsm ==4'b1001 && edge_count_fsm == (prescale_fsm-5'b10))
			         next_state = final; 
          else
              next_state = stop;
            end 
        //////////////final state //////////////////    
  final:begin
          if(!RX_IN_fsm)
            next_state=start;
          else
            next_state = IDLE;
          
        end          
   default:begin
     next_state = IDLE;
   end
            
      endcase
      end    
      
      
// output logic
always @ (*)
 begin
     edge_bit_en_fsm = 1'b0 ;
     data_samp_en_fsm=0;
     par_check_en_fsm=0;
     stop_check_en_fsm=0;
     deser_en_fsm=0;
     data_valid_fsm=0;
     start_check_en_fsm=0;
    flag=0;
    
    
  case(current_state)
  IDLE   : begin		
     if(!RX_IN_fsm)
       begin
     			edge_bit_en_fsm = 1 ;
     			data_samp_en_fsm=1;
     			start_check_en_fsm=1;
   			end
 			else
 			  begin
 			    edge_bit_en_fsm = 0 ;
     			data_samp_en_fsm=0;
     			start_check_en_fsm=0;
 			    end
           end
           
           
  start  : begin
		edge_bit_en_fsm = 1'b1 ;
     data_samp_en_fsm=1;
     start_check_en_fsm=1;
           end
           
           
  data   : begin 
			edge_bit_en_fsm = 1'b1 ;
     data_samp_en_fsm=1;
     deser_en_fsm=1;
     start_check_en_fsm=0;
           end
           
  parity : begin
            
                par_check_en_fsm=1;
                	edge_bit_en_fsm = 1'b1 ;
                data_samp_en_fsm=1;
                deser_en_fsm=0;
            
            end
          
          
          
  stop   : begin
            stop_check_en_fsm=1;
            	edge_bit_en_fsm = 1'b1 ;
              data_samp_en_fsm=1;
              par_check_en_fsm=0;
              flag=1;		
           end	
           
   final: begin
             stop_check_en_fsm=0;
            	edge_bit_en_fsm = 1'b0 ;
              data_samp_en_fsm=1;
              if(!stop_error_fsm&&!par_error_fsm)
         data_valid_fsm=1; 
       else
         	data_valid_fsm=0; 
 end        	
    endcase
               
 end 
 

endmodule


