`timescale 1ns / 1ps
module basys3_uart_echo_top(
    input wire clk,
    input wire btnU,
    input wire RsRx,
    output wire RsTx,
    output wire [15:0] led
);
    wire reset = btnU;
    wire [7:0] rx_data, tx_data;
    wire rx_empty, tx_full;
    wire rx_rd_en, tx_wr_en;
    uart_core u_uart(
        .clk(clk), .reset(reset), .rx_serial(RsRx), .tx_serial(RsTx),
        .rx_rd_en(rx_rd_en), .rx_rd_data(rx_data), .rx_empty(rx_empty),
        .rx_full(led[9]), .rx_count(), .frame_error(led[11]), .overrun_error(led[12]),
        .tx_wr_en(tx_wr_en), .tx_wr_data(tx_data), .tx_full(tx_full),
        .tx_empty(led[10]), .tx_count(), .tx_busy(led[13]), .tx_done(led[14])
    );
    uart_echo_controller u_echo(
        .clk(clk), .reset(reset), .rx_data(rx_data), .rx_empty(rx_empty),
        .rx_rd_en(rx_rd_en), .tx_wr_en(tx_wr_en), .tx_wr_data(tx_data), .tx_full(tx_full)
    );
    assign led[7:0] = rx_data;
    assign led[8] = !rx_empty;
    assign led[15] = tx_full;
endmodule
