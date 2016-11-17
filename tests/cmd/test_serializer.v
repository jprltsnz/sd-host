`include "src/cmd/serializer.v"

module test_serializer;

    reg reset = 0;
    reg enable = 1;
	reg [47:0] in = 48'b101011010111101011101011101010101010101001110101; // test input data
	wire out;	//serialized output
	
    initial begin
		$display("\n----------------------- Serializer test -------------------------\n");
		$display("input: %b \n", in);
		$dumpfile("tests/vcd/test_serializer.vcd");
		$dumpvars(0, test_serializer);
        # 2 reset = 1;
		# 2 reset = 0;
		# 96 $display("finished");
		reset = 1;	//counter reset to zero, reading first item
		# 4 $finish;    
    end

    reg clk = 1;
    always #1 clk = !clk;     
	
	serializer ser (.enable(enable), .clk(clk), .reset(reset), .in(in), .out(out));
    
	initial	$monitor("At time %t: out: %b", $time, out);

endmodule
