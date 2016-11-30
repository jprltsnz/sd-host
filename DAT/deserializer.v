module deserializer(
	clk, 		//serialized data proper clock
	enable, 	//suspend while enable on low
	reset, 		//set output to zero and reset counter to 0 on high
	framesize, 	//number of bits to be deserialized
	in, 		//serialized data
	out, 		//deserialized data
	complete	//reset counter to 0 and hold out's data while high
);

	parameter BITS = 32;		//size of deserializer
	parameter BITS_COUNTER = 8;	//size of counter, must be at least log2(BITS)

	input clk, enable, reset, in;
	input [BITS_COUNTER-1:0] framesize;

	output reg complete;
	output reg [BITS-1:0] out;
	reg [BITS_COUNTER-1:0] counter;	//we need to know which array item (out) to write on

	always@(posedge reset) begin
	//if (reset==1'b1) begin


		out = 32'b00000000000000000000000000000000;
		counter = 8'b00000000;
		complete = 1'b0;
	//end
	end

	always@(posedge clk) begin
		if(enable) begin
	   if (complete==1'b0) begin


				out[counter] <= in;
				counter  <= counter + 1;	//next item
				 end
			end
end

always @ ( * ) begin
	if (counter==framesize) begin
		complete=1'b1;
		end
		else begin
complete=1'b0;
		end
end


	//always@(complete) begin
		//counter  = 0;	//this way there's no need to reset every time we start a transaction (resetting all out bits consumes power)
	//end




endmodule
