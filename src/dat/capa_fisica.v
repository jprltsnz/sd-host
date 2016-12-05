
// Code your design here
//////////////////////////////////////////////////////////////////////////////////////////////////7
//    Module: capa_fisica
//    Projecto: SD Host
//
// Descripcion: Modulo capa_fisica , se encarga directmente de la lectura y escritura de datos desde el buffer hacia la SD y en sentido inverso
//    Autor: Mario Zamora  Rivera
//
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
module capa_fisica(input logic writeRead_control,
                   input logic timeoutenable,
                   input logic  [15:0] timeout ,
                   input logic newService_control,
                   input logic SDclock,
                   input logic reset,
                   input logic transmision_SD,//trasmision hacia la SD completada
                   input logic reception_SD,// reception de datos desde la sd completada
                   input logic [31:0] fromFifo_toPS,
                   //           input logic [31:0] fromSP_fifo,
                   input logic  fromSD_SP,//
                   //  input logic fromPS_SD,
                   output logic recibido,// señal nuevo servicio recibida
                   output logic transferComplete,//señal proceso completado
                   output logic pop,
                   output logic push,
                   output logic IDLE_out_control, // señal sin actividad
                   output logic timeOutFail,
                   output logic loadsend,
                   output logic enable_PS,
                   output logic enable_SP,
                   output logic padState,// entrada o salida del pad
                   output logic padEnable, //habilita el oad
                   output logic [31:0] fromSP_toFifo,
                   output logic [31:0] toPS_fromFifo,
                   output logic  toSD_PS
                   //     output logic toSP_SD
                  );

  ////////////////////////////////////////7
  //Las  variables  que pasan desde la capa de control a la capa fisica con nombres  similares  tendran un identificador despues del _ para la capa fisica
  ////////////////////////////////////7


  parameter RESET=9'b000000001;
  parameter IDLE  =9'b000000010;
  parameter fifoRead=9'b000000100;// Se recibio señal de trasmision y avisa
  parameter paraleloSerial=9'b000001000; // carga  datos al serializador
  parameter send=9'b000010000 ;//comienza trasmision de datos
  parameter waitResponse=9'b000100000 ;//espera  respuesta
  parameter  readSD=9'b001000000; //
  parameter  serialParalelo=9'b010000000;
  parameter poppush=9'b100000000 ;




  logic [8:0] state;
  logic [8:0] next_state;
  //wire [31:0] fisica_PS;
  //wire [31:0]  inSP;
  //reg [31:0] flip_PS;
  reg [15:0] timeCount;
  reg serializerReset;
  reg [7:0] framesize;
  wire [31:0]  SP_fifo;
  wire wireSD_PS;
  reg deserializerReset;


  //assign fromSP_toFifo= SP_fifo;
  deserializer SP(.clk(SDclock),.reset(deserializerReset),.enable(enable_SP) ,.in(fromSD_SP),.out( SP_fifo),.complete(reception_SD),.framesize(framesize));
  serializer PS(.clk(SDclock),.reset(serializerReset),.enable(enable_PS) ,.in( toPS_fromFifo),.out(wireSD_PS),.complete(transmision_SD));



  //----------Seq Logic-----------------------------
  always @ ( posedge SDclock ) begin
    if (reset == 1'b1) begin
      state <=    RESET;
    end else begin
      state <=   next_state;
    end
  end
  //----------Output Logic-----------------------------
  always @ (posedge SDclock)
    if (reset == 1'b1) begin
  //  next_state = 9'b000000000;
      recibido<=0;// señal nuevo servicio recibida
      transferComplete<=0;//señal proceso completado
      pop<=0;
      push<=0;
      IDLE_out_control<=0; // señal sin actividad
      timeOutFail<=0;
      loadsend<=0;
      enable_PS<=0;
      enable_SP<=0;
      padState<=0;// entrada o salida del pad
      padEnable<=0; //habilita el oad
      toPS_fromFifo<=32'b00000000000000000000000000000000;
      serializerReset<=1;
      deserializerReset<=1;
      framesize<=8'b00000000;
      timeCount=16'b0000000000000000;
      fromSP_toFifo<=32'b00000000000000000000000000000000;
      toSD_PS<=0;
      //  outPS<=32'b00000000000000000000000000000000;
    end
  else begin


    case(state)
      RESET : begin
        recibido<=0;// señal nuevo servicio recibida
        transferComplete<=0;//señal proceso completado
        pop<=0;
        push<=0;
        IDLE_out_control<=0; // señal sin actividad
        timeOutFail<=0;
        loadsend<=0;
        enable_PS<=0;
        enable_SP<=0;
        padState<=0;// entrada o salida del pad
        padEnable<=0; //habilita el oad
        toPS_fromFifo<=32'b00000000000000000000000000000000;
        serializerReset<=1;
          deserializerReset<=1;
        framesize<=8'b00000000;
        timeCount=16'b0000000000000000;
        fromSP_toFifo<=32'b00000000000000000000000000000000;
        toSD_PS<=0;
      end////////////////////////////////////////////////////////////Final RESET



      IDLE : begin
        recibido<=0;// señal nuevo servicio recibida
        transferComplete<=0;//señal proceso completado
        pop<=0;
        push<=0;
        IDLE_out_control<=1; // señal sin actividad
        timeOutFail<=0;
        loadsend<=0;
        enable_PS<=0;
        enable_SP<=0;
        padState<=0;// entrada o salida del pad
        padEnable<=0; //habilita el oad
        toPS_fromFifo<=32'b00000000000000000000000000000000;
        serializerReset<=0;
          deserializerReset<=0;
        framesize<=8'b00000001;
        timeCount=16'b0000000000000000;
        fromSP_toFifo<= SP_fifo;
        toSD_PS<=wireSD_PS;
      end///////////////////////////////////////////////////////////Final IDLE



      fifoRead : begin
        recibido<=1;// señal nuevo servicio recibida
        transferComplete<=0;//señal proceso completado
        pop<=0;
        push<=0;
        IDLE_out_control<=0; // señal sin actividad
        timeOutFail<=0;
        loadsend<=0;
        enable_PS<=0;
        enable_SP<=0;
        padState<=0;// entrada o salida del pad
        padEnable<=0; //habilita el oad
        toPS_fromFifo<=fromFifo_toPS;
        serializerReset<=0;
          deserializerReset<=1;
      framesize<=8'b00001000;
        timeCount=16'b0000000000000000;
        fromSP_toFifo<=SP_fifo;
        toSD_PS<=wireSD_PS;
      end////////////////////////////////////////////////////////////////Final fifoRead





      paraleloSerial : begin
        recibido<=1;// señal nuevo servicio recibida
        transferComplete<=0;//señal proceso completado
        pop<=0;
        push<=0;
        IDLE_out_control<=0; // señal sin actividad
        timeOutFail<=0;
        loadsend<=0;
        enable_PS<=1;
        enable_SP<=0;
        padState<=1;// entrada o salida del pad
        padEnable<=1; //habilita el oad
        toPS_fromFifo<=fromFifo_toPS;
        serializerReset<=0;
          deserializerReset<=0;
      framesize<=8'b00001000;
        timeCount=16'b0000000000000000;
        fromSP_toFifo<= SP_fifo;
        toSD_PS<=wireSD_PS;
      end//////////////////////////////////////////////////////////////////Final paraleloSerial

      send : begin
      recibido<=0;// señal nuevo servicio recibida
      transferComplete<=0;//señal proceso completado
      pop<=0;
      push<=0;
      IDLE_out_control<=0; // señal sin actividad
      timeOutFail<=0;
      loadsend<=1;
      enable_PS<=1;
      enable_SP<=0;
      padState<=1;// entrada o salida del pad
      padEnable<=1; //habilita el oad
      toPS_fromFifo<=fromFifo_toPS;
      serializerReset<=0;
        deserializerReset<=0;
framesize<=8'b00001000;
      timeCount=16'b0000000000000000;
      fromSP_toFifo<= SP_fifo;
      toSD_PS<=wireSD_PS;
      end///////////////////////////////////////////////////////////////////Final send


      waitResponse : begin
        recibido<=0;// señal nuevo servicio recibida
        framesize<=8'b00001000;
        enable_SP<=1;
        padState<=0;// entrada o salida del pad
        padEnable<=1; //habilita el oad
        push<=0;
        IDLE_out_control<=0;// señal sin actividad
        loadsend<=0;
        enable_PS<=0;
        toSD_PS<=32'b00000000000000000000000000000000;
        transferComplete<=0;
        serializerReset<=1;
          deserializerReset<=0;
        fromSP_toFifo<=SP_fifo;
        toSD_PS<=wireSD_PS;
        if (timeoutenable==1) begin
        if (reception_SD==1) begin
          transferComplete<=1;//señal proceso completado
          loadsend<=0;
          enable_PS<=0;
          enable_SP<=0;
          padState<=0;// entrada o salida del pad
          padEnable<=0; //habilita el oad
          framesize<=8'b00001000;
            pop<=1;
        end
        else begin
          if (timeCount==timeout) begin
            timeCount=16'b0000000000000000;
            timeOutFail<=1;
          end
          else begin
            timeCount=timeCount+1;
            timeOutFail<=0;
          end
        end
end
else  begin
if (reception_SD==1) begin
  transferComplete<=1;//señal proceso completado
  loadsend<=0;
  enable_PS<=0;
  enable_SP<=0;
  padState<=0;// entrada o salida del pad
  padEnable<=0; //habilita el oad
framesize<=8'b00001000;
end
end


      end//////////////////////////////////////////////////////////////////////Final waitResponse


      readSD : begin
        recibido<=1;// señal nuevo servicio recibida
        transferComplete<=0;//señal proceso completado
        pop<=0;
        push<=0;
        IDLE_out_control<=0; // señal sin actividad
        timeOutFail<=0;
        loadsend<=0;
        enable_PS<=0;
        enable_SP<=1;
        padState<=0;// entrada o salida del pad
        padEnable<=1; //habilita el oad
        toPS_fromFifo<=32'b00000000000000000000000000000000;
        serializerReset<=0;
        framesize<=8'b00100000;
        timeCount=16'b0000000000000000;
        fromSP_toFifo<=32'b00000000000000000000000000000000;
          deserializerReset<=0;
        toSD_PS<=wireSD_PS;
      end////////////////////////////////////////////////////////////////////////Final readSD
      serialParalelo : begin
        recibido<=1;// señal nuevo servicio recibida
        transferComplete<=0;//señal proceso completado
        pop<=0;
        push<=1;
        IDLE_out_control<=0; // señal sin actividad
        timeOutFail<=0;
        loadsend<=0;
        enable_PS<=0;
        enable_SP<=1;
        padState<=0;// entrada o salida del pad
        padEnable<=1; //habilita el oad
        toPS_fromFifo<=32'b00000000000000000000000000000000;
        serializerReset<=0;
          deserializerReset<=0;
        framesize<=8'b00100000;
        timeCount=16'b0000000000000000;
        fromSP_toFifo<= SP_fifo;
        toSD_PS<=wireSD_PS;
      end///////////////////////////////////////////////////////////////////Final  serialParalelo


      poppush : begin
        recibido<=0;// señal nuevo servicio recibida
        transferComplete<=1;//señal proceso completado
          deserializerReset<=1;
/*
        if (writeRead_control==1) begin
          pop<=1;
          push<=0;
        end
        else begin
          pop<=0;
          push<=1;
        end*/
        IDLE_out_control<=0; // señal sin actividad
        timeOutFail<=0;
        loadsend<=0;
        enable_PS<=0;
        enable_SP<=0;
        padState<=0;// entrada o salida del pad
        padEnable<=0; //habilita el oad
        toPS_fromFifo<=32'b00000000000000000000000000000000;
        serializerReset<=0;
        framesize<=00000001;
        timeCount=16'b0000000000000000;
        fromSP_toFifo<= SP_fifo;
        toSD_PS<=wireSD_PS;
      end/////////////////////////////////////////////////////////7FInal popush



      default : begin
        recibido<=0;// señal nuevo servicio recibida
        transferComplete<=0;//señal proceso completado
        pop<=0;
        push<=0;
        IDLE_out_control<=0; // señal sin actividad
        timeOutFail<=0;
        loadsend<=0;
        enable_PS<=0;
        enable_SP<=0;
        padState<=0;// entrada o salida del pad
        padEnable<=0; //habilita el oad
        toPS_fromFifo<=32'b00000000000000000000000000000000;
        serializerReset<=0;
        framesize<=00100000;
        timeCount=16'b0000000000000000;
        fromSP_toFifo<= SP_fifo;
        toSD_PS<=wireSD_PS;
      end
    endcase

  end // End Of Block OUTPUT_LOGIC

  //----------------------------logic block----------------------------------------
  always @ ( * ) begin//Logica proximo estado
    next_state = 9'b000000000;
    case(state)
      RESET : begin
        next_state=IDLE;
      end

      IDLE :if (newService_control== 1'b1) begin
        if (writeRead_control==1) begin
          next_state=fifoRead;
        end
        else begin
        next_state=readSD;
      end
      end
else  begin
next_state=IDLE;
end

      fifoRead : begin
        next_state=paraleloSerial;
      end

      paraleloSerial :begin
        next_state=send;
      end

      waitResponse :if (reception_SD== 1'b1) begin
        next_state=poppush;
      end
      else  begin
      next_state=waitResponse;
      end

      readSD : if (reception_SD== 1'b1) begin
        next_state=serialParalelo;
      end
      else  begin
      next_state=readSD;
      end

      serialParalelo : begin
        next_state=poppush;
      end
      poppush : begin
        next_state=IDLE;
      end

      send : if (transmision_SD== 1'b1) begin
        next_state=waitResponse;
        end
        else  begin
        next_state=send;
        end
      
      default : begin
        next_state=IDLE;
      end
    endcase


  end
endmodule
