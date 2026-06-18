`timescale 1ns / 1ps
module basys3_uart_led_pwm_cds_fnd_top #(
    parameter CLK_FREQ = 100000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire btnU,
    input wire RsRx,
    input wire [0:0] JA,
    output wire RsTx,
    output wire [15:0] led,
    output wire [6:0] seg,
    output wire [3:0] an,
    output wire dp
);
    wire reset = btnU;
    wire [7:0] rx_data, reg_addr, reg_wdata, ctrl_reg, duty_reg;
    wire rx_empty, rx_rd_en, reg_wr_en, cds_is_light;
    uart_core #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) u_uart(
        .clk(clk), .reset(reset), .rx_serial(RsRx), .tx_serial(RsTx),
        .rx_rd_en(rx_rd_en), .rx_rd_data(rx_data), .rx_empty(rx_empty),
        .rx_full(), .rx_count(), .frame_error(), .overrun_error(),
        .tx_wr_en(1'b0), .tx_wr_data(8'd0), .tx_full(), .tx_empty(), .tx_count(), .tx_busy(), .tx_done()
    );
    uart_reg_write_controller u_ctrl(
        .clk(clk), .reset(reset), .rx_data(rx_data), .rx_empty(rx_empty),
        .rx_rd_en(rx_rd_en), .reg_wr_en(reg_wr_en), .reg_addr(reg_addr), .reg_wdata(reg_wdata)
    );
    simple_register_map u_regs(
        .clk(clk), .reset(reset), .wr_en(reg_wr_en), .addr(reg_addr), .wdata(reg_wdata),
        .ctrl_reg(ctrl_reg), .duty_reg(duty_reg)
    );
    cds_input_filter u_cds(.clk(clk), .reset(reset), .cds_sw_raw(JA[0]), .cds_sw_sync(), .cds_is_light(cds_is_light));
    led_pwm_controller u_pwm(.clk(clk), .reset(reset), .enable(ctrl_reg[0] & cds_is_light), .duty(duty_reg), .led(led));
    fnd_status_3digit_display u_fnd(
        .clk(clk), .reset(reset), .enable(ctrl_reg[1]), .cds_is_light(cds_is_light),
        .duty(duty_reg), .seg(seg), .an(an), .dp(dp)
    );
endmodule
