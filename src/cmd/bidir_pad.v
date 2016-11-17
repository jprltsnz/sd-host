module bidir_pad(
	in, 
	out,
	io,
	oen
);
	input in, oen;
	output out;
	inout io;
	
	assign io = !oen ? in : 1'bz;	//input enabled, io working as an output
	assign out = oen ? io : 1'bz;	//output enable, io working as an input
	
endmodule