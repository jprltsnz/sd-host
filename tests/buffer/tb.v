//******************************************************************************
//                                                                             *
// Copyright (C) 2010 Regents of the University of California.                 *
//                                                                             *
// The information contained herein is the exclusive property of the VCL       *
// group but may be used and/or modified for non-comercial purposes if the     *
// author is acknowledged.  For all other uses, permission must be attained    *
// by the VLSI Computation Lab.                                                *
//                                                                             *
// This work has been developed by members of the VLSI Computation Lab         *
// (VCL) in the Department of Electrical and Computer Engineering at           *
// the University of California at Davis.  Contact: bbaas@ece.ucdavis.edu      *
//******************************************************************************
//
// tb.vt
//
// Testbench for FIFO
//
// This module will rigorously test the FIFO module.
//
// Written by Aaron Stillmaker
// 8/13/10

// Define FIFO Address width minus 1 and Data word width minus 1

`define ADDR_WIDTH_M1 6
`define DATA_WIDTH_M1 15

`timescale 10ps/1ps
`define IN_COUNT 200
module tb();

   reg                      clkP,           // write clock
							clkC,           // read clock
                            reset,          // reset
                            wr_valid,
							nap,
                            rd_request,
							last_request,
							request,
							emp,
							last_empty,
							wr_en;

   reg [`DATA_WIDTH_M1:0]   data_in,
                            last_data;

   reg [1:0]                delay_sel;      // delay select
   reg [2:0]                wr_sync_cntrl,  // write sysch control
                            rd_sync_cntrl;  // read sync control
   reg [`ADDR_WIDTH_M1:0]   reserve;        // reserve

   wire                     wr_request,
                            empty;
   wire [`DATA_WIDTH_M1:0]  data_out;


   integer             fh_output,  // output file handle
                       r,          // random seed
                       iterationP, // count of itteration for clock for producer
                       iterationC, // count of itteration for clock for consumer
                       speedP,     // count of speed for clock for producer
                       speedC,     // count of speed for clock for consumer
                       symcount,   // count of how many runs are done
                       iterationRD,
					   rd_interval,
					   iterationWR,
					   wr_interval;




   // Initialization for data capture
   initial begin
      //$recordfile("tb");
      //$recordvars(tb);

      fh_output = $fopen("output.m");

      r = 123;          // initialize random seed
   end

   // Initialize testbench
   initial begin
      clkP=0;
      clkC=0;
      reset = 1;
      rd_request = 0;
      data_in=7'b0000000;
      symcount = 1;
      wr_valid = 0;
	  iterationRD = 0;
      rd_interval = 10;
      iterationWR = 0;
      wr_interval = 10;
	  wr_en = 0;


      // Delay Select, set how much delay you want in the FIFO
      delay_sel = 2'b00;

      // Write and Read number of registers in the asynchronous communication beween the two frequencies
      wr_sync_cntrl = 3'b000;
      rd_sync_cntrl = 3'b000;

      // Reserve space constant
      reserve = 7'b0000000;

      // No Increment Read pointer signal
      nap = 0;

      // Initialize the speed and interation numbers
      speedP = 500;
      speedC = 400;
      iterationP = 0;
      iterationC = 0;


      #50;
      clkP=1;
      clkC=1;

      #50;
      reset = 0;


   end


   // Producer Clock
   always begin

      if (iterationP == speedP/2) begin
         #1
         clkP = ~clkP;                        // alternate the clock
         iterationP = iterationP + 1;
      end
      else if (iterationP == speedP) begin
         #1
         clkP = ~clkP;						// alternate the clock
         iterationP = 0;						// reset the counter
         speedP = 2 * (500 - ($random(r) % 250));	// make a new random number from 500-1500
      end else begin
         #1
         iterationP = iterationP + 1;
      end

   end

   // Consumer Clock
   always begin

      if (iterationC == speedC/2) begin
         #1
         clkC = ~clkC;						// alternate the clock
         iterationC = iterationC + 1;
      end
      else if (iterationC == speedC) begin
         #1
         clkC = ~clkC;						// alternate the clock
         iterationC = 0;						// reset the counter
         speedC = 2 * (500 - ($random(r) % 250));	// make a new random number from 500-1500

         if (speedC == (speedP - iterationP)) begin
            speedC = speedC +4;						//make sure the clock pulses do not line up to stop a verilog error
         end

      end else begin
         #1
         iterationC = iterationC + 1;
      end

   end


   // Create WR and RD enable signals

   always @(posedge clkC) begin

      if (iterationRD == rd_interval) begin
         #1
         rd_request = ~rd_request;						// alternate the rd_request
         iterationRD = 0;						// reset the counter
         rd_interval = (1001 - ($random(r) % 1000));	// make a new random number from 1-2001
      end else begin
         #1
         iterationRD = iterationRD + 1;
      end

   end


   always @(posedge clkP) begin

      if (iterationWR == wr_interval) begin
         #1
         wr_en = ~wr_en;						// alternate the wr_en
         iterationWR = 0;						// reset the counter
         wr_interval = (1001 - ($random(r) % 1000));	// make a new random number from 1-2001
      end else begin
         #1
         iterationWR = iterationWR + 1;
      end

   end


   // Generate Producer Input

   always @(posedge clkP) begin

      if (wr_request == 1 & wr_en == 1) begin

         // Inc when the FIFO is ready for a write and the pos edge of the clock

		wr_valid = 1;
		data_in = data_in + 1;	// The data
		//$fwrite(fh_output,"In = %h;\n", data_in);


         #2
         wr_valid = 0;	// Data is no longer valid

      end


   end


   // Save Output from Consumer

   always @(posedge clkC) begin

      // Save output whenever the FIFO is ready to output and the
	  //positive edge of the clock


      if (last_request == 1 & last_empty != 1) begin

	     last_request = rd_request;
		 last_empty = empty;
	     #1
	     //$fwrite(fh_output, "Out = %h;\n", data_out);
         if (last_data + 1 != data_out) begin
		    $display("ERROR last_data = %h while data_out= %h!!!!!!rd_request = %b, last_request = %b, and request = %b\n", last_data, data_out, rd_request, last_request, request);
		    $fwrite(fh_output, "ERROR last_data = %h while data_out= %h!!!!!!rd_request = %b, last_request = %b, and request = %b\n", last_data, data_out, rd_request, last_request, request);
		end

		last_data = data_out;

      end

      //symcount = symcount + 1;

      if (symcount == 0 ) begin

		 $display("FINISHED!!!!");
         $finish;
         $fclose(fh_output);


      end
   end


// Submodule

FIFO FIFO (
           .reserve           (reserve),
           .wr_sync_cntrl     (wr_sync_cntrl),
           .clk_wr            (clkP),
           .data_in           (data_in),
           .wr_valid          (wr_valid),
           .delay_sel         (delay_sel),
           .wr_request        (wr_request),
		   .async_empty       (async_empty),
           .reset             (reset),
           .clk_rd            (clkC),
           .data_out          (data_out),
           .empty             (empty),
           .rd_request        (rd_request),
		   .async_full        (async_full),
           .rd_sync_cntrl     (rd_sync_cntrl),
           .nap               (nap),
		   .fifo_util         (fifo_util)
            );



endmodule
