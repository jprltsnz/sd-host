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
// SRAM.v
//
// 16-bit by 128,  Static Random Access Memory
//
// $Id: SRAM.v,v 1.0 9/10/2010 02:15:36 astill Exp $
// Written: Aaron Stillmaker
//
// This is a simple memory module created for use with the FIFO.
// This was used instead of a standard cell for simplicity of changing
// the size and simplicity of opperation.
//

// Define FIFO Address width minus 1 and Data word width minus 1

`define ADDR_WIDTH_M1 6
`define DATA_WIDTH_M1 15

`timescale 10ps/1ps
`celldefine
module SRAM (
             wr_en,     // write enable
             clk_wr,    // clock coming from write side of FIFO -- write signals
             wr_ptr,    // write pointer
             data_in,   // data to be written into the SRAM
             rd_en,     // read enable
             clk_rd,    // clock coming from read side of FIFO  -- read signals
             rd_ptr,    // read pointer
             data_out   // data to be read from the SRAM
            );


   // I/O %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   input  [`DATA_WIDTH_M1:0] data_in;

   input                     clk_wr,
                             clk_rd,
                             wr_en,
                             rd_en;

   input [`ADDR_WIDTH_M1:0]  wr_ptr,
                             rd_ptr;

   output [`DATA_WIDTH_M1:0] data_out;


   // Internal Registers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   reg [`DATA_WIDTH_M1:0]    mem_array [0:128]; // Internal Memory

   reg [`DATA_WIDTH_M1:0]    data_out;          // data output

   wire [`DATA_WIDTH_M1:0]   data_in;           // data in



   // Main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   always @(posedge clk_wr) begin

      if (wr_en) mem_array[wr_ptr]   <= #1 data_in;

   end

   always @(posedge clk_rd) begin

      if (rd_en)	data_out	<=	#1 mem_array[rd_ptr];

   end

endmodule
`endcelldefine
