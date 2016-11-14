module serializer(
	clk, 		//clock to send serialized data on out line
	reset, 		//reset counter to 0 on high
	in, 		//deserialized data
	out 		//serialized data
);
	
	parameter BITS = 48;		//size of serializer
	parameter BITS_COUNTER = 6;	//size of counter, must be at least log2(BITS)
	
	input clk, reset;
	input [BITS-1:0] in;
	
	output reg out;
	reg [BITS_COUNTER-1:0] counter;	//we need to know which array item (in) to read from
		
	always@(reset) begin
		counter = 0;
	end
	
	
	always@(posedge clk) begin
		out <= in[counter];
		if(~reset) begin			//as long we're not resetting the counter
			counter = counter + 1;	//next item
		end
	end
	
endmodule