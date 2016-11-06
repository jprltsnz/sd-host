module register_set(
                    clk, //clock signal
                    reset, // reset active on high
                    req, // request read/write
                    ack, // acknowlage that the memory operation is done
                    address, // address of data to read/write
                    wnr, // if 0 operation is read, if 1 operation is write
                    data_in, // data to be written
                    data_out, // read data
                    mem_data_out // data of all registers
                    );

   parameter DATA_WIDTH = 16;
   parameter ADDR_WIDTH = 16;
   parameter MEM_DEPTH = 1 << ADDR_WIDTH;


   // Input ports
   input clk, reset, wnr;
   input req;
   input [ADDR_WIDTH-1:0] address;
   input [DATA_WIDTH-1:0] data_in;

   //Output ports
   output                 ack;
   output [DATA_WIDTH-1:0] data_out;
   output [DATA_WIDTH*MEM_DEPTH-1:0] mem_data_out;

   // Variable types
   logic                             clk, reset, wnr, ack;
   logic [DATA_WIDTH-1:0]            data_in, data_out;
   logic [ADDR_WIDTH-1:0]            address;
   logic [DATA_WIDTH*MEM_DEPTH-1:0]  mem_data_out;
   logic [DATA_WIDTH-1:0]            mem [0:MEM_DEPTH-1];

   for(i=0; i<MEM_DEPTH;i=i+1) begin
      assign mem_data_out[DATA_WIDTH*i+:DATA_WIDTH] = mem[i];
   end

   always @(posedge clk) begin
      if(reset) begin
         for(i = 0; i < MEM_DEPTH; i = i+1) begin
            mem[i] <= 0;
         end
      end

      else begin
         if(req != 0 && !wnr) begin
            data_out <= [address << 1];
            ack <= 1;
         end
         if(req !=0 && wnr) begin
            mem[address << 1] <= data_in;
            ack <=1;
            data_out <=0;
         end
         else begin
            data <=0;
            ack <=0;
            end
      end
   end
endmodule // register_set
