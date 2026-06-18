`timescale 1ns / 1ps
module simple_register_map(
    input wire clk,
    input wire reset,
    input wire wr_en,
    input wire [7:0] addr,
    input wire [7:0] wdata,
    output reg [7:0] ctrl_reg,
    output reg [7:0] duty_reg
);
    always @(posedge clk) begin
        if (reset) begin
            ctrl_reg <= 8'd0;
            duty_reg <= 8'd0;
        end else if (wr_en) begin
            case (addr)
                8'h00: ctrl_reg <= wdata;
                8'h01: duty_reg <= wdata;
            endcase
        end
    end
endmodule
