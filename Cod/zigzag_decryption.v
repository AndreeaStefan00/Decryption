module zigzag_decryption #(
				parameter D_WIDTH = 8,
				parameter KEY_WIDTH = 8,
				parameter MAX_NOF_CHARS = 50,
				parameter START_DECRYPTION_TOKEN = 8'hFA
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

reg [D_WIDTH-1 : 0] vector [MAX_NOF_CHARS-1 :0];

reg [7:0] i;
reg [7:0] k;
reg [7:0] j;
reg [7:0] nr_char; // variabila in care se numara valorile introduse in vector
reg [7:0] x; // in variabila x se va salva jumatatea vectorului de date
reg start;

always@(posedge clk ) begin
	if(!rst_n) begin
            data_o <= 0;
            valid_o <= 0;
            busy <= 0;
			i <= 0;
			j <= 0;
			k <= 0;
			start <= 0;
			nr_char <= 0;
	end else if (rst_n) begin
          
		if (valid_i == 1 && data_i != START_DECRYPTION_TOKEN && busy == 0) begin
				vector[j] <= data_i;
				nr_char <= nr_char + 1;
				j <= j + 1;				
         end else if(data_i == START_DECRYPTION_TOKEN && valid_i==1) begin
			// daca se ajunge la caracterul 0xFA, se pun start si busy pe 1
				start <= 1;
				busy <= 1;
				j <= 0;
				if(nr_char[0] == 0) begin 					
					x <= (nr_char >> 1); // x este jumatatea vectorului 
				end else begin						
					x <= (nr_char >>1) +1;
				end
		end
		
		if (start == 1) begin // se incepe decriptarea 
				if (k < nr_char) begin
					valid_o <= 1;
					busy <= 1;
					if (k[0] == 0) begin 
						data_o <= vector[k >> 1];
						k <= k+1;
					end else if (k[0] == 1) begin
						data_o <= vector[x + (k >> 1)];
						k <= k+1;
					end
									
				end else begin 
					valid_o <= 0;
					busy <= 0;
					k <= 0;
					start <= 0;
					nr_char <= 0;
					data_o <= 0;
				end				
		end 	
		end 
		
	
end


endmodule
