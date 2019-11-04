module b32to128_2(
	clock,
	reset,
	enable,
	dataIn,
	nr,
	dataOut
	);
	
	input clock;
	input reset;
	input enable;
	input [31:0] dataIn;
	input [1:0] nr;
	output reg [127:0] dataOut;
	reg [95:0] tmp;
	
	always @(posedge clock)
	if (reset)
	begin
		tmp = 0;
		dataOut = 0;
	end
	else
	begin
		if (enable)
		begin
			if (nr == 2'h0)
		 		tmp[95:64] = dataIn;
		 	else if (nr == 2'h1)
		 		tmp[63:32] = dataIn;
		 	else if (nr == 2'h2)
		 		tmp[31:0] = dataIn;
		 	else if (nr == 2'h3)
		 		dataOut = {tmp, dataIn};
		end
	end
endmodule
