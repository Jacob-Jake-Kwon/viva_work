`timescale 1ns / 1ps
module basys3_uart_bram_line_rx_top(
    input wire clk,
    input wire btnU,
    input wire RsRx,
    output wire RsTx,
    output wire [15:0] led
);
    wire reset = btnU;
    wire [7:0] rx_data;
    wire rx_empty, rx_valid, frame_error, overrun_error;
    wire [4:0] rx_count;
    reg rd_en;
    reg frame_valid_latched;
    wire frame_valid, line_receiving, line_overflow, line_discarding;
    wire [7:0] display_last_data;
    wire [6:0] display_frame_length;

    uart_rx_core u_rx(
        .clk(clk), .reset(reset), .rx(RsRx), .rd_en(rd_en), .rd_data(rx_data),
        .rx_empty(rx_empty), .rx_full(), .rx_count(rx_count), .rx_valid(rx_valid),
        .frame_error(frame_error), .overrun_error(overrun_error)
    );
    rx_bram_line_buffer u_line(
        .clk(clk), .reset(reset), .rx_valid(rd_en), .rx_data(rx_data),
        .frame_valid(frame_valid), .last_data(display_last_data),
        .frame_length(display_frame_length), .line_receiving(line_receiving),
        .line_overflow(line_overflow), .line_discarding(line_discarding)
    );

    always @(posedge clk) begin
        if (reset) begin
            rd_en <= 1'b0;
            frame_valid_latched <= 1'b0;
        end else begin
            rd_en <= !rx_empty;
            if (frame_valid) frame_valid_latched <= 1'b1;
        end
    end

    assign led[7:0] = display_last_data;
    assign led[8] = frame_valid_latched;
    assign led[9] = line_receiving;
    assign led[10] = line_overflow;
    assign led[11] = line_discarding;
    assign led[12] = overrun_error;
    assign led[15:13] = display_frame_length[2:0];
    assign RsTx = 1'b1;
endmodule
