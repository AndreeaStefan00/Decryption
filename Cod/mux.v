module mux #(
		parameter D_WIDTH = 8
	)(
		// Clock and reset interface
		input clk,
		input rst_n,
		
		//Select interface
		input[1:0] select,
		
		// Output interface
		output reg[D_WIDTH - 1 : 0] data_o,
		output reg						 valid_o,
				
		//output interfaces
		input [D_WIDTH - 1 : 0] 	data0_i,
		input   							valid0_i,
		
		input [D_WIDTH - 1 : 0] 	data1_i,
		input   							valid1_i,
		
		input [D_WIDTH - 1 : 0] 	data2_i,
		input     						valid2_i
    );


always@( posedge clk) begin

	if(!rst_n) begin
		data_o <= 0;
		valid_o <= 0;
	end else if (rst_n) begin
		case (select)
			2'b00: begin
				if (valid0_i) begin
					data_o <= data0_i;
					valid_o <= 1;
				end else begin
					data_o <= 0;
					valid_o <= 0;
				end 
			end
	
			2'b01: begin
				if (valid1_i) begin
					data_o <= data1_i;
					valid_o <= 1;
				end else begin
					data_o <= 0;
					valid_o <= 0;
				end
			end
			
			2'b10: begin
				if (valid2_i) begin
					data_o <= data2_i;
					valid_o <= 1;
				end else begin
					data_o <= 0;
					valid_o <= 0;
				end
			end

		endcase
	end


end


endmodule

