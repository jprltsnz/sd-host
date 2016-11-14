`include "src/cmd/deserializer.v"

module test_deserializer;

    reg reset = 1;
    reg finish = 0;		
    reg in = 0;			//serialized input
	wire [47:0] out;	//deserialized data
	
	reg [47:0] input_values = 48'b101011010111101011101011101010101010101001110100; // test input data
	reg [5:0] counter = 0;
	
    initial begin
		$display("\n----------------------- Deserializer test -------------------------\n");
		$dumpfile("tests/vcd/test_deserializer.vcd");
		$dumpvars(0, test_deserializer);
        # 2 reset = 0;  
		# 96 finish = 1;	//out should remain the same for 2 cycles
		# 4 reset = 1;
		# 2 $finish;    
    end

    reg clk = 0;
    always #1 clk = !clk;     
	always #2 counter = counter + 1;   //next item on array  
	always@(posedge clk) begin
		in <= input_values[counter];
	end
	
	deserializer des (.clk(clk), .reset(reset), .in(in), .out(out), .finish(finish));
    
    initial	$monitor("At time %t: %b, out: %b", $time,in,out);

endmodule
