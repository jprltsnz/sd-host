module register_set #(
                     parameter DATA_WIDTH = 8,
                     parameter ADDR_WIDTH = 8,
                     parameter MEM_DEPTH = 1 << ADDR_WIDTH
                     )
                     (
                      input logic                             clk,
                      input logic                             reset,
                      input logic                             wnr,
                      input logic                             req,
                      input logic [ADDR_WIDTH-1:0]            address,
                      input logic [DATA_WIDTH-1:0]            data_in,

                    //Output ports
                      output logic                            ack,
                      output logic [DATA_WIDTH-1:0]           data_out,
                      output logic [DATA_WIDTH*MEM_DEPTH-1:0] mem_data_out
                                 );

   reg [DATA_WIDTH - 1: 0]    mem [0 : MEM_DEPTH - 1];

//   integer                    j;
   genvar                     i;


   for(i=0; i<MEM_DEPTH;i=i+1) begin
      assign mem_data_out[DATA_WIDTH*i+:DATA_WIDTH] = mem[i];
   end

   always @(posedge clk) begin
/*     if(reset) begin
         for(j = 0; j < MEM_DEPTH; j = j+1) begin
            mem[j] <= 0;
         end
      end */
      ack = 0;
      data_out = 0;

      if(wnr) begin
         if(req == 1) begin
            mem[address] = data_in;
            ack = 1;
         end
      end
      else begin
         if (req == 1) begin
         data_out = mem[address];
         ack = 1;
         end
      end

   end
endmodule // register_set
