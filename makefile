

all : DAT DAT.vcd DAT1 DAT1.vcd 
#all : contador32sy contar32sy.vcd contador32 contar32.vcd synth32.v  #contador #contar.vcd synth.v 



#synth.v: contadorscript.ys contador.v
#	yosys contadorscript.ys
#synth32.v:contador32script.ys contador32.v
#yosys contador32script.ys

DAT: DAT.v
	iverilog -o DAT DAT.v probador.v  testbench.v
	
DAT.vcd:DAT
	vvp DAT

DAT1: DATsyn.v
	iverilog -o DAT1 DATsyn.v probador1.v  testbench.v
	
DAT1.vcd:DAT1
	vvp DAT1	

	
#contador32sy: synth32.v  contador32_tb.v probador3.v 
#	iverilog -o contador32sy synth32.v   contador32_tb.v probador3.v	
	

#contador32: contador32.v  contador32_tb.v probador2.v 
#	iverilog -o contador32  contador32.v  contador32_tb.v probador2.v		
	
	
# -gspecify 

#contar.vcd:contador
#	vvp contador
	
#contar32sy.vcd:contador32sy
#	vvp contador32sy	

	
#contar32.vcd:contador32
#	vvp contador32		
clear: DAT.vcd  DAT DAT1.vcd  DAT1
	rm DAT.vcd  DAT DAT1.vcd  DAT1