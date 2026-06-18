`timescale 1ns / 1ps
module uart_core #(
    parameter CLK_FREQ = 100000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire reset,
    input wire rx_serial,
    output wire tx_serial,
    input wire rx_rd_en,
    output wire [7:0] rx_rd_data,
    output wire rx_empty,
    output wire rx_full,
    output wire [4:0] rx_count,
    output wire frame_error,
    output wire overrun_error,
    input wire tx_wr_en,
    input wire [7:0] tx_wr_data,
    output wire tx_full,
    output wire tx_empty,
    output wire [4:0] tx_count,
    output wire tx_busy,
    output wire tx_done
);
    uart_rx_core #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) u_rx(
        .clk(clk), .reset(reset), .rx(rx_serial), .rd_en(rx_rd_en),
        .rd_data(rx_rd_data), .rx_empty(rx_empty), .rx_full(rx_full),
        .rx_count(rx_count), .rx_valid(), .frame_error(frame_error),
        .overrun_error(overrun_error)
    );
    uart_tx_core #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) u_tx(
        .clk(clk), .reset(reset), .tx_wr_en(tx_wr_en), .tx_wr_data(tx_wr_data),
        .tx_full(tx_full), .tx_empty(tx_empty), .tx_count(tx_count),
        .tx_busy(tx_busy), .tx_done(tx_done), .tx_serial(tx_serial)
    );
endmodule
