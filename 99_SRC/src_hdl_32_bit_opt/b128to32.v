module b128to32(
	dataIn,
	nr,
	dataOut
	);
	
	input [127:0] dataIn;
	input [1:0] nr;
	output [31:0] dataOut;
	
	/*
		nr | dataOut
		---|---------------
		00 | dataIn[127:96]
		01 | dataIn[95:64]
		10 | dataIn[63:32]
		11 | dataIn[31:0]
	*/
	assign dataOut = (nr[1] ? (nr[0] ? dataIn[31:0] : dataIn[63:32]) : (nr[0] ? dataIn[95:64] : dataIn[127:96]));
endmodule