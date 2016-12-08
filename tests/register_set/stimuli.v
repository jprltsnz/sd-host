/*
 Descripcion: Prueba que la cuenta sea correcta en algun contador)
*/
module stimuli(
                 output logic        clk,
                 output logic        reset,
                 output logic        wnr,
                 output logic [1:0]  req,
                 output logic [7:0] address,
                 output logic [31:0] data_in
                 );



   initial begin
      clk=0;
      //reset = 1;
      wnr = 0;
      req = 0;
      reset = 1;
      address = 0;
      data_in = $random;
      #15 reset=0;
      #15 req = 3;
      #15 wnr =1;
      repeat (64) begin
         #20 address = address + 4;
         wnr=1;
         data_in = $random;
         #20 wnr=0;
      end
      #30 $finish;
   end
   always begin
     #10 clk=~clk;
   end
endmodule // probador
