module subbytes32(
	data_in,
	data_out
	);
	
	input [31:0] data_in;
	output [31:0] data_out;
	
	bytesub sb0(.BS_in(data_in[7:0]  ), .BS_out(data_out[7:0]  ));
	bytesub sb1(.BS_in(data_in[15:8] ), .BS_out(data_out[15:8] ));
	bytesub sb2(.BS_in(data_in[23:16]), .BS_out(data_out[23:16]));
	bytesub sb3(.BS_in(data_in[31:24]), .BS_out(data_out[31:24]));
endmodule