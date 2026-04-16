//////////////////////////////////////////////////////////////////////////////////
// File:        FINETDC.v
// Author:      Rowan Doherty
// Date:        April 2026
//
// Description: Fine TDC core. Implements a 360-tap CARRY4-based tapped delay
//              line with SCSC tap interleaving (alternating sum and carry
//              outputs) and a three-stage flip-flop sampling pipeline.
//
//              Pipeline stages:
//                1. Raw sample of delay chain taps
//                2. Polarity correction for SCSC sum taps
//                3. Register filtered thermometer code for downstream logic
//
//              A three-bit majority vote bubble filter sits between stages 2
//              and 3 to remove isolated single-bit metastability errors. A
//              narrow pulse detector on stage 1 flags sub-clock-period inputs.
//              Store registers latch the clean thermometer code on start and
//              stop events.
//
//              Target: Xilinx Kintex-7 (KC705 evaluation board) @ 300 MHz
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`include "Defines.v"

(* keep_hierarchy = "TRUE" *) module FINETDC(
    input  iCLK,
    input  iRST,
    input  iHIT,
    input  iSTORESTART,
    input  iSTORESTOP,
    output [`NUM_STAGES-1:0] oTHERMOMETERSTARTVALUE,
    output [`NUM_STAGES-1:0] oTHERMOMETERSTOPVALUE,
    output oTAP0,
    output oTAP20,
    output oNARROW_PULSE
);

    wire [`NUM_STAGES-1:0] wFINEVALUE;
    wire [`NUM_STAGES-1:0] wFINEVALUE_C;    // Raw carry outputs from CARRY4 cells
    wire [`NUM_STAGES-1:0] wFINEVALUE_S;    // Raw sum outputs from CARRY4 cells
    wire [`NUM_STAGES-1:0] wTDCVALUE;       // Stage 1 - raw sampled taps
    wire [`NUM_STAGES-1:0] wTDCVALUE_D1;    // Stage 2 - polarity-corrected taps
    wire [`NUM_STAGES-1:0] wTDCVALUE_FILT;  // Bubble-filtered thermometer code
    wire [`NUM_STAGES-1:0] wTDCVALUE_D2;    // Stage 3 - filtered and registered
    wire [`NUM_STAGES-1:0] wTHERMOMETERSTARTVALUE;
    wire [`NUM_STAGES-1:0] wTHERMOMETERSTOPVALUE;

    // -------------------------------------------------------------------------
    // DELAY CHAIN - 90 CARRY4 cells chained in series (360 taps total).
    //
    // Each cell has S = 4'b1111 and DI = 4'b0000 so the carry input
    // propagates freely through all four multiplexer stages, making the
    // carry chain act as a pure delay line.
    //
    // SCSC tap interleaving uses one tap per bit position per cell:
    //   position 4k+0 = S[0]  (sum - inverted later in stage 2)
    //   position 4k+1 = C[1]  (carry)
    //   position 4k+2 = S[2]  (sum - inverted later in stage 2)
    //   position 4k+3 = C[3]  (carry)
    // Delay increases monotonically since each bit position is one mux stage
    // further along the internal chain. Sum outputs are inverted after
    // sampling rather than in the delay path to preserve timing.
    // -------------------------------------------------------------------------
    genvar i;
    generate
        for (i = 0; i <= `NUM_STAGES/4-1; i = i+1)
        begin : generate_block
            if (i == 0)
            begin
                (* dont_touch = "TRUE" *) CARRY4 carry4_1 (
                    .CO    (wFINEVALUE_C[3:0]),
                    .O     (wFINEVALUE_S[3:0]),
                    .CI    (1'b0),
                    .CYINIT(iHIT),
                    .DI    (4'b0000),
                    .S     (4'b1111)
                );
            end
            else
            begin
                (* dont_touch = "TRUE" *) CARRY4 carry4_1 (
                    .CO    (wFINEVALUE_C[4*(i+1)-1 : 4*i]),
                    .O     (wFINEVALUE_S[4*(i+1)-1 : 4*i]),
                    .CI    (wFINEVALUE_C[4*i-1]),
                    .CYINIT(1'b0),
                    .DI    (4'b0000),
                    .S     (4'b1111)
                );
            end
        end
    endgenerate

    // SCSC tap assignment
    genvar k;
    generate
        for (k = 0; k <= `NUM_STAGES/4-1; k = k+1)
        begin : scsc_tap
            assign wFINEVALUE[4*k+0] = wFINEVALUE_S[4*k+0];
            assign wFINEVALUE[4*k+1] = wFINEVALUE_C[4*k+1];
            assign wFINEVALUE[4*k+2] = wFINEVALUE_S[4*k+2];
            assign wFINEVALUE[4*k+3] = wFINEVALUE_C[4*k+3];
        end
    endgenerate

    // -------------------------------------------------------------------------
    // STAGE 1 FLIP-FLOPS - sample the raw delay chain state every clock
    // cycle. Forms the first half of a two-stage synchroniser for the
    // asynchronous HIT input. S taps are sampled raw here; polarity
    // correction is deferred to stage 2 to keep the sampling path fast.
    // -------------------------------------------------------------------------
    genvar j;
    generate
        for (j = 0; j <= `NUM_STAGES-1; j = j+1)
        begin : stage1
            (* dont_touch = "TRUE" *) FDCE #(.INIT(1'b0)) rTDCVALUE (
                .Q(wTDCVALUE[j]),
                .C(iCLK),
                .CE(1'b1),
                .CLR(1'b0),
                .D(wFINEVALUE[j])
            );
        end
    endgenerate

    // -------------------------------------------------------------------------
    // STAGE 2 FLIP-FLOPS - apply SCSC polarity correction.
    // Even positions (S taps) are inverted; odd positions (C taps) pass
    // through unchanged. After this stage all 360 bits share the same
    // thermometer polarity: 0 = wavefront not reached, 1 = wavefront passed.
    // Vivado absorbs the inversion into the FF INIT polarity, so no extra
    // combinational delay is introduced.
    // -------------------------------------------------------------------------
    genvar m;
    generate
        for (m = 0; m <= `NUM_STAGES-1; m = m+1)
        begin : stage2
            if (m % 2 == 0)
                (* dont_touch = "TRUE" *) FDCE #(.INIT(1'b0)) rTDCVALUE_D1 (
                    .Q(wTDCVALUE_D1[m]),
                    .C(iCLK),
                    .CE(1'b1),
                    .CLR(1'b0),
                    .D(~wTDCVALUE[m])
                );
            else
                (* dont_touch = "TRUE" *) FDCE #(.INIT(1'b0)) rTDCVALUE_D1 (
                    .Q(wTDCVALUE_D1[m]),
                    .C(iCLK),
                    .CE(1'b1),
                    .CLR(1'b0),
                    .D(wTDCVALUE[m])
                );
        end
    endgenerate

    // -------------------------------------------------------------------------
    // BUBBLE FILTER - three-bit majority vote on each tap position.
    // Removes isolated single-bit bubble errors caused by residual
    // metastability in the stage 1 flip-flops. Boundary bits use only the
    // single available neighbour.
    //
    //   filt[i] = (D1[i] & D1[i-1]) | (D1[i] & D1[i+1]) | (D1[i-1] & D1[i+1])
    // -------------------------------------------------------------------------
    assign wTDCVALUE_FILT[0] = wTDCVALUE_D1[0] & wTDCVALUE_D1[1];
    assign wTDCVALUE_FILT[`NUM_STAGES-1] = wTDCVALUE_D1[`NUM_STAGES-1] &
                                           wTDCVALUE_D1[`NUM_STAGES-2];

    genvar f;
    generate
        for (f = 1; f <= `NUM_STAGES-2; f = f+1)
        begin : filter_block
            assign wTDCVALUE_FILT[f] = (wTDCVALUE_D1[f]   & wTDCVALUE_D1[f-1]) |
                                       (wTDCVALUE_D1[f]   & wTDCVALUE_D1[f+1]) |
                                       (wTDCVALUE_D1[f-1] & wTDCVALUE_D1[f+1]);
        end
    endgenerate

    // -------------------------------------------------------------------------
    // STAGE 3 FLIP-FLOPS - register the filtered thermometer code.
    // This is the clean output consumed by the store registers and decoder.
    // -------------------------------------------------------------------------
    genvar t;
    generate
        for (t = 0; t <= `NUM_STAGES-1; t = t+1)
        begin : stage3
            (* dont_touch = "TRUE" *) FDCE #(.INIT(1'b0)) rTDCVALUE_D2 (
                .Q(wTDCVALUE_D2[t]),
                .C(iCLK),
                .CE(1'b1),
                .CLR(1'b0),
                .D(wTDCVALUE_FILT[t])
            );
        end
    endgenerate

    // -------------------------------------------------------------------------
    // NARROW PULSE DETECTOR - identifies sub-clock-period pulses by checking
    // for a bounded region of asserted taps in the middle of the chain with
    // zeros at both ends. Operates on stage 1 so the flag is available one
    // cycle before the edge detector can act, enabling the store logic to
    // override the normal rising/falling edge sequence. Uses C taps (odd
    // positions) which have correct polarity before stage 2 inversion.
    // -------------------------------------------------------------------------
    assign oNARROW_PULSE = !wTDCVALUE[1]              &&
                           !wTDCVALUE[`NUM_STAGES-1]  &&
                           (wTDCVALUE[51]  | wTDCVALUE[101] |
                            wTDCVALUE[151] | wTDCVALUE[201] |
                            wTDCVALUE[251] | wTDCVALUE[301] |
                            wTDCVALUE[351]);

    // -------------------------------------------------------------------------
    // STORE REGISTERS - latch the clean thermometer code on each event.
    // Separate banks for start and stop events, each gated by its own CE
    // pulse from the parent module's edge detector.
    // -------------------------------------------------------------------------
    genvar s;
    generate
        for (s = 0; s <= `NUM_STAGES-1; s = s+1)
        begin : store_start
            (* dont_touch = "TRUE" *) FDCE #(.INIT(1'b0)) rTHERMOMETERSTARTVALUE (
                .Q(wTHERMOMETERSTARTVALUE[s]),
                .C(iCLK),
                .CE(iSTORESTART),
                .CLR(iRST),
                .D(wTDCVALUE_D2[s])
            );
        end
    endgenerate

    genvar l;
    generate
        for (l = 0; l <= `NUM_STAGES-1; l = l+1)
        begin : store_stop
            (* dont_touch = "TRUE" *) FDCE #(.INIT(1'b0)) rTHERMOMETERSTOPVALUE (
                .Q(wTHERMOMETERSTOPVALUE[l]),
                .C(iCLK),
                .CE(iSTORESTOP),
                .CLR(iRST),
                .D(wTDCVALUE_D2[l])
            );
        end
    endgenerate

    assign oTHERMOMETERSTARTVALUE = wTHERMOMETERSTARTVALUE;
    assign oTHERMOMETERSTOPVALUE  = wTHERMOMETERSTOPVALUE;
    assign oTAP0                  = wTDCVALUE_D1[1];   // C tap - correct polarity
    assign oTAP20                 = wTDCVALUE_D1[21];  // C tap - correct polarity

endmodule
