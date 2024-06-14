module RegFile 
(
    input  wire                   WrEn,
    input  wire                   RdEn,
    input  wire                   CLK,
    input  wire                   RST,
    input  wire  [3:0] Address,
    input  wire  [7:0]  WrData, 
    output reg   [7:0]  RdData,
   output reg            RdData_valid,
   output   wire   [7:0]  REG0,
   output   wire   [7:0]  REG1,
   output   wire   [7:0]  REG2,
   output   wire   [7:0]  REG3
);

//internal connections /////////////
reg [7:0] regArr [15:0];
integer I=0;


always @(posedge CLK or negedge RST) 
	  begin
	    if (!RST)
begin
       RdData_valid <= 1'b0 ;
	 RdData     <= 'b0 ;
      for (I=0 ; I < 16 ; I = I +1)
        begin
		 if(I==2)
          regArr[I] <= 'b010000_01 ;
		 else if (I==3) 
          regArr[I] <= 'b0010_0000 ;
         else
          regArr[I] <= 'b0 ;		 
        end

	  
       end
     else
       
   
      begin
	         regArr[2]<=8'b01000001;
	         regArr[3]<=8'b00010000;
        if (WrEn&&!RdEn) 
		  begin
            regArr[Address] <= WrData;
                 
		  end
		else if(RdEn&&!WrEn)
          begin
            RdData <= regArr[Address]; 
            RdData_valid<=1;
          end
        else
          begin 
          RdData_valid<=0;
          end
       end

end
assign REG0 = regArr[0] ;
assign REG1 = regArr[1] ;
assign REG2 = regArr[2] ;
assign REG3 = regArr[3] ;

endmodule
