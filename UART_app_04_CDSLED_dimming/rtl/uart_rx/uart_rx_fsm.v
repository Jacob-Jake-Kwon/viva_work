`timescale 1ns / 1ps
module uart_rx_fsm #(
    parameter CLK_FREQ = 100000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire reset,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_valid,
    output reg frame_error,
    output reg busy
);
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam HALF_BIT = CLKS_PER_BIT / 2;
    localparam S_IDLE = 2'd0, S_START = 2'd1, S_DATA = 2'd2, S_STOP = 2'd3;
    reg [1:0] state_reg;
    reg [31:0] timer;
    reg [2:0] bit_index;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state_reg <= S_IDLE;
            rx_data <= 8'd0;
            rx_valid <= 1'b0;
            frame_error <= 1'b0;
            busy <= 1'b0;
            timer <= 32'd0;
            bit_index <= 3'd0;
            data_reg <= 8'd0;
        end else begin
            rx_valid <= 1'b0;
            frame_error <= 1'b0;
            case (state_reg)
                S_IDLE: begin
                    busy <= 1'b0;
                    timer <= 32'd0;
                    bit_index <= 3'd0;
                    if (!rx) begin
                        busy <= 1'b1;
                        state_reg <= S_START;
                    end
                end
                S_START: begin
                    if (timer == HALF_BIT - 1) begin
                        timer <= 32'd0;
                        if (!rx) state_reg <= S_DATA;
                        else state_reg <= S_IDLE;
                    end else timer <= timer + 1'b1;
                end
                S_DATA: begin
                    if (timer == CLKS_PER_BIT - 1) begin
                        timer <= 32'd0;
                        data_reg[bit_index] <= rx;
                        if (bit_index == 3'd7) state_reg <= S_STOP;
                        else bit_index <= bit_index + 1'b1;
                    end else timer <= timer + 1'b1;
                end
                S_STOP: begin
                    if (timer == CLKS_PER_BIT - 1) begin
                        timer <= 32'd0;
                        rx_data <= data_reg;
                        rx_valid <= rx;
                        frame_error <= !rx;
                        state_reg <= S_IDLE;
                    end else timer <= timer + 1'b1;
                end
            endcase
        end
    end
endmodule
