`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCC
// Engineer: Rowan Doherty
// 
// Create Date: 01/19/2026 02:16:30 PM
// Design Name: 
// Module Name: Defines
// Project Name: TDC
// Target Devices: Kintex 7 FPGA
// Tool Versions: 
// Description: Defines file for TDC Project
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Defines.v
// This file sets the scale of your TDC ruler.

`ifndef DEFINES_V
`define DEFINES_V

// NUM_STAGES: Total number of delay taps. 
// 300 taps is usually enough to cover one full clock cycle at 200MHz.
`define NUM_STAGES 360

// NUM_BITS: How many binary bits we need to represent the number 300.
// 2^9 = 512, so 9 bits is perfect.
`define NUM_BITS 9

// COARSE_BITS: The size of the "Big Hand" clock counter.
`define COARSE_BITS 14

// TOTAL OUTPUT: Coarse(14) + Start(9) + Stop(9) = 32 bits.
`define NUM_OUTPUT_BITS 32

`endif
