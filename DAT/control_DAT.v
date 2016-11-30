// Code your design here
//////////////////////////////////////////////////////////////////////////////////////////////////7
//    Module: control_DAT
//    Projecto: SD Host
//
// Descripcion: Modulo de control  para el bloque DAT del SD Host , este  modulo controla las señales para  solicitud de un nuevo servicio , escritura y lectura
//  hacia la capa  fisica que se encarga de leer  y escribir desde  y hacia el fifo y la tarjeda SD
//    Autor: Mario Zamora  Rivera
//
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
module control_DAT(input logic writeRead,
                   input logic multiblock,
                   input logic timeoutenable,
                   input logic  [15:0] timeout ,
                   input logic newService,
                   input logic clock,
                   input logic reset,
                   input logic[3:0] blockSize,
                   input logic IDLE_in,
                   input logic fifo_full,
                   input logic recibido,
                   input logic transferComplete,
                   output  logic newService_fisica,
                   output  logic [15:0]  timeout_fisica,
                   output  logic writeRead_fisica,
                   output  logic reset_fisica,
                   output  logic complete,
                   output logic IDLE_out
                  );

  ////////////////////////////////////////7
  //Las  variables  que pasan desde la capa de control a la capa fisica con nombres  similares  tendran un identificador despues del _ para la capa fisica
  ////////////////////////////////////7


  parameter RESET=6'b000001, IDLE  = 6'b000010, checkfifo  = 6'b000100 ,solicitud=6'b001000 , waitResponse= 6'b010000 ,  waitIdle= 6'b100000  ;
  reg [5:0] state;
  reg [5:0] next_state;
  reg [4:0] blockCount;



  //----------Seq Logic-----------------------------------------------------seqlogic------------------------------------------------\\\\
  always @ ( posedge clock ) begin
    if (reset == 1'b1) begin
      state <=    RESET;
      blockCount<=5'b00000 ;
    //  next_state<=6'b000000 ;
    end else begin
      state <=   next_state;
    end
  end
  //----------Output Logic------------------------------------------------Output logic----------------------------------------------------\\\
  always @ (posedge clock)begin
    if (reset == 1'b1) begin
      newService_fisica<=1'b0;
      timeout_fisica<=16'b0000000000000000;
      writeRead_fisica<=1'b0;
      reset_fisica<=1'b1;
      complete<=1'b0;
      IDLE_out<=1'b0;


    end
    else begin
      case(state)
        RESET : begin///////////////////////////////////////RESET
          newService_fisica<=1'b0;
          timeout_fisica<=16'b0000000000000000;
          writeRead_fisica<=1'b0;
          reset_fisica<=1'b0;
          complete<=1'b0;
          IDLE_out<=1'b0;
          blockCount<=5'b00000 ;
        end////////////////////////////////////////////Final RESET



        IDLE : begin////////////////////////////////////IDLE
          newService_fisica<=1'b0;
          timeout_fisica<=16'b0000000000000000;
          writeRead_fisica<=1'b0;
          reset_fisica<=1'b0;
          complete<=1'b0;
          IDLE_out<=1'b1;
            blockCount<=5'b00000 ;
        end///////////////////////////////////////////Final IDLE


        checkfifo : begin////////////////////////////////checkfifo
          newService_fisica<=1'b0;
          if (timeoutenable==1'b1) begin
            timeout_fisica<=timeout;
          end
          else begin
            timeout_fisica<=16'b0000000000000000;
          end
          writeRead_fisica<=writeRead;
          reset_fisica<=1'b0;
          complete<=1'b0;
          IDLE_out<=1'b0;
          blockCount<=  blockCount+5'b00001;


        end
        solicitud : begin ///////////////////////////////////////solicitud
          newService_fisica<=1'b1;
          writeRead_fisica<=writeRead;
          reset_fisica<=1'b0;
          complete<=1'b0;
          IDLE_out<=1'b0;



        end
        waitResponse : begin
          newService_fisica<=1'b0;
          writeRead_fisica<=writeRead;
          reset_fisica<=1'b0;
          complete<=1'b0;
          IDLE_out<=1'b0;


        end
        waitIdle : begin
          newService_fisica<=1'b0;
          writeRead_fisica<=writeRead;
          reset_fisica<=1'b0;
          complete<=1'b1;
          IDLE_out<=1'b0;
        end
        default : begin
          newService_fisica<=1'b0;
          timeout_fisica<=16'b0000000000000000;
          writeRead_fisica<=1'b0;
          reset_fisica<=1'b0;
          complete<=1'b0;
          IDLE_out<=1'b0;

        end
      endcase
    end
  end // End Of Block OUTPUT_LOGIC




  //----------------------------logic block-------------------------------------------------------------logic  block---------------------------------------------̣\\\
  always @ ( * ) begin//Logica proximo estado
    next_state = 6'b000000;
  case(state)
    RESET : if (IDLE_in== 1'b1)begin/////////////////////////RESET
      next_state=IDLE;
    end
    else begin
next_state=RESET;
    end



    IDLE :if (newService== 1'b1) begin//////////////////////IDLE
      next_state=checkfifo;
    end
    else begin
next_state=IDLE;
    end

    checkfifo :if (fifo_full== 1'b1)  begin/////////////////////checkfifo
      next_state=solicitud;
    end
    else begin
next_state=checkfifo;
    end
    solicitud :if (recibido== 1'b1) begin/////////////////////////////solicitud
      next_state=waitResponse;
    end
    else  begin
next_state=solicitud;
    end
    waitResponse :if (transferComplete== 1'b1)  begin//////////////////////waitResponse
      next_state=waitIdle;
    end
    else  begin
next_state=waitResponse;
    end


    waitIdle:////////////////////////////////////////////////waitIdle
     if (IDLE_in== 1'b1) begin
       if ((multiblock==0)||(blockCount==blockSize+1)) begin
          next_state=IDLE;
        end
    else   begin
        //  blockCount=blockCount+1;
          next_state=checkfifo;

        end

end
else  begin
next_state=waitIdle;
end
  /*      if (multiblock==1) begin
        if (blockCount==blockSize) begin
            next_state=IDLE;
        end
        else begin
    //    blockCount=blockCount+1;
        next_state=checkfifo;
        end

        end
else  begin
next_state=IDLE;

end*/


    default : begin
      next_state=IDLE;
    end
  endcase


  end//////////////////////////////////end combinational block










endmodule
