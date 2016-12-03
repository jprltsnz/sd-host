// Code your design here
module serializer(
  clk, 		//clock to send serialized data on out line
  reset, 		//reset counter to 0 on high
  enable, 	//serialize while enable on high
  in,
  complete,		//deserialized data
  out 		//serialized data
);

  parameter BITS = 32;		//size of serializer
  parameter BITS_COUNTER = 6;	//size of counter, must be at least log2(BITS)

  input clk, reset, enable;
  input [BITS-1:0] in;

  output reg complete;
  output reg out;
  reg [5:0] counter;	//we need to know which array item (in) to read from

  //	always@(posedge reset) begin
  //	counter = 0;
  //	complete = 0;
  //	end


  always@(posedge clk) begin

    if (reset==1) begin
      counter <= 6'b000000;
			complete <=0;
    end
    else  begin
      if(enable && ~(counter==BITS)) begin	//when counter gets to limit, it'll stop counting until it's reset
        out <= in[counter];
    		//as long we're not resetting the counter
          counter  <= counter + 6'b000001;
          complete <=0;	//next item

			end
      else if (counter==BITS)begin
        complete <=1;
				counter  <=6'b000000;
      end
			else  begin
			counter <= 6'b000000;
			complete <=0;
			end



  end
end


endmodule
