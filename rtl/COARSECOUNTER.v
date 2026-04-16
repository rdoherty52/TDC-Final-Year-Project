//////////////////////////////////////////////////////////////////////////////////
// File:        COARSECOUNTER.v
// Author:      Rowan Doherty
// Date:        April 2026
//
// Description: Free-running coarse counter for the Nutt-method TDC. Counts
//              clock cycles continuously and latches a timestamp on each
//              start event. On a stop event the output is updated with the
//              elapsed coarse delta (stop - start).
//
//              Two's complement subtraction makes the delta wrap-safe: if
//              the counter rolls over between start and stop, the result is
//              still correct provided the interval is shorter than the full
//              counter range.
//
//              Width is set by the COARSE_BITS macro in Defines.v. At
//              300 MHz with 14 bits this gives a measurement range of
//              approximately 54.6 us before overflow.
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`include "Defines.v"

module COARSECOUNTER (
    input  wire                    iCLK,
    input  wire                    iRST,
    input  wire                    iSTORESTART,   // 1-cycle pulse, start event
    input  wire                    iSTORESTOP,    // 1-cycle pulse, stop event
    output reg  [`COARSE_BITS-1:0] oCOARSE_DT     // coarse delta (stop - start)
);

    reg [`COARSE_BITS-1:0] ctr;           // Free-running cycle counter
    reg [`COARSE_BITS-1:0] coarse_start;  // Latched timestamp at start event

    always @(posedge iCLK) begin
        if (iRST) begin
            ctr          <= 0;
            coarse_start <= 0;
            oCOARSE_DT   <= 0;
        end else begin
            ctr <= ctr + 1'b1;

            if (iSTORESTART)
                coarse_start <= ctr;

            if (iSTORESTOP)
                oCOARSE_DT <= ctr - coarse_start;  // wrap-safe
        end
    end

endmodule
