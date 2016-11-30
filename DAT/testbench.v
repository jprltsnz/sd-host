module  testbench(  input logic writeRead,
  input logic newService,
  input logic multiblock,
  input logic timeoutenable,
  input logic reset,
  input logic[3:0] blockSize,
  input logic fifo_full,
  input logic  [15:0] timeout ,
  input logic SDclock,
  input logic clock,
  input logic [31:0] fromFifo_toPS,
  input logic  fromSD_SP,
  output  wire complete,
  output wire toSD_PS,
  output wire  padState,// entrada o salida del pad
  output wire padEnable, //habilita el oad
  output wire timeOutFail,
  output wire [31:0] fromSP_toFifo,
  output wire pop,
  output wire push,
  output wire IDLE_out);

DAT DUT0(.writeRead(writeRead),.newService(newService),.multiblock(multiblock),.timeoutenable(timeoutenable), .reset(reset),.blockSize(blockSize)
,.fifo_full(fifo_full),.timeout(timeout) ,.SDclock(SDclock),.clock(clock),.fromFifo_toPS(fromFifo_toPS),.fromSD_SP(fromSD_SP), .complete(complete),
.toSD_PS(toSD_PS),.padState(padState),.padEnable(padEnable), .timeOutFail(timeOutFail),.fromSP_toFifo(fromSP_toFifo),.pop(pop),.push(push),.IDLE_out(IDLE_out));
probador DUT1( .writeRead(writeRead),.pop(pop),.push(push),.newService(newService),.multiblock(multiblock),.timeoutenable(timeoutenable), .reset(reset),.blockSize(blockSize)
,.fifo_full(fifo_full),.timeout(timeout) ,.SDclock(SDclock),.clock(clock),.fromFifo_toPS(fromFifo_toPS),.fromSD_SP(fromSD_SP));


endmodule
