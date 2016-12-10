
`include "capa_fisica.v"
`include "control_DAT.v"
`include "deserializer.v"
`include "serializer.v"
// Code your design here
//////////////////////////////////////////////////////////////////////////////////////////////////7
//    Module: DAT
//    Projecto: SD Host
//
// Descripcion:Este modulo integra todos los sub bloques , conecta el  control con la capa fisica . existen salidas que  este nivel estan vacias pero en niveles internos estas estan siendo usadas.
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
module DAT(
  input logic writeRead,// señal writeRead de  registro
  input logic newService, //señal nuevo servicio del DMA
  input logic multiblock, //
  input logic timeoutenable,
  input logic reset,
  input logic[3:0] blockSize,
  input logic fifo_full,
  input logic  [15:0] timeout ,
  input logic SDclock,
  input logic clock,
  input logic [31:0] fromFifo_toPS,// datos desde el fifo hacia el  serializador
  input logic  fromSD_SP, //datos desde la SD hacia el deserializdor 
  output  wire complete, // señal deproceso  terminado hacia el DAT
  output wire toSD_PS, //  salida del serializador hacia  la SD
  output wire  padState,// entrada o salida del pad
  output wire padEnable, //habilita el oad
  output wire timeOutFail, //  si falla el time out se activa esta salida
  output wire [31:0] fromSP_toFifo,
  output wire pop, //  
  output wire push,
  output wire IDLE_out
);

  wire IDLE_fisicaControl;
  wire recibido_fisicaControl;
  wire transferComplete_fisicaControl;
  wire newService_controlFisica;
  wire reset_controlFisica;
  wire writeRead_controlFisica;
  wire [15:0] timeout_controlFisica;
  control_DAT core1 (.writeRead(writeRead),.multiblock(multiblock),.timeoutenable(timeoutenable)
                     ,.timeout(timeout),.newService(newService),.clock(clock),.reset(reset),.blockSize(blockSize),.fifo_full(fifo_full)
                     ,.IDLE_in(IDLE_fisicaControl),.recibido(recibido_fisicaControl),.transferComplete(transferComplete_fisicaControl),.newService_fisica(newService_controlFisica)
                     ,.reset_fisica(reset_controlFisica),.complete(complete),.IDLE_out(IDLE_out),.timeout_fisica(timeout_controlFisica),.writeRead_fisica(writeRead_controlFisica));

  capa_fisica  core2(.writeRead_control(writeRead_controlFisica),.timeoutenable(timeoutenable),.timeout(timeout_controlFisica),.newService_control(newService_controlFisica)
                     ,.SDclock(SDclock),.reset(reset_controlFisica),.transmision_SD(),.reception_SD(),.fromFifo_toPS(fromFifo_toPS),.fromSD_SP(fromSD_SP)
                     ,.recibido(recibido_fisicaControl),.transferComplete(transferComplete_fisicaControl),.pop(pop),.push(push),.IDLE_out_control(IDLE_fisicaControl)
                     ,.timeOutFail(timeOutFail),.loadsend(),.enable_PS(),.enable_SP(),.padState(padState),.padEnable(padEnable),.fromSP_toFifo(fromSP_toFifo),.toPS_fromFifo(),.toSD_PS(toSD_PS));

endmodule
