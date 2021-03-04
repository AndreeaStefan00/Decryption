module caesar_decryption #(
				parameter D_WIDTH = 8,
				parameter KEY_WIDTH = 16
			)(
			// Clock and reset interface
			input clk,
			input rst_n,
			
			// Input interface
			input[D_WIDTH - 1:0] data_i,
			input valid_i,
			
			// Decryption Key
			input[KEY_WIDTH - 1 : 0] key,
			
			// Output interface
            output reg busy,
			output reg[D_WIDTH - 1:0] data_o,
			output reg valid_o
    );


always@(posedge clk) begin
	busy <= 0;
	if(!rst_n) begin
		data_o <=0;
		valid_o <=0;
	end
	else if(rst_n) begin
		if(valid_i == 1) begin 
			data_o <= data_i - key; // se pune pe iesire valoarea decriptata a intrarii data_i
			valid_o <=1;
		end else begin 
			data_o <=0;
			valid_o <=0;
		end
	end

end



endmodule
