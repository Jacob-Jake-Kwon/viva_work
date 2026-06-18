`timescale 1ns / 1ps
module uart_baud_tick_gen #(
    parameter CLK_FREQ = 100000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire reset,
    input wire enable,
    output reg tick
);
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    reg [31:0] count_reg;
    always @(posedge clk) begin
        if (reset || !enable) begin
            count_reg <= 32'd0;
            tick <= 1'b0;
        end else if (count_reg == CLKS_PER_BIT - 1) begin
            count_reg <= 32'd0;
            tick <= 1'b1;
        end else begin
            count_reg <= count_reg + 1'b1;
            tick <= 1'b0;
        end
    end
endmodule
