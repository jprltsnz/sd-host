`include "register_set.v"
`include "stimuli.v"
`include "register_set_syn.v"
`include "check.v"
module register_set_tb();
// Wires
   logic [7:0] address;
   logic [31:0] data_in;
   logic [1:0]  req;
   logic [2047:0] mem_out;
   logic [2047:0] mem_out_syn;
   logic          ack, ack_syn, clk, reset, wnr;
   logic [31:0]   data_out, data_out_syn;

   initial begin
      $dumpfile("tests/vcd/reg_set.vcd");
      $dumpvars(0, register_set_tb);
   end
// modulos
   stimuli s(
              .clk(clk),
              .reset(reset),
              .wnr(wnr),
              .req(req),
              .address(address),
              .data_in(data_in)
              );

   register_set DUT(
                    .clk(clk),
                    .reset(reset),
                    .wnr(wnr),
                    .req(req),
                    .address(address),
                    .mem_data_out(mem_out),
                    .data_out(data_out),
                    .ack(ack),
                    .data_in(data_in)
                    );

   register_set_syn DUT_Syn(
                            .clk(clk),
                            .reset(reset),
                            .wnr(wnr),
                            .req(req),
                            .address(address),
                            .mem_data_out(mem_out_syn),
                            .data_out(data_out_syn),
                            .ack(ack_syn),
                            .data_in(data_in)
                            );
   check chck(
              .reg_input(data_in),
              .reg_out(data_out),
              .reg_out_syn(data_out_syn),
              .ack(ack),
              .ack_syn(ack_syn),
              .clk(clk),
              .wnr(wnr),
              .address(address),
              .mem_out(mem_out),
              .mem_out_syn(mem_out_syn)
              );

endmodule
