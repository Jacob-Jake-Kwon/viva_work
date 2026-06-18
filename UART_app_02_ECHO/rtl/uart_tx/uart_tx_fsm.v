`timescale 1ns / 1ps
module uart_tx_fsm #(
    parameter CLK_FREQ = 100000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire reset,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx_serial,
    output reg tx_busy,
    output reg tx_done
);
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam S_IDLE = 2'd0, S_START = 2'd1, S_DATA = 2'd2, S_STOP = 2'd3;
    reg [1:0] state_reg;
    reg [31:0] bit_timer;
    reg [2:0] bit_index;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state_reg <= S_IDLE;
            tx_serial <= 1'b1;
            tx_busy <= 1'b0;
            tx_done <= 1'b0;
            bit_timer <= 32'd0;
            bit_index <= 3'd0;
            data_reg <= 8'd0;
        end else begin
            tx_done <= 1'b0;
            case (state_reg)
                S_IDLE: begin
                    tx_serial <= 1'b1;
                    tx_busy <= 1'b0;
                    bit_timer <= 32'd0;
                    bit_index <= 3'd0;
                    if (tx_start) begin
                        data_reg <= tx_data;
                        tx_busy <= 1'b1;
                        state_reg <= S_START;
                    end
                end
                S_START: begin
                    tx_serial <= 1'b0;
                    tx_busy <= 1'b1;
                    if (bit_timer == CLKS_PER_BIT - 1) begin
                        bit_timer <= 32'd0;
                        state_reg <= S_DATA;
                    end else bit_timer <= bit_timer + 1'b1;
                end
                S_DATA: begin
                    tx_serial <= data_reg[bit_index];
                    if (bit_timer == CLKS_PER_BIT - 1) begin
                        bit_timer <= 32'd0;
                        if (bit_index == 3'd7) state_reg <= S_STOP;
                        else bit_index <= bit_index + 1'b1;
                    end else bit_timer <= bit_timer + 1'b1;
                end
                S_STOP: begin
                    tx_serial <= 1'b1;
                    if (bit_timer == CLKS_PER_BIT - 1) begin
                        bit_timer <= 32'd0;
                        tx_done <= 1'b1;
                        state_reg <= S_IDLE;
                    end else bit_timer <= bit_timer + 1'b1;
                end
            endcase
        end
    end
endmodule
