`include "src/cmd/communication/bidir_pad.v"

module test_bidir_pad;

	reg in = 0; 
	wire out;	
	reg preio = 0;	
	wire io;	
	reg oen = 0;
	
	assign io = oen ? preio : 1'bz;

    initial begin
		$display("\n----------------------- Bidirectional pad test -------------------------\n");
		$dumpfile("tests/vcd/test_bidir_pad.vcd");
		$dumpvars(0, test_bidir_pad);
		$display("'in' reflected in 'io'");
        # 2 in = 1;  
        # 2 in = 0;  
        # 2 in = 1;  
        # 2 in = 0;  
        # 2 in = 1;  
        # 2 oen = 1;
		$display("Now 'io' is driving 'out'");
		# 2 preio = 1;  
        # 2 preio = 0;  
        # 2 preio = 1;  
        # 2 preio = 0;  
        # 2 preio = 1;
		# 2 $finish;    
    end
	
	bidir_pad bp (.in(in), .oen(oen), .out(out), .io(io));
    
	initial	$monitor("At time %t: in: %b out: %b, io: %b", $time,in, out, io);

endmodule
