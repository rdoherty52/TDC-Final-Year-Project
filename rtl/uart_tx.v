//////////////////////////////////////////////////////////////////////////////////
// File:        uart_tx.v
// Author:      Rowan Doherty
// Date:        April 2026
//
// Description: Simple UART transmitter (8-N-1 framing).
//              Sends one byte per tx_en pulse at the configured baud rate.
//
//              Frame format: start bit (0) | data[0..7] LSB first | stop bit (1)
//              Total 10 bit periods per byte.
//
//              Usage:
//                - Wait for tx_busy to be low.
//                - Apply the byte on tx_byte and pulse tx_en high for one clock
//                  cycle. tx_busy goes high immediately and stays high until
//                  the stop bit has been fully transmitted.
//
//              Parameters:
//                CLK_FREQ  - input clock frequency in Hz (default 300 MHz)
//                BAUD_RATE - desired serial baud rate   (default 115200)
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module uart_tx #(
    parameter integer CLK_FREQ  = 300_000_000,
    parameter integer BAUD_RATE = 115200
) (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] tx_byte,
    input  wire       tx_en,      // 1-cycle pulse to start transmission
    output reg        tx_pin,
    output wire       tx_busy
);

    localparam integer BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    reg [15:0] clk_cnt;
    reg [3:0]  bit_idx;
    reg [9:0]  shift_reg;   // {stop, data[7:0], start}
    reg        busy;

    assign tx_busy = busy;

    always @(posedge clk) begin
        if (rst) begin
            tx_pin    <= 1'b1;
            busy      <= 1'b0;
            clk_cnt   <= 16'd0;
            bit_idx   <= 4'd0;
            shift_reg <= 10'h3FF;
        end else begin
            if (!busy) begin
                // Idle - wait for a start request
                if (tx_en) begin
                    shift_reg <= {1'b1, tx_byte, 1'b0};   // {Stop, Data, Start}
                    tx_pin    <= 1'b0;                    // drive start bit
                    busy      <= 1'b1;
                    bit_idx   <= 4'd1;                    // next bit is D0
                    clk_cnt   <= 16'd0;
                end
            end else begin
                // Transmitting - hold each bit for one full BIT_PERIOD
                if (clk_cnt < BIT_PERIOD - 1) begin
                    clk_cnt <= clk_cnt + 1;
                end else begin
                    clk_cnt <= 16'd0;

                    if (bit_idx <= 4'd9) begin
                        // Shift out D0..D7 and the stop bit (index 9)
                        tx_pin  <= shift_reg[bit_idx];
                        bit_idx <= bit_idx + 1;
                    end else begin
                        // Stop bit has held for its full period - release
                        busy   <= 1'b0;
                        tx_pin <= 1'b1;
                    end
                end
            end
        end
    end

endmodule
