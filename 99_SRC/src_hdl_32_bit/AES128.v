module AES128(
	clock,
	reset,
	ce,
	data_in,
	key,
	data_out,
	done
	);
	
	input clock;
	input reset;
	input ce;
	input [127:0] data_in;
	input [127:0] key;
	output [127:0] data_out;
	output reg done;
	
	reg [5:0] counter;
	wire [3:0] roundcounter = counter[5:2];
	wire [1:0] stepcounter = counter[1:0];
	
	wire [127:0] data;
	wire [31:0] data32;
	
	wire [127:0] keOut;
	wire [31:0]  keOut32;
	
	wire [31:0] arkIn;
	wire [31:0] arkOut;
	
	wire [31:0] sbOut;
	
	wire [127:0] srIn;
	wire [127:0] srOut;
	
	wire [31:0] mcOut;
	
	assign data_out = srIn;
	assign data  = (roundcounter <= 1) ? data_in : srOut;
	assign arkIn = (roundcounter > 1 && roundcounter < 11) ? mcOut : data32;
	
	b128to32   data32c(.dataIn(data),                                   .nr(stepcounter), .dataOut(data32));
	b128to32   key32c (.dataIn(keOut),                                  .nr(stepcounter), .dataOut(keOut32));
	b32to128_2 sr128c (.dataIn((roundcounter >= 11) ? arkOut : sbOut),  .nr(stepcounter), .dataOut(srIn), .clock(clock), .reset(reset), .enable(!done & ce));
	
	Keyscheduler ke(.clock(clock), .reset(reset), .ce(ce & (stepcounter == 3)), .roundcounter(roundcounter), .key(key), .key_out(keOut));
	AddRoundKey32 ark(.dataIn(arkIn), .keyIn(keOut32), .dataOut(arkOut));
	subbytes32 sb(.data_in(arkOut), .data_out(sbOut));
	shiftrow sr(.shiftrow_in(srIn), .shiftrow_out(srOut));
	mixcolumn32 mc(.MC_in(data32), .MC_out(mcOut));
	
	always @(posedge clock or posedge reset)
	begin
		if (reset)
		begin
			done = 0;
			counter = 6'h3;
		end
		else
		begin
			if (ce)
			begin
				//counters
				if (!done)
				begin
					if (roundcounter > 11)
						done = 1;
					
					counter = counter + 1;
				end
			end
			else
			begin
				if (done)
				begin
					done = 0;
					counter = 6'h3;
				end
			end
		end
	end
endmodule
	