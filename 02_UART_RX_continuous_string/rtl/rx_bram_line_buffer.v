`timescale 1ns / 1ps
module rx_bram_line_buffer #(
    parameter ADDR_WIDTH = 6
)(
    input wire clk,
    input wire reset,
    input wire rx_valid,
    input wire [7:0] rx_data,
    output reg frame_valid,
    output reg [7:0] last_data,
    output reg [ADDR_WIDTH:0] frame_length,
    output reg line_receiving,
    output reg line_overflow,
    output reg line_discarding
);
    reg [7:0] mem [0:(1 << ADDR_WIDTH)-1];
    reg [ADDR_WIDTH-1:0] wr_addr;
    wire is_eol = (rx_data == 8'h0A) || (rx_data == 8'h0D);

    always @(posedge clk) begin
        if (reset) begin
            frame_valid <= 1'b0;
            last_data <= 8'd0;
            frame_length <= 0;
            line_receiving <= 1'b0;
            line_overflow <= 1'b0;
            line_discarding <= 1'b0;
            wr_addr <= 0;
        end else begin
            frame_valid <= 1'b0;
            if (rx_valid) begin
                last_data <= rx_data;
                if (is_eol) begin
                    frame_valid <= line_receiving && !line_discarding;
                    frame_length <= wr_addr;
                    wr_addr <= 0;
                    line_receiving <= 1'b0;
                    line_discarding <= 1'b0;
                end else if (!line_discarding) begin
                    line_receiving <= 1'b1;
                    if (&wr_addr) begin
                        line_overflow <= 1'b1;
                        line_discarding <= 1'b1;
                    end else begin
                        mem[wr_addr] <= rx_data;
                        wr_addr <= wr_addr + 1'b1;
                    end
                end
            end
        end
    end
endmodule
