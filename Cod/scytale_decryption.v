module scytale_decryption#(
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
            input[KEY_WIDTH - 1 : 0] key_N,
            input[KEY_WIDTH - 1 : 0] key_M,
            
            // Output interface
            output reg[D_WIDTH - 1:0] data_o,
            output reg valid_o,
            output reg busy
    );
reg [D_WIDTH-1 : 0] vector [MAX_NOF_CHARS-1 :0]; // vector in care se vor stoca datele de intrare
// variabile utilizate la gestiunea pozitiilor datelor din vector
reg [7:0] i;
reg [7:0] k;
reg [7:0] j;
reg [7:0] p;
reg start;

always@(posedge clk ) begin
	
	if (!rst_n) begin
		data_o <= 0;
		valid_o <= 0;
		busy <= 0;
		i <= 0;
		j <= 0;
		k <= 0;
		p <=0;
	end else if (rst_n) begin	         
			if ( data_i != START_DECRYPTION_TOKEN  && valid_i==1 && busy==0) begin 
                vector[i] <= data_i; // introducerea datelor in vector
                i  <= i + 1; // incrementare indice
            end else if(data_i == START_DECRYPTION_TOKEN && valid_i==1) begin
				// daca se ajunge la caracterul 0xFA, se pun start si busy pe 1
						busy <= 1;
						start <= 1;
			end
        	
			if (start == 1) begin 	// se incepe decriptarea 
				if ( p < key_M*key_N) begin  // key_N_reg*key_M_reg este numarul de elemente pe care le va avea vectorul
					if (k < key_N*key_M) begin 
						data_o <= vector[k]; // se pune pe iesire valoarea de pe pozitia k
						valid_o <= 1; 
						busy <= 1;
						k <= k+key_N; // k se incrementeaza cu valoarea pasului (key_N)
					end else begin
						data_o <= vector[j+1];
						j <= j+1;
						k <=  j+1+key_N; 
					end 
					p <= p+1;
					end else begin 
						busy <= 0;
						valid_o <= 0;
						data_o <= 0;
						i <= 0;
						j <= 0;
						k <= 0;
						p <= 0;
						start <= 0;
					end 
			
			end 
	end 
end

 

endmodule
