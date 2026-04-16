//////////////////////////////////////////////////////////////////////////////////
// File:        TDC_CORE.v
// Author:      Rowan Doherty
// Date:        April 2026
//
// Description: Top-level TDC measurement engine. Instantiates the fine delay
//              line, three phase-offset coarse counters, the start/stop
//              decoders, and the FSM that sequences a single measurement.
//
//              Measurement flow:
//                
//                1. On a rising edge, the fine delay line snapshot is stored
//                   in the start register and the coarse counters latch
//                   start timestamps.
//                2. On the falling edge, the same happens for the stop path.
//                3. Narrow pulses (both edges within one clock cycle) are
//                   detected inside FINETDC and handled as a single-shot
//                   capture with coarse = 0.
//                4. Fine popcounts and coarse delta are combined and output
//                   as a concatenated measurement word, with oDONE asserted
//                   for one cycle to indicate a valid result.
//
//              Three coarse counters run on clocks at 0, 120, and 240 degree
//              offsets. A threshold-based correction selects between the
//              0-degree and 120-degree counts depending on where the hit
//              fell in the clock period, mitigating metastability at clock
//              boundaries.
//
//              Target: Xilinx Kintex-7 (KC705 evaluation board) @ 300 MHz
//////////////////////////////////////////////////////////////////////////////////

`include "Defines.v"

module TDC_CORE (
    input  wire iCLK,       // Primary 300 MHz system clock (0 degrees)
    input  wire iCLK1,      // 300 MHz at 120 degree phase offset
    input  wire iCLK2,      // 300 MHz at 240 degree phase offset
    input  wire iCLK_ref,   // 200 MHz reference for IDELAYCTRL
    input  wire iRST,
    input  wire iHIT_P,     // Differential input (positive)
    input  wire iHIT_N,     // Differential input (negative)

    input  wire fifo_wr_ack,
    input  wire fifo_full,
    input  wire FSM_READY,

    output reg                                  oDONE,
    output reg [`COARSE_BITS+2*`NUM_BITS-1:0]   oTDCVALUE
);

    wire hit_ibuf;
    wire hit_delayed;
    wire idelay_rdy;
    wire wStoreStart;
    wire wStoreStop;

    // -------------------------------------------------------------------------
    // INPUT BUFFER + IDELAY
    // Differential to single-ended conversion, followed by a fixed IDELAY
    // to allow fine-grained alignment of the hit edge with the sampling clock.
    // -------------------------------------------------------------------------
    IBUFDS #(
        .DIFF_TERM("TRUE"),
        .IBUF_LOW_PWR("FALSE")
    ) u_hit_ibufds (
        .I (iHIT_P),
        .IB(iHIT_N),
        .O (hit_ibuf)
    );

    (* IODELAY_GROUP = "tdc_delay_grp" *)
    IDELAYCTRL u_idelayctrl (
        .RDY   (idelay_rdy),
        .REFCLK(iCLK_ref),
        .RST   (iRST)
    );

    (* IODELAY_GROUP = "tdc_delay_grp" *)
    IDELAYE2 #(
        .IDELAY_TYPE         ("FIXED"),
        .IDELAY_VALUE        (0),
        .DELAY_SRC           ("IDATAIN"),
        .SIGNAL_PATTERN      ("DATA"),
        .HIGH_PERFORMANCE_MODE("TRUE"),
        .REFCLK_FREQUENCY    (200.0)
    ) u_idelay_hit (
        .IDATAIN   (hit_ibuf),
        .DATAOUT   (hit_delayed),
        .CINVCTRL  (1'b0),
        .DATAIN    (1'b0),
        .C         (iCLK),
        .CE        (1'b0),
        .INC       (1'b0),
        .LD        (1'b0),
        .LDPIPEEN  (1'b0),
        .CNTVALUEIN(5'b00000),
        .CNTVALUEOUT(),
        .REGRST    (1'b0)
    );

    // -------------------------------------------------------------------------
    // FSM STATES
    //   IDLE  - waiting for FIFO space before accepting a new measurement
    //   READY - armed, waiting for the first (start) edge
    //   BUSY  - start captured, waiting for the stop edge and coarse result
    //   DONE  - result assembled, waiting for FIFO acknowledge
    // -------------------------------------------------------------------------
    localparam S_IDLE  = 2'd0;
    localparam S_READY = 2'd1;
    localparam S_BUSY  = 2'd2;
    localparam S_DONE  = 2'd3;

    reg [1:0] state, next_state;

    // -------------------------------------------------------------------------
    // FINE TDC INSTANCE
    // -------------------------------------------------------------------------
    wire [`NUM_STAGES-1:0] wThermStart;
    wire [`NUM_STAGES-1:0] wThermStop;
    wire oTAP0;
    wire oTAP20;
    wire narrow_pulse;

    FINETDC fine_inst (
        .iCLK                  (iCLK),
        .iRST                  (iRST),
        .iHIT                  (hit_delayed),
        .iSTORESTART           (wStoreStart),
        .iSTORESTOP            (wStoreStop),
        .oTHERMOMETERSTARTVALUE(wThermStart),
        .oTHERMOMETERSTOPVALUE (wThermStop),
        .oTAP0                 (oTAP0),
        .oTAP20                (oTAP20),
        .oNARROW_PULSE         (narrow_pulse)
    );

    // -------------------------------------------------------------------------
    // FINE TDC EDGE DETECTOR + NARROW PULSE CAPTURE
    // Monitors registered tap signals (oTAP0 && oTAP20) from FINETDC to detect
    // rising / falling edges and generate the start / stop store pulses.
    // If the narrow pulse detector fires, its flag is given priority over the
    // normal edge detector, allowing a single-cycle capture of both edges.
    // -------------------------------------------------------------------------
    reg       armed;
    reg [1:0] rEdgeDet;
    reg       narrow_pulse_d1;
    reg       narrow_captured;

    wire wStoreStart_int = (rEdgeDet == 2'b01) ||
                           (narrow_pulse_d1 && state == S_READY);

    wire wStoreStop_int  = (rEdgeDet == 2'b10) ||
                           (narrow_pulse_d1 && state == S_READY);

    // Route the store pulses through dedicated BUFGs so they reach all 360
    // store flip-flops with minimal skew.
    BUFG bufg_start_inst (.I(wStoreStart_int), .O(wStoreStart));
    BUFG bufg_stop_inst  (.I(wStoreStop_int),  .O(wStoreStop));

    always @(posedge iCLK) begin
        if (iRST) begin
            armed           <= 1'b0;
            rEdgeDet        <= 2'b00;
            narrow_pulse_d1 <= 1'b0;
            narrow_captured <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    armed           <= 1'b0;
                    rEdgeDet        <= 2'b00;
                    narrow_pulse_d1 <= 1'b0;
                    narrow_captured <= 1'b0;
                end

                S_READY: begin
                    if (!armed) begin
                        rEdgeDet        <= 2'b00;
                        narrow_pulse_d1 <= 1'b0;
                        if ((oTAP0 && oTAP20) == 1'b0)
                            armed <= 1'b1;
                    end else begin
                        narrow_pulse_d1 <= narrow_pulse;
                        if (narrow_pulse_d1)
                            narrow_captured <= 1'b1;
                        if (!narrow_pulse && !narrow_pulse_d1) begin
                            rEdgeDet <= {rEdgeDet[0], (oTAP0 && oTAP20)};
                        end
                    end
                end

                S_BUSY: begin
                    armed           <= 1'b0;
                    narrow_pulse_d1 <= 1'b0;
                    if (!narrow_captured) begin
                        rEdgeDet <= {rEdgeDet[0], (oTAP0 && oTAP20)};
                    end
                end

                S_DONE: begin
                    armed           <= 1'b0;
                    rEdgeDet        <= 2'b00;
                    narrow_pulse_d1 <= 1'b0;
                end

                default: begin
                    armed           <= 1'b0;
                    rEdgeDet        <= 2'b00;
                    narrow_pulse_d1 <= 1'b0;
                    narrow_captured <= 1'b0;
                end
            endcase
        end
    end

    // -------------------------------------------------------------------------
    // COARSE COUNTER EDGE DETECTORS
    // Three independent edge detectors, one per clock phase. Each samples the
    // delayed hit line directly and generates start / stop store pulses for
    // its respective coarse counter.
    // -------------------------------------------------------------------------

    // CLK0 (primary, 0 degrees)
    reg [1:0] rCoarseEdgeDet;
    always @(posedge iCLK) begin
        if (iRST) rCoarseEdgeDet <= 2'b00;
        else      rCoarseEdgeDet <= {rCoarseEdgeDet[0], hit_delayed};
    end
    wire wCoarseStoreStart = (rCoarseEdgeDet == 2'b01);
    wire wCoarseStoreStop  = (rCoarseEdgeDet == 2'b10);

    // CLK1 (120 degrees)
    reg [1:0] rArb1EdgeDet;
    always @(posedge iCLK1) begin
        if (iRST) rArb1EdgeDet <= 2'b00;
        else      rArb1EdgeDet <= {rArb1EdgeDet[0], hit_delayed};
    end
    wire wArb1StoreStart = (rArb1EdgeDet == 2'b01);
    wire wArb1StoreStop  = (rArb1EdgeDet == 2'b10);

    // CLK2 (240 degrees)
    reg [1:0] rArb2EdgeDet;
    always @(posedge iCLK2) begin
        if (iRST) rArb2EdgeDet <= 2'b00;
        else      rArb2EdgeDet <= {rArb2EdgeDet[0], hit_delayed};
    end
    wire wArb2StoreStart = (rArb2EdgeDet == 2'b01);
    wire wArb2StoreStop  = (rArb2EdgeDet == 2'b10);

    // -------------------------------------------------------------------------
    // COARSE COUNTERS (one per clock phase)
    // -------------------------------------------------------------------------
    wire [`COARSE_BITS-1:0] wCoarseDT;
    wire [`COARSE_BITS-1:0] wCoarseDT_arb1;
    wire [`COARSE_BITS-1:0] wCoarseDT_arb2;

    COARSECOUNTER coarse_inst (
        .iCLK       (iCLK),
        .iRST       (iRST),
        .iSTORESTART(wCoarseStoreStart),
        .iSTORESTOP (wCoarseStoreStop),
        .oCOARSE_DT (wCoarseDT)
    );

    COARSECOUNTER coarse_arb1_inst (
        .iCLK       (iCLK1),
        .iRST       (iRST),
        .iSTORESTART(wArb1StoreStart),
        .iSTORESTOP (wArb1StoreStop),
        .oCOARSE_DT (wCoarseDT_arb1)
    );

    COARSECOUNTER coarse_arb2_inst (
        .iCLK       (iCLK2),
        .iRST       (iRST),
        .iSTORESTART(wArb2StoreStart),
        .iSTORESTOP (wArb2StoreStop),
        .oCOARSE_DT (wCoarseDT_arb2)
    );

    // -------------------------------------------------------------------------
    // ARBITER CLOCK DOMAIN CROSSING
    // Two flip-flop pipeline synchronises the arb1/arb2 counter outputs into
    // the CLK0 domain and aligns them with the main coarse value pipeline.
    // -------------------------------------------------------------------------
    reg [`COARSE_BITS-1:0] wCoarseDT_arb1_d1, wCoarseDT_arb1_d2;
    reg [`COARSE_BITS-1:0] wCoarseDT_arb2_d1, wCoarseDT_arb2_d2;

    always @(posedge iCLK) begin
        if (iRST) begin
            wCoarseDT_arb1_d1 <= 0;
            wCoarseDT_arb1_d2 <= 0;
            wCoarseDT_arb2_d1 <= 0;
            wCoarseDT_arb2_d2 <= 0;
        end else begin
            wCoarseDT_arb1_d1 <= wCoarseDT_arb1;
            wCoarseDT_arb1_d2 <= wCoarseDT_arb1_d1;
            wCoarseDT_arb2_d1 <= wCoarseDT_arb2;
            wCoarseDT_arb2_d2 <= wCoarseDT_arb2_d1;
        end
    end

    // -------------------------------------------------------------------------
    // DECODERS
    // The stored thermometer codes are registered once before entering the
    // pipelined popcount decoders to break the combinational path from the
    // store flip-flops into the decoder adder tree.
    // -------------------------------------------------------------------------
    wire [`NUM_BITS-1:0] wFineStart;
    wire [`NUM_BITS-1:0] wFineStop;

    reg [`NUM_STAGES-1:0] wThermStart_d1;
    reg [`NUM_STAGES-1:0] wThermStop_d1;

    always @(posedge iCLK) begin
        wThermStart_d1 <= wThermStart;
        wThermStop_d1  <= wThermStop;
    end

    DECODESTART dec_start_inst (
        .iCLK             (iCLK),
        .iRST             (iRST),
        .iTHERMOMETERSTART(wThermStart_d1),
        .oBINSTART        (wFineStart)
    );

    DECODESTOP dec_stop_inst (
        .iCLK            (iCLK),
        .iRST            (iRST),
        .iTHERMOMETERSTOP(wThermStop_d1),
        .oBINSTOP        (wFineStop)
    );

    // -------------------------------------------------------------------------
    // COARSE VALUE READY PULSE
    // Indicates that the coarse delta is valid and aligned with the decoded
    // fine values. Two pipeline stages after the stop store pulse.
    // -------------------------------------------------------------------------
    reg stop_d1, stop_d2;
    always @(posedge iCLK) begin
        if (iRST) begin
            stop_d1 <= 1'b0;
            stop_d2 <= 1'b0;
        end else begin
            stop_d1 <= wStoreStop;
            stop_d2 <= stop_d1;
        end
    end
    wire coarse_value_ready = stop_d2;

    // -------------------------------------------------------------------------
    // PIPELINE ALIGNMENT
    // Delay the main coarse value and ready pulse by two cycles to align with
    // the fine popcount output from the pipelined decoders.
    // -------------------------------------------------------------------------
    reg [`COARSE_BITS-1:0] wCoarseDT_d1, wCoarseDT_d2;
    reg                    coarse_ready_d1, coarse_ready_d2;

    always @(posedge iCLK) begin
        if (iRST) begin
            wCoarseDT_d1    <= 0;
            wCoarseDT_d2    <= 0;
            coarse_ready_d1 <= 0;
            coarse_ready_d2 <= 0;
        end else begin
            wCoarseDT_d1    <= wCoarseDT;
            wCoarseDT_d2    <= wCoarseDT_d1;
            coarse_ready_d1 <= coarse_value_ready;
            coarse_ready_d2 <= coarse_ready_d1;
        end
    end

    // -------------------------------------------------------------------------
    // FSM NEXT STATE LOGIC
    // -------------------------------------------------------------------------
    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE:  if (!fifo_full)      next_state = S_READY;
            S_READY: if (wStoreStart)     next_state = S_BUSY;
            S_BUSY:  if (coarse_ready_d2) next_state = S_DONE;
            S_DONE:  if (fifo_wr_ack)     next_state = S_IDLE;
            default:                      next_state = S_IDLE;
        endcase
    end

    always @(posedge iCLK) begin
        if (iRST) state <= S_IDLE;
        else      state <= next_state;
    end

    // -------------------------------------------------------------------------
    // COARSE COUNT CORRECTION
    // The primary (CLK0) coarse count is unreliable when the input hit edge
    // falls close to a CLK0 sampling edge. Two regions are identified here:
    //
    //   1. A narrow "bad-bin" window on each side of the clock period where
    //      the CLK1 (120 degree) counter is substituted instead. CLK1's
    //      sampling edge is well away from the event in these regions.
    //   2. A broader threshold region where a deterministic +/-1 correction
    //      is applied to the CLK0 count itself.
    //
    // If the narrow pulse detector fired, the coarse delta is forced to zero
    // since both edges fell within a single clock cycle.
    //
    // Thresholds are in fine-tap units; see thesis Section 5.6 for derivation.
    // -------------------------------------------------------------------------
    wire clk0_start_ambig = (wFineStart > 300);
    wire clk0_stop_ambig  = (wFineStop  < 42);

    wire use_clk1_start = (wFineStart >= 296) && (wFineStart <= 302);
    wire use_clk1_stop  = (wFineStop  >= 41)  && (wFineStop  <= 46);

    wire [`COARSE_BITS-1:0] wCoarseDT_corrected;

    assign wCoarseDT_corrected =
        (narrow_captured)                     ? {`COARSE_BITS{1'b0}}      :
        (use_clk1_start && use_clk1_stop)     ? wCoarseDT_arb1_d2         :
        (use_clk1_start)                      ? (wCoarseDT_arb1_d2 - 1'b1):
        (use_clk1_stop)                       ? (wCoarseDT_arb1_d2 + 1'b1):
        (clk0_start_ambig && clk0_stop_ambig) ? wCoarseDT_d2              :
        (clk0_start_ambig)                    ? (wCoarseDT_d2 - 1'b1)     :
        (clk0_stop_ambig)                     ? (wCoarseDT_d2 + 1'b1)     :
                                                wCoarseDT_d2;

    // -------------------------------------------------------------------------
    // OUTPUT CONTROL
    // Assert oDONE for one cycle on entry into S_DONE, and latch the final
    // measurement word. For narrow pulses the coarse field is zero; for all
    // other measurements it carries the corrected coarse delta.
    // -------------------------------------------------------------------------
    always @(posedge iCLK) begin
        if (iRST) begin
            oDONE     <= 1'b0;
            oTDCVALUE <= 0;
        end else begin
            if (state != S_DONE && next_state == S_DONE)
                oDONE <= 1'b1;
            else
                oDONE <= 1'b0;

            if (coarse_ready_d2) begin
                if (narrow_captured)
                    oTDCVALUE <= {{`COARSE_BITS{1'b0}}, wFineStart, wFineStop};
                else
                    oTDCVALUE <= {wCoarseDT_corrected, wFineStart, wFineStop};
            end
        end
    end

endmodule
