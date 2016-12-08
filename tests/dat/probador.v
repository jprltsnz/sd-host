module probador(input logic pop,
  input logic push,
     output logic writeRead,
  output logic newService,
  output logic multiblock,
  output logic timeoutenable,
  output logic reset,
  output logic[3:0] blockSize,
  output logic fifo_full,
  output logic  [15:0] timeout ,
  output logic SDclock,
  output logic clock,
  output logic [31:0] fromFifo_toPS,
  output  logic  fromSD_SP);




initial begin
//reset
#0 writeRead=0;
#0 newService=0;
#0 multiblock =1;
#0 reset=1;
#0timeoutenable=0;
#0 blockSize=4'b0001;
 #0 fifo_full =1;
 #0 timeout=0;
  #0 fromFifo_toPS=32'b11000000000000000000000000000011;
  #0 fromSD_SP=0;
  #30 reset=0;
//escritura a la SD
#40 writeRead=1;
#0 newService=1;
#50 newService=0;
#700 fromSD_SP=1;
#20  fromSD_SP=0;
#20  fromSD_SP=1;
#20  fromSD_SP=0;
#20  fromSD_SP=0;
#20  fromSD_SP=1;
#20  fromSD_SP=0;
  #180fromFifo_toPS=32'b11000000000000001110000000000000;
  #80  fromSD_SP=1;
  #20  fromSD_SP=1;
  #20  fromSD_SP=1;
  #20  fromSD_SP=1;
  #20  fromSD_SP=1;
  #20  fromSD_SP=1;
#20  fromSD_SP=1;
#3000 $finish;

end


  initial begin
    clock = 0;
    forever begin
      #5 clock = ~clock;
    end
  end

  initial begin
    SDclock = 0;
    forever begin
      #15 SDclock = ~SDclock;
    end
  end



  initial  begin
  //$display("\t\ttime,\tclk,\tmodo,\tenable,\tQ");
  //$monitor("%d,\t%b,\t%b,\t%b,\t%b",$time, clk,modo,enb,Q);
  $dumpfile ("tests/vcd/DAT.vcd");
  $dumpvars;
  end
endmodule
