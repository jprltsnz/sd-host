`include "register_set.v"
`include "stimuli.v"
module register_set_tb();
// Wires
   logic [7:0] address;
   logic [7:0] data_in;
   initial begin
      $dumpfile("reg_set.vvp");
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
                  .data_in(data_in)
                  );

endmodule
