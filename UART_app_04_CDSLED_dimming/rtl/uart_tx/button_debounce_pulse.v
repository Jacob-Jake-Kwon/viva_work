`timescale 1ns / 1ps
module button_debounce_pulse #(
    parameter DEBOUNCE_LIMIT = 2000000
)(
    input wire clk,
    input wire rst,
    input wire btn_in,
    output reg btn_pulse
);
    reg btn_meta, btn_sync, btn_stable, btn_stable_d;
    reg [21:0] debounce_cnt;

    always @(posedge clk) begin
        if (rst) begin
            btn_meta <= 1'b0;
            btn_sync <= 1'b0;
        end else begin
            btn_meta <= btn_in;
            btn_sync <= btn_meta;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            btn_stable <= 1'b0;
            btn_stable_d <= 1'b0;
            debounce_cnt <= 22'd0;
            btn_pulse <= 1'b0;
        end else begin
            btn_pulse <= 1'b0;
            btn_stable_d <= btn_stable;
            if (btn_sync == btn_stable) begin
                debounce_cnt <= 22'd0;
            end else if (debounce_cnt == DEBOUNCE_LIMIT - 1) begin
                debounce_cnt <= 22'd0;
                btn_stable <= btn_sync;
            end else begin
                debounce_cnt <= debounce_cnt + 1'b1;
            end
            if ((btn_stable == 1'b1) && (btn_stable_d == 1'b0)) btn_pulse <= 1'b1;
        end
    end
endmodule
