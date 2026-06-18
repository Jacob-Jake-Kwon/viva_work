`timescale 1ns / 1ps
module basys3_uart_rx_top(
    input wire clk,
    input wire btnU,
    input wire RsRx,
    output wire RsTx,
    output wire [15:0] led
);
    wire reset = btnU;
    wire [7:0] rx_data;
    wire rx_empty, rx_full, rx_valid, frame_error, overrun_error;
    wire [4:0] rx_count;
    reg rd_en;
    reg [7:0] last_rx_data;
    reg frame_error_latched;

    uart_rx_core u_rx(
        .clk(clk), .reset(reset), .rx(RsRx), .rd_en(rd_en), .rd_data(rx_data),
        .rx_empty(rx_empty), .rx_full(rx_full), .rx_count(rx_count),
        .rx_valid(rx_valid), .frame_error(frame_error), .overrun_error(overrun_error)
    );

    always @(posedge clk) begin
        if (reset) begin
            rd_en <= 1'b0;
            last_rx_data <= 8'd0;
            frame_error_latched <= 1'b0;
        end else begin
            rd_en <= !rx_empty;
            if (!rx_empty) last_rx_data <= rx_data;
            if (frame_error) frame_error_latched <= 1'b1;
        end
    end

    assign RsTx = 1'b1;
    assign led[7:0] = last_rx_data;
    assign led[8] = rx_valid;
    assign led[9] = rx_empty;
    assign led[10] = rx_full;
    assign led[11] = frame_error_latched;
    assign led[12] = overrun_error;
    assign led[15:13] = 3'b000;
endmodule
