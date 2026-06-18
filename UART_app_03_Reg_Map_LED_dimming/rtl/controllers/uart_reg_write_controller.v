`timescale 1ns / 1ps
module uart_reg_write_controller(
    input wire clk,
    input wire reset,
    input wire [7:0] rx_data,
    input wire rx_empty,
    output reg rx_rd_en,
    output reg reg_wr_en,
    output reg [7:0] reg_addr,
    output reg [7:0] reg_wdata
);
    localparam S_ADDR = 1'b0, S_DATA = 1'b1;
    reg state;
    always @(posedge clk) begin
        if (reset) begin
            state <= S_ADDR;
            rx_rd_en <= 1'b0;
            reg_wr_en <= 1'b0;
            reg_addr <= 8'd0;
            reg_wdata <= 8'd0;
        end else begin
            rx_rd_en <= 1'b0;
            reg_wr_en <= 1'b0;
            if (!rx_empty) begin
                rx_rd_en <= 1'b1;
                if (state == S_ADDR) begin
                    reg_addr <= rx_data;
                    state <= S_DATA;
                end else begin
                    reg_wdata <= rx_data;
                    reg_wr_en <= 1'b1;
                    state <= S_ADDR;
                end
            end
        end
    end
endmodule
