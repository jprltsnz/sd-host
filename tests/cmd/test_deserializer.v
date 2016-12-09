`include "src/cmd/communication/deserializer.v"

module test_deserializer;

    reg reset = 0;
    reg enable = 1;
    wire complete;		
    reg in = 0;			//serialized input
	reg [7:0] framesize = 11;			//serialized input
	wire [135:0] out;	//deserialized data
	
	reg [135:0] input_values = 136'b1010101010101011010100100100101010100100101010101101010101010100101011010010101101101111010111010111010101010101101101010101101101010100; // test input data
	reg [5:0] counter = 0;
	
    initial begin
		$display("\n----------------------- Deserializer test -------------------------\n");
		$dumpfile("tests/vcd/test_deserializer.vcd");
		$dumpvars(0, test_deserializer);
        # 2 reset = 1;  
        # 2 reset = 0;  
		# 94 enable = 0;	//out should remain the same for 2 cycles
		$display("Enabled\n");
		# 26 reset = 1;
		# 2 $finish;    
    end

    reg clk = 0;
    always #1 clk = !clk;     
	always #2 counter = counter + 1;   //next item on array  
	always@(posedge clk) begin
		in <= input_values[counter];
	end
	
	always@(posedge complete) begin
		$display("Disabled\n");
		enable = 0;
	end
	
	deserializer des (.clk(clk), .reset(reset), .in(in), .out(out), .enable(enable), .complete(complete), .framesize(framesize));
    
	initial	$monitor("At time %t: %b, out: %b complete: %b", $time,in,out,complete);

endmodule
