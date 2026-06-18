`timescale 1ns / 1ps
module uart_rx_core #(
    parameter CLK_FREQ = 100000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire reset,
    input wire rx,
    input wire rd_en,
    output wire [7:0] rd_data,
    output wire rx_empty,
    output wire rx_full,
    output wire [4:0] rx_count,
    output wire rx_valid,
    output wire frame_error,
    output wire overrun_error
);
    wire rx_sync, fsm_valid;
    wire [7:0] fsm_data;
    wire fifo_full;
    reg overrun_reg;

    uart_rx_sync u_sync(.clk(clk), .reset(reset), .rx_async(rx), .rx_sync(rx_sync));
    uart_rx_fsm #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) u_fsm(
        .clk(clk), .reset(reset), .rx(rx_sync), .rx_data(fsm_data),
        .rx_valid(fsm_valid), .frame_error(frame_error), .busy()
    );
    uart_rx_fifo u_fifo(
        .clk(clk), .reset(reset), .wr_en(fsm_valid && !fifo_full),
        .wr_data(fsm_data), .rd_en(rd_en), .rd_data(rd_data),
        .full(fifo_full), .empty(rx_empty), .count(rx_count)
    );

    always @(posedge clk) begin
        if (reset) overrun_reg <= 1'b0;
        else if (fsm_valid && fifo_full) overrun_reg <= 1'b1;
    end

    assign rx_full = fifo_full;
    assign rx_valid = !rx_empty;
    assign overrun_error = overrun_reg;
endmodule
