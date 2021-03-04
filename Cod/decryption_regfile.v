module decryption_regfile #(
			parameter addr_witdth = 8,
			parameter reg_width 	 = 16
		)(
			// Clock and reset interface
			input clk, 
			input rst_n,
			
			// Register access interface
			input[addr_witdth - 1:0] addr,
			input read,
			input write,
			input [reg_width -1 : 0] wdata,
			output reg [reg_width -1 : 0] rdata,
			output reg done,
			output reg error,
			
			// Output wires
			output [reg_width - 1 : 0] select,
			output [reg_width - 1 : 0] caesar_key,
			output [reg_width - 1 : 0] scytale_key,
			output [reg_width - 1 : 0] zigzag_key
    );
	 	  
reg[reg_width - 1 : 0] select_register;
reg[reg_width - 1 : 0] caesar_key_register;
reg[reg_width - 1 : 0] scytale_key_register;
reg[reg_width - 1 : 0] zigzag_key_register;
reg count; // variabila prin care verific daca am scris sau am citit 
reg count_error; // variabila prin care verific daca am ajuns in cazul de eroare 

always @(posedge clk) begin
   if(!rst_n) begin			// initializarea registrelor cu valorile de reset
	  select_register <=0;
      caesar_key_register <=0;
      scytale_key_register <=16'hFFFF;
      zigzag_key_register <=16'h2;
      error <=0;
      done <=0;
	  rdata<=0;
	end
	if(rst_n)
		case(addr)
			8'h00: begin
				if(write) begin
					select_register[1:0] <= wdata;
					count <=1;
					error <=0;
					rdata <=0;
				end
				if(read) begin
					rdata <= select_register;
					count <=1;
					error <=0;
				end
			end
			8'h10: begin
				if(write) begin
					caesar_key_register <= wdata;
					count <=1;
					error <=0;
					rdata <=0;
				end
				if(read) begin
					rdata <= caesar_key_register;
					count <=1;
					error <=0;
				end
			end	
			8'h12: begin
				if(write) begin
					scytale_key_register <= wdata;
					count <=1;
					error <=0;
					rdata <=0;
				end
					
				if(read) begin
					rdata <= scytale_key_register;
					count <=1;
					error <=0;
				end
			end
			8'h14: begin
				if(write) begin
					zigzag_key_register <= wdata;
					count <=1;
					error <=0;
					rdata <=0;
				end
				if(read) begin
					rdata <= zigzag_key_register;
					count <=1;
					error <=0;
				end
			end
			default: begin  // cazul in care se ajunge daca se vrea scriere/citire la o adresa diferita de cele ale registrelor
					count_error <= 1;
					rdata <= 0;
			end
		endcase
// verific daca am scris/citit ceva intr-un/dintr-un registru
	if(count==1) begin
		done <= 1;
		count <=0;  // se reseteaza count cu valoarea 0 pentru a putea fi folosit la urmatoarea incercare de citire/scriere
	end else if(count_error ==1) begin // verific daca am ajuns in cazul de eroare
		error <=1;
		done <= 1;
		count_error<=0;
	end else begin
	done <=0;
	error <=0;
   end
end 


assign select=select_register;
assign caesar_key=caesar_key_register;
assign scytale_key=scytale_key_register;
assign zigzag_key=zigzag_key_register;		

endmodule
