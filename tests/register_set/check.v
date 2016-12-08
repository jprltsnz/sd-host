module check(
               input logic [31:0]   reg_input,
               input logic [31:0]   reg_out,
               input logic [31:0]   reg_out_syn,
               input logic          ack,
               input logic          ack_syn,
               input logic          clk,
               input logic          wnr,
               input logic          req,
               input logic [7:0]    address,
               input logic [2047:0] mem_out,
               input logic [2047:0] mem_out_syn
               );

   always @(*) begin
      // Tests if the data that was just written is read correctly
      if(!wnr && ack && reg_input != reg_out && req) begin
         $display("Error: Module read diffrent data from the one that was written");
         $display("Data written: %h, Data read: %h in address: %h", reg_input, reg_out, address);
         $stop;
      end
      // Test if conductual module and synthetized module have the same outputs,
      // given the same inputs
      if(mem_out != mem_out_syn && reg_out != reg_out_syn && ack != ack_syn && req) begin
         $display("Error: Synthetized module acts different");
         $display("Input data: %h, address: %h, syn_out: %h, out: %h, ack: %b, ack_syn: %b", reg_input, address, reg_out_syn, reg_out, ack, ack_syn);
         $stop;
      end
   end
endmodule // checker
