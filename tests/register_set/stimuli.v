/*
 Descripcion: Prueba que la cuenta sea correcta en algun contador)
*/
module probador (
                 output logic clk,
                 output logic reset,
                 output logic wnr,
                 output logic req,
                 output logic [7:0] address,
                 output logic [7:0] data_in
                 );



   initial begin
      clk=0;
      reset = 0;
      wnr = 0;
      req = 0;
      address = 0;
      data_in = 5;
      #15 req = 1;
      #15 wnr =1;
      repeat (2047) begin
         #20 address = address + 1;
      end
      #30 $finish;
   end
   always begin
     #10 clk=~clk;
   end
endmodule // probador
