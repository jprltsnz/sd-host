module serializer(
	clk, 		//clock to send serialized data on out line
	reset, 		//reset counter to 0 on high
	enable, 	//serialize while enable on high
	in, 		//deserialized data
	out, 		//serialized data
	complete	//completion flag
);
	
	parameter BITS = 48;		//size of serializer
	parameter BITS_COUNTER = 6;	//size of counter, must be at least log2(BITS)

	input clk, reset, enable;
	input [BITS-1:0] in;
	
	output reg out, complete;
	reg [BITS_COUNTER-1:0] counter;	//we need to know which array item (in) to read from
		
	always@(posedge reset) begin
		counter = BITS - 1;
		complete = 0;
	end
	
	
	always@(posedge clk) begin
		if(enable) begin	//when counter gets to limit, it'll stop counting until it's reset
			if(counter==0) begin
				complete <= 1;
			end else begin	
				out <= in[counter];
			end
			if(~reset) begin			//as long we're not resetting the counter
				counter = counter - 1;	//next item
			end
		end
	end
	
	
	
endmodule