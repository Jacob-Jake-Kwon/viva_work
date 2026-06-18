`timescale 1ns / 1ps
module uart_rx_sync(
    input wire clk,
    input wire reset,
    input wire rx_async,
    output reg rx_sync
);
    reg rx_meta;
    always @(posedge clk) begin
        if (reset) begin
            rx_meta <= 1'b1;
            rx_sync <= 1'b1;
        end else begin
            rx_meta <= rx_async;
            rx_sync <= rx_meta;
        end
    end
endmodule
