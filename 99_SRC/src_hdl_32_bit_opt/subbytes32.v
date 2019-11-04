module subbytes32(
	data_in,
	data_out
	);
	
	input [31:0] data_in;
	output [31:0] data_out;

	AES_Sbox_Canright sbox1(.a(data_in[7:0]	 ), .q(data_out[7:0]  ));
	AES_Sbox_Canright sbox2(.a(data_in[15:8] ), .q(data_out[15:8] ));
	AES_Sbox_Canright sbox3(.a(data_in[23:16]), .q(data_out[23:16]));
	AES_Sbox_Canright sbox4(.a(data_in[31:24]), .q(data_out[31:24]));
endmodule