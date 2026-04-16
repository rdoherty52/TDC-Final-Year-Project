//////////////////////////////////////////////////////////////////////////////////
// File:        TDC_SYSTEM_TOP.v
// Author:      Rowan Doherty
// Date:        April 2026
//
// Description: Board-level top for the Kintex-7 KC705 platform. Wires up the
//              clocking wizard, the TDC measurement core, the output FIFO,
//              and the UART packetiser that streams measurements to a host PC.
//
//              Clock tree:
//                - Differential 200 MHz board clock drives the Clocking Wizard
//                - clk_sys  = 300 MHz (primary system clock)
//                - clk_ref  = 200 MHz (IDELAYCTRL reference)
//                - clk120   = 300 MHz at 120 degree phase offset
//                - clk240   = 300 MHz at 240 degree phase offset
//
//              Data flow:
//                TDC_CORE -> FIFO -> UART packetiser -> uart_tx -> host PC
//
//              Each TDC measurement is 32 bits: {coarse[13:0], fine_start[8:0],
//              fine_stop[8:0]}. The packetiser frames each measurement as:
//                0x55 | B3 | B2 | B1 | B0 | checksum | 0x0A | 0x0D
//              at 115200 baud.
//////////////////////////////////////////////////////////////////////////////////

`include "Defines.v"

module TDC_SYSTEM_TOP (
    // Physical pins for KC705
    input  wire iCLK_p,      // System clock (differential P)
    input  wire iCLK_n,      // System clock (differential N)
    input  wire iRST,        // CPU_RESET pushbutton
    input  wire iHIT_P,      // Hit input from signal generator (P)
    input  wire iHIT_N,      // Hit input from signal generator (N)
    output wire oUART_TXD    // USB-UART bridge TX pin
);

    // -------------------------------------------------------------------------
    // INTERNAL CLOCKS AND RESET
    // -------------------------------------------------------------------------
    wire clk_sys;    // 300 MHz primary system clock
    wire clk_ref;    // 200 MHz IDELAYCTRL reference
    wire clk120;     // 300 MHz, 120 degree phase
    wire clk240;     // 300 MHz, 240 degree phase
    wire pll_locked;

    wire system_reset = iRST | !pll_locked;

    // -------------------------------------------------------------------------
    // TDC INTERFACE SIGNALS
    // -------------------------------------------------------------------------
    wire oDONE;
    wire [`COARSE_BITS + 2*`NUM_BITS - 1:0] tdc_val;
    reg  fsm_ready_pulse;

    // -------------------------------------------------------------------------
    // FIFO SIGNALS
    // -------------------------------------------------------------------------
    wire        fifo_full;
    wire        fifo_empty;
    wire [31:0] fifo_dout;
    wire        fifo_rd_en;
    wire        fifo_wr_ack;
    wire        fifo_valid;

    // -------------------------------------------------------------------------
    // 1. CLOCKING WIZARD
    // -------------------------------------------------------------------------
    clk_wiz_0 u_clock_gen (
        .clk_in1_p(iCLK_p),
        .clk_in1_n(iCLK_n),
        .clk_out1 (clk_sys),
        .clk_out2 (clk_ref),
        .clk_out3 (clk120),
        .clk_out4 (clk240),
        .reset    (iRST),
        .locked   (pll_locked)
    );

    // -------------------------------------------------------------------------
    // 2. TDC MEASUREMENT CORE
    // -------------------------------------------------------------------------
    TDC_CORE u_tdc (
        .iCLK       (clk_sys),
        .iCLK_ref   (clk_ref),
        .iCLK1      (clk120),
        .iCLK2      (clk240),
        .iRST       (system_reset),
        .iHIT_P     (iHIT_P),
        .iHIT_N     (iHIT_N),
        .fifo_wr_ack(fifo_wr_ack),
        .FSM_READY  (fsm_ready_pulse),
        .fifo_full  (fifo_full),
        .oDONE      (oDONE),
        .oTDCVALUE  (tdc_val)
    );

    // -------------------------------------------------------------------------
    // 3. OUTPUT FIFO
    // Decouples the TDC measurement rate from the UART transmission rate.
    // -------------------------------------------------------------------------
    fifo_generator_0 u_fifo (
        .clk   (clk_sys),
        .srst  (system_reset),
        .din   (tdc_val),
        .wr_en (oDONE),
        .rd_en (fifo_rd_en),
        .dout  (fifo_dout),
        .full  (fifo_full),
        .empty (fifo_empty),
        .wr_ack(fifo_wr_ack),
        .valid (fifo_valid)
    );

    // -------------------------------------------------------------------------
    // 4. UART PACKETISER (FIFO -> UART)
    // Frames each 32-bit measurement word as:
    //   0x55 marker | byte[31:24] | byte[23:16] | byte[15:8] | byte[7:0]
    //   | checksum (sum of the 4 data bytes, mod 256) | 0x0A (LF) | 0x0D (CR)
    // A small cooldown (S_WAIT) prevents the FIFO read from overlapping the
    // next packet cycle.
    // -------------------------------------------------------------------------
    reg [3:0]  tx_state;
    reg [31:0] tx_hold_reg;
    reg [7:0]  tx_data_byte;
    reg        tx_start_pulse;
    wire       tx_busy;
    reg        fifo_rd_en_reg;
    reg [15:0] delay_cnt;
    reg [7:0]  checksum;

    assign fifo_rd_en = fifo_rd_en_reg;

    localparam S_IDLE = 4'd0;
    localparam S_MARK = 4'd1;
    localparam S_B3   = 4'd2;
    localparam S_B2   = 4'd3;
    localparam S_B1   = 4'd4;
    localparam S_B0   = 4'd5;
    localparam S_CHK  = 4'd6;
    localparam S_LF   = 4'd7;
    localparam S_CR   = 4'd8;
    localparam S_POP  = 4'd9;
    localparam S_WAIT = 4'd10;

    always @(posedge clk_sys) begin
        if (system_reset) begin
            tx_state       <= S_IDLE;
            tx_start_pulse <= 1'b0;
            fifo_rd_en_reg <= 1'b0;
            delay_cnt      <= 16'd0;
            checksum       <= 8'b0;
        end else begin
            tx_start_pulse <= 1'b0;
            fifo_rd_en_reg <= 1'b0;

            case (tx_state)
                S_IDLE: begin
                    if (!fifo_empty && !tx_busy) begin
                        tx_hold_reg <= fifo_dout;
                        checksum    <= 8'd0;
                        tx_state    <= S_MARK;
                    end
                end

                S_MARK: if (!tx_busy) begin
                    tx_data_byte   <= 8'h55;
                    tx_start_pulse <= 1'b1;
                    tx_state       <= S_B3;
                end

                S_B3: if (!tx_busy && !tx_start_pulse) begin
                    tx_data_byte   <= tx_hold_reg[31:24];
                    checksum       <= checksum + tx_hold_reg[31:24];
                    tx_start_pulse <= 1'b1;
                    tx_state       <= S_B2;
                end

                S_B2: if (!tx_busy && !tx_start_pulse) begin
                    tx_data_byte   <= tx_hold_reg[23:16];
                    checksum       <= checksum + tx_hold_reg[23:16];
                    tx_start_pulse <= 1'b1;
                    tx_state       <= S_B1;
                end

                S_B1: if (!tx_busy && !tx_start_pulse) begin
                    tx_data_byte   <= tx_hold_reg[15:8];
                    checksum       <= checksum + tx_hold_reg[15:8];
                    tx_start_pulse <= 1'b1;
                    tx_state       <= S_B0;
                end

                S_B0: if (!tx_busy && !tx_start_pulse) begin
                    tx_data_byte   <= tx_hold_reg[7:0];
                    checksum       <= checksum + tx_hold_reg[7:0];
                    tx_start_pulse <= 1'b1;
                    tx_state       <= S_CHK;
                end

                S_CHK: if (!tx_busy && !tx_start_pulse) begin
                    tx_data_byte   <= checksum;
                    tx_start_pulse <= 1'b1;
                    tx_state       <= S_LF;
                end

                S_LF: if (!tx_busy && !tx_start_pulse) begin
                    tx_data_byte   <= 8'h0A;      // Line Feed
                    tx_start_pulse <= 1'b1;
                    tx_state       <= S_CR;
                end

                S_CR: if (!tx_busy && !tx_start_pulse) begin
                    tx_data_byte   <= 8'h0D;      // Carriage Return
                    tx_start_pulse <= 1'b1;
                    tx_state       <= S_POP;
                end

                S_POP: if (!tx_busy && !tx_start_pulse) begin
                    fifo_rd_en_reg <= 1'b1;
                    delay_cnt      <= 16'd500;    // cooldown period
                    tx_state       <= S_WAIT;
                end

                S_WAIT: begin
                    if (delay_cnt > 0) delay_cnt <= delay_cnt - 1;
                    else               tx_state  <= S_IDLE;
                end

                default: tx_state <= S_IDLE;
            endcase
        end
    end

    // -------------------------------------------------------------------------
    // 5. UART TRANSMITTER
    // -------------------------------------------------------------------------
    uart_tx #(
        .CLK_FREQ (300_000_000),
        .BAUD_RATE(115200)
    ) u_tx (
        .clk    (clk_sys),
        .rst    (system_reset),
        .tx_byte(tx_data_byte),
        .tx_en  (tx_start_pulse),
        .tx_pin (oUART_TXD),
        .tx_busy(tx_busy)
    );

endmodule
