`timescale 1ns / 1ps
module uart_core_loopback_test_top(
    input wire clk,
    input wire btnU,
    input wire RsRx,
    output wire RsTx,
    output wire [15:0] led
);
    wire reset = btnU;
    wire [7:0] rx_data;
    wire rx_empty, tx_full, tx_busy, tx_done;
    reg rx_rd_en, tx_wr_en;
    reg [7:0] tx_wr_data;
    reg [7:0] last_rx_data;

    uart_core u_uart(
        .clk(clk), .reset(reset), .rx_serial(RsRx), .tx_serial(RsTx),
        .rx_rd_en(rx_rd_en), .rx_rd_data(rx_data), .rx_empty(rx_empty),
        .rx_full(), .rx_count(), .frame_error(led[11]), .overrun_error(led[12]),
        .tx_wr_en(tx_wr_en), .tx_wr_data(tx_wr_data), .tx_full(tx_full),
        .tx_empty(led[9]), .tx_count(), .tx_busy(tx_busy), .tx_done(tx_done)
    );

    always @(posedge clk) begin
        if (reset) begin
            rx_rd_en <= 1'b0;
            tx_wr_en <= 1'b0;
            tx_wr_data <= 8'd0;
            last_rx_data <= 8'd0;
        end else begin
            rx_rd_en <= 1'b0;
            tx_wr_en <= 1'b0;
            if (!rx_empty && !tx_full) begin
                rx_rd_en <= 1'b1;
                tx_wr_data <= rx_data;
                tx_wr_en <= 1'b1;
                last_rx_data <= rx_data;
            end
        end
    end

    assign led[7:0] = last_rx_data;
    assign led[8] = !rx_empty;
    assign led[10] = tx_busy;
    assign led[15:13] = {2'b00, tx_done};
endmodule
