module deserializer(
	clk, 		//serialized data proper clock
	enable, 	//suspend while enable on low
	reset, 		//set output to zero and reset counter to 0 on high
	framesize, 	//number of bits to be deserialized - 1
	in, 		//serialized data
	out, 		//deserialized data
	complete	//reset counter to 0 and hold out's data while high
);
	
	parameter BITS = 136;		//size of deserializer
	parameter BITS_COUNTER = 8;	//size of counter, must be at least log2(BITS)
	parameter COUNTER_MAX = 8'hFF;	//max possible value
	
	input clk, enable, reset, in;
	input [BITS_COUNTER-1:0] framesize;
	
	output reg complete;
	output reg [BITS-1:0] out;
	reg [BITS_COUNTER-1:0] counter;	//we need to know which array item (out) to write on
		
	always@(posedge reset) begin
		out = 0;
		counter = framesize;
		complete = 0;
	end
	
	
	always@(posedge clk) begin
		if(enable) begin
			if(~complete) begin	//as long there's not any reset state, count
				out[counter] <= in;
				counter = counter - 1;	//next item
			end
		end else begin
			complete = 0;
		end
	end
	
	always@(counter) begin
		if(counter == COUNTER_MAX) begin	//all bits have been read
			complete = 1;
		end
		
	end
	
	always@(complete) begin
		counter = framesize;	//this way there's no need to reset every time we start a transaction (resetting all out bits consumes power)
	end
	
endmodule