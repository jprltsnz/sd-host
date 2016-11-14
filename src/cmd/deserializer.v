module deserializer(
	clk, 		//serialized data proper clock
	reset, 		//set output to zero and reset counter to 0 on high
	in, 		//serialized data
	out, 		//deserialized data
	finish		//reset counter to 0 and hold out's data while high
);
	
	input clk, reset, in, finish;
	
	parameter BITS = 48;		//size of deserializer
	parameter BITS_COUNTER = 6;	//size of counter, must be at least log2(BITS)
	
	output reg [BITS-1:0] out;
	reg [BITS_COUNTER-1:0] counter;	//we need to know which array item (out) to write on
		
	always@(reset) begin
		out = 0;
		counter = 0;
	end
	
	
	always@(posedge clk) begin
		if(~finish) begin
			out[counter] <= in;
			if(~reset && ~finish) begin	//as long there's not any reset state, count
				counter = counter + 1;	//next item
			end
		end
	end
	
	always@(finish) begin
		counter = 0;
	end
	
endmodule