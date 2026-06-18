`timescale 1ns / 1ps
module uart_tx_sender(
    input wire clk,
    input wire reset,
    input wire [7:0] fifo_rd_data,
    input wire fifo_empty,
    output reg fifo_rd_en,
    output reg [7:0] tx_data,
    output reg tx_start,
    input wire tx_busy
);
    localparam S_IDLE = 2'd0, S_READ = 2'd1, S_START = 2'd2, S_WAIT = 2'd3;
    reg [1:0] state_reg;

    always @(posedge clk) begin
        if (reset) begin
            state_reg <= S_IDLE;
            fifo_rd_en <= 1'b0;
            tx_start <= 1'b0;
            tx_data <= 8'd0;
        end else begin
            fifo_rd_en <= 1'b0;
            tx_start <= 1'b0;
            case (state_reg)
                S_IDLE: if (!fifo_empty && !tx_busy) state_reg <= S_READ;
                S_READ: begin
                    fifo_rd_en <= 1'b1;
                    tx_data <= fifo_rd_data;
                    state_reg <= S_START;
                end
                S_START: begin
                    tx_start <= 1'b1;
                    state_reg <= S_WAIT;
                end
                S_WAIT: if (!tx_busy) state_reg <= S_IDLE;
            endcase
        end
    end
endmodule
