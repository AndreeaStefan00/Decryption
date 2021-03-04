module decryption_top#(
			parameter addr_witdth = 8,
			parameter reg_width 	 = 16,
			parameter MST_DWIDTH = 32,
			parameter SYS_DWIDTH = 8
		)(
		// Clock and reset interface
		input clk_sys,
		input clk_mst,
		input rst_n,
		
		// Input interface
		input [MST_DWIDTH -1 : 0] data_i,
		input 						  valid_i,
		output busy,
		
		//output interface
		output [SYS_DWIDTH - 1 : 0] data_o,
		output      					 valid_o,
		
		// Register access interface
		input[addr_witdth - 1:0] addr,
		input read,
		input write,
		input [reg_width - 1 : 0] wdata,
		output[reg_width - 1 : 0] rdata,
		output done,
		output error
		
    );
	
wire [reg_width - 1:0] select;
wire [reg_width - 1 : 0] caesar_key;
wire [reg_width - 1 : 0] scytale_key;
wire [reg_width - 1 :0] zigzag_key;
wire [SYS_DWIDTH - 1 : 0] data0_o;
wire valid0_o;
wire [SYS_DWIDTH - 1 : 0] data1_o;
wire valid1_o;
wire [SYS_DWIDTH - 1 : 0] data2_o;
wire valid2_o;
wire [SYS_DWIDTH - 1 : 0] data_out_caesar;
wire valid_out_caesar;
wire [SYS_DWIDTH - 1 : 0] data_out_scytale;
wire valid_out_scytale;
wire [SYS_DWIDTH - 1 : 0] data_out_zigzag;
wire valid_out_zigzag;
wire busy_caesar;
wire busy_scytale;
wire busy_zigzag;


decryption_regfile register_file (clk_sys, rst_n, addr, read, write,wdata, rdata, done, error, select, caesar_key, scytale_key, zigzag_key);
demux demultiplexor (clk_sys, clk_mst, rst_n, select[1:0], data_i, valid_i, data0_o, valid0_o, data1_o, valid1_o, data2_o, valid2_o);
caesar_decryption caesar (clk_sys, rst_n, data0_o, valid0_o, caesar_key, busy_caesar, data_out_caesar, valid_out_caesar );	
scytale_decryption scytale (clk_sys, rst_n, data1_o, valid1_o, scytale_key[15:8], scytale_key[7:0], data_out_scytale, valid_out_scytale, busy_scytale );
zigzag_decryption zigzag (clk_sys, rst_n, data2_o, valid2_o, zigzag_key[7:0], busy_zigzag, data_out_zigzag, valid_out_zigzag );

or(busy, busy_caesar, busy_scytale, busy_zigzag);

mux multiplexor (clk_sys, rst_n, select[1:0], data_o, valid_o, data_out_caesar, valid_out_caesar, data_out_scytale, valid_out_scytale, data_out_zigzag, valid_out_zigzag);

endmodule
