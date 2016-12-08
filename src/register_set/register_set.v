module register_set #(
                     parameter DATA_WIDTH = 8,
                     parameter ADDR_WIDTH = 8,
                     parameter MEM_DEPTH = 1 << ADDR_WIDTH
                     )
                     (
                      input logic                             clk,
                      input logic                             reset,
                      input logic                             wnr,
                      input logic [1:0]                       req,
                      input logic [ADDR_WIDTH-1:0]            address,
                      input logic [4*DATA_WIDTH-1:0]          data_in,

                    //Output ports
                      output logic                            ack,
                      output logic [4*DATA_WIDTH-1:0]         data_out,
                      output logic [DATA_WIDTH*MEM_DEPTH-1:0] mem_data_out
                                 );

   reg [DATA_WIDTH - 1: 0]    mem [0 : MEM_DEPTH - 1];

   integer                    j;
   genvar                     i;


   for(i=0; i<MEM_DEPTH;i=i+1) begin
      assign mem_data_out[DATA_WIDTH*i+:DATA_WIDTH] = mem[i];
   end

   always @(posedge clk) begin
      if(reset) begin
         for(j=0; j<256;j=j+1)
           mem[j]=0;
         data_out=0;
         ack=0;
      end

      else begin
         ack <= 0;
         data_out <= 0;
         if(wnr) begin
            if(req == 1) begin
               mem[address] <= data_in[DATA_WIDTH-1:0];
               ack <= 1;
            end
            if(req == 2) begin
               mem[address] <= data_in[DATA_WIDTH-1:0];
               mem[address+1] <= data_in[2*DATA_WIDTH-1:DATA_WIDTH];
               ack <= 1;
            end
            if(req == 3) begin
               mem[address] <= data_in[DATA_WIDTH-1:0];
               mem[address+1] <= data_in[2*DATA_WIDTH-1:DATA_WIDTH];
               mem[address+2] <= data_in[3*DATA_WIDTH-1:2*DATA_WIDTH];
               mem[address+3] <= data_in[4*DATA_WIDTH-1:3*DATA_WIDTH];
               ack <= 1;
            end
         end
         else begin
            if (req == 1) begin
               data_out[DATA_WIDTH-1:0] <= mem[address];
               ack <= 1;
            end
            if(req == 2) begin
               data_out[DATA_WIDTH-1:0] <= mem[address];
               data_out[2*DATA_WIDTH-1:DATA_WIDTH] <= mem[address+1];
               ack <= 1;
            end
            if(req == 3) begin
               data_out[DATA_WIDTH-1:0] <= mem[address];
               data_out[2*DATA_WIDTH-1:DATA_WIDTH] <= mem[address+1];
               data_out[3*DATA_WIDTH-1:2*DATA_WIDTH] <= mem[address+2];
               data_out[4*DATA_WIDTH-1:3*DATA_WIDTH] <= mem[address+3];
               ack <= 1;
            end // if req == 3
         end // else (wnr)
      end // else (reset)
   end // always
endmodule // register_set
