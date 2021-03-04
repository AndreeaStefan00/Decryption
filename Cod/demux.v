module demux #(
		parameter MST_DWIDTH = 32,
		parameter SYS_DWIDTH = 8
	)(
		// Clock and reset interface
		input clk_sys,
		input clk_mst,
		input rst_n,
		
		//Select interface
		input[1:0] select,
		
		// Input interface
		input [MST_DWIDTH -1  : 0]	 data_i,
		input 						 	 valid_i,
		
		//output interfaces
		output reg [SYS_DWIDTH - 1 : 0] 	data0_o,
		output reg     						valid0_o,
		
		output reg [SYS_DWIDTH - 1 : 0] 	data1_o,
		output reg     						valid1_o,
		
		output reg [SYS_DWIDTH - 1 : 0] 	data2_o,
		output reg     						valid2_o
    );
	
reg [SYS_DWIDTH - 1 : 0] vector [3:0];
reg[1:0] i;
reg[1:0] i_next;
reg[2:0] count; // variabila care numara ciclurile de ceas mst
reg[2:0] count_clk; 
reg valid_i_reg;

always@(posedge clk_mst) begin

	if(!rst_n) begin
		vector[0] <= 0;
		vector[1] <= 0;
		vector[2] <= 0;
		vector[3] <= 0;
	end 
	else if(rst_n) begin
		valid_i_reg <= valid_i;
		if(valid_i)	begin	
			vector[0] <= data_i[31:24];
			vector[1] <= data_i[23:16];
			vector[2] <= data_i[15:8];
			vector[3] <= data_i[7:0];
		end
		count <= count_clk;
	end

end

always@(posedge clk_sys) begin

	if(rst_n) begin
		i <= i_next;	
	end
	
end

always@(*) begin
	if(!rst_n) begin
		count_clk = 0;
		data0_o = 0;
		data1_o = 0;
		data2_o = 0;
		valid0_o = 0;
		valid1_o = 0;
		valid2_o = 0;
		i_next = 0;
	end 
	if (rst_n) begin
		if (valid_i) begin
			count_clk = count + 1; // count creste cand se introduc date la intrare
		end  

		if(count >= 1) begin // daca a trecut un clk_mst, se incepe afisarea datelor
				case(select)
					2'b00: begin
						data0_o = vector[i];
						valid0_o = 1;
						i_next = i + 1;
					end
					2'b01: begin
						data1_o = vector[i];
						valid1_o = 1;
						i_next = i + 1;	
					end
					2'b10: begin
						data2_o = vector[i];
						valid2_o = 1;
						i_next = i + 1;
					end
				endcase
						
		end
		 if (count == 2) begin // dupa fiecare 2 cicluri mst, variabila se reseteaza la 1
			count_clk = 1;			
		end

		if (valid_i_reg == 0) begin 
			data0_o = 0;
			data1_o = 0;
			data2_o = 0;
			valid0_o = 0;
			valid1_o = 0;
			valid2_o = 0;
		end
		
	end	
end

endmodule 