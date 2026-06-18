`timescale 1ns / 1ps
module cds_input_filter(
    input wire clk,
    input wire reset,
    input wire cds_sw_raw,
    output wire cds_sw_sync,
    output wire cds_is_light
);
    reg cds_meta, cds_sync_reg;
    always @(posedge clk) begin
        if (reset) begin
            cds_meta <= 1'b0;
            cds_sync_reg <= 1'b0;
        end else begin
            cds_meta <= cds_sw_raw;
            cds_sync_reg <= cds_meta;
        end
    end
    assign cds_sw_sync = cds_sync_reg;
    assign cds_is_light = cds_sync_reg;
endmodule
