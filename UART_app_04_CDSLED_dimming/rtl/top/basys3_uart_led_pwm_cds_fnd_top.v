`timescale 1ns / 1ps

module basys3_uart_led_pwm_cds_fnd_top #(
    parameter CLK_FREQ = 100_000_000,
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

    wire [7:0] rx_data;
    wire rx_empty;
    wire rx_full;
    wire [4:0] rx_count;
    wire rx_rd_en;
    wire frame_error;
    wire overrun_error;

    wire tx_full;
    wire tx_empty;
    wire [4:0] tx_count;
    wire tx_busy;
    wire tx_done;

    wire reg_wr_en;
    wire [7:0] reg_wr_addr;
    wire [7:0] reg_wr_data;

    wire [7:0] ctrl_reg;
    wire [7:0] pwm_value_reg;
    wire reg_error;

    wire [1:0] byte_index;
    wire [7:0] last_cmd;
    wire cmd_error;

    wire cds_sw_raw = JA[0];
    wire cds_sw_sync;
    wire cds_is_light;
    wire [3:0] fnd_status_code = cds_is_light ? 4'hA : 4'hB;

    uart_core #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) u_uart_core (
        .clk(clk),
        .reset(reset),
        .rx_serial(RsRx),
        .tx_serial(RsTx),
        .rx_rd_en(rx_rd_en),
        .rx_rd_data(rx_data),
        .rx_empty(rx_empty),
        .rx_full(rx_full),
        .rx_count(rx_count),
        .frame_error(frame_error),
        .overrun_error(overrun_error),
        .tx_wr_en(1'b0),
        .tx_wr_data(8'h00),
        .tx_full(tx_full),
        .tx_empty(tx_empty),
        .tx_count(tx_count),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    uart_reg_write_controller u_uart_reg_write_controller (
        .clk(clk),
        .reset(reset),
        .rx_data(rx_data),
        .rx_empty(rx_empty),
        .rx_rd_en(rx_rd_en),
        .reg_wr_en(reg_wr_en),
        .reg_wr_addr(reg_wr_addr),
        .reg_wr_data(reg_wr_data),
        .byte_index(byte_index),
        .last_cmd(last_cmd),
        .cmd_error(cmd_error)
    );

    simple_register_map u_simple_register_map (
        .clk(clk),
        .reset(reset),
        .reg_wr_en(reg_wr_en),
        .reg_wr_addr(reg_wr_addr),
        .reg_wr_data(reg_wr_data),
        .ctrl_reg(ctrl_reg),
        .pwm_value_reg(pwm_value_reg),
        .reg_error(reg_error)
    );

    led_pwm_controller #(
        .PWM_PRESCALE(390)
    ) u_led_pwm_controller (
        .clk(clk),
        .reset(reset),
        .ctrl_reg(ctrl_reg),
        .pwm_value(pwm_value_reg),
        .led(led)
    );

    cds_input_filter u_cds_input_filter (
        .clk(clk),
        .reset(reset),
        .cds_sw_raw(cds_sw_raw),
        .cds_sw_sync(cds_sw_sync),
        .cds_is_light(cds_is_light)
    );

    fnd_status_3digit_display #(
        .CLK_FREQ_HZ(CLK_FREQ),
        .SCAN_HZ(1000)
    ) u_fnd_status_3digit_display (
        .clk(clk),
        .reset(reset),
        .status_valid(ctrl_reg[1]),
        .status_code(fnd_status_code),
        .value_bcd(12'h000),
        .value_valid(1'b0),
        .seg(seg),
        .an(an),
        .dp(dp)
    );
endmodule
