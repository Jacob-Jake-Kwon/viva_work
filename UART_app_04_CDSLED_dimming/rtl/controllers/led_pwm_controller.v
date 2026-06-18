`timescale 1ns / 1ps
module led_pwm_controller(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] duty,
    output wire [15:0] led
);
    reg [7:0] pwm_cnt;
    always @(posedge clk) begin
        if (reset) pwm_cnt <= 8'd0;
        else pwm_cnt <= pwm_cnt + 1'b1;
    end
    assign led = (enable && (pwm_cnt < duty)) ? 16'hFFFF : 16'h0000;
endmodule
