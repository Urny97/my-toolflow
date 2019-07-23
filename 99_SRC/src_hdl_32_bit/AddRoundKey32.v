module AddRoundKey32(
	dataIn,
	keyIn,
	dataOut
	);
	
	input [31:0] dataIn;
	input [31:0] keyIn;
	output [31:0] dataOut;
	
	assign dataOut = dataIn ^ keyIn;
	
endmodule