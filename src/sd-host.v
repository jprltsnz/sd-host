module sd_host(
               input logic         clk,
               input logic         reset,
               // Register set inputs/outputs form CPU
               input logic         wnr,
               input logic [1:0]   req,
               input logic [7:0]   address,
               input logic [31:0]  data_in,
               output logic        ack,
               output logic [31:0] data_out,

);


register_block register_block(
                              .clk(clk),
                              .reset(reset),
                              .wnr(wnr),
                              .req(req),
                              .address(address),
                              .data_out(data_out),
                              .ack(ack),
                              .data_in(data_in)
                              );



endmodule // sd_host
