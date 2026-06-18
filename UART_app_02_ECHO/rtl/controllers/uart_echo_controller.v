`timescale 1ns / 1ps
module uart_echo_controller(
    input wire clk,
    input wire reset,
    input wire [7:0] rx_data,
    input wire rx_empty,
    output reg rx_rd_en,
    output reg tx_wr_en,
    output reg [7:0] tx_wr_data,
    input wire tx_full
);
    always @(posedge clk) begin
        if (reset) begin
            rx_rd_en <= 1'b0;
            tx_wr_en <= 1'b0;
            tx_wr_data <= 8'd0;
        end else begin
            rx_rd_en <= 1'b0;
            tx_wr_en <= 1'b0;
            if (!rx_empty && !tx_full) begin
                rx_rd_en <= 1'b1;
                tx_wr_data <= rx_data;
                tx_wr_en <= 1'b1;
            end
        end
    end
endmodule
