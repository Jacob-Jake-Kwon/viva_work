`timescale 1ns / 1ps

// Converts UART RX bytes into 3-byte register write packets:
//   1st byte: CMD  (8'h01 = write)
//   2nd byte: ADDR
//   3rd byte: DATA
module uart_reg_write_controller #(
    parameter CMD_WRITE = 8'h01
)(
    input wire clk,
    input wire reset,

    // Interface to the local uart_core RX FIFO.
    input wire [7:0] rx_data,
    input wire rx_empty,
    output reg rx_rd_en,

    output reg reg_wr_en,
    output reg [7:0] reg_wr_addr,
    output reg [7:0] reg_wr_data,

    output reg [1:0] byte_index,
    output reg [7:0] last_cmd,
    output reg cmd_error
);
    localparam WAIT_CMD  = 2'd0;
    localparam WAIT_ADDR = 2'd1;
    localparam WAIT_DATA = 2'd2;

    reg [7:0] cmd_reg;
    reg [7:0] addr_reg;

    always @(posedge clk) begin
        if (reset) begin
            byte_index <= WAIT_CMD;
            cmd_reg <= 8'd0;
            addr_reg <= 8'd0;
            last_cmd <= 8'd0;
            rx_rd_en <= 1'b0;
            reg_wr_en <= 1'b0;
            reg_wr_addr <= 8'd0;
            reg_wr_data <= 8'd0;
            cmd_error <= 1'b0;
        end else begin
            rx_rd_en <= 1'b0;
            reg_wr_en <= 1'b0;
            cmd_error <= 1'b0;

            if (!rx_empty) begin
                rx_rd_en <= 1'b1;

                case (byte_index)
                    WAIT_CMD: begin
                        cmd_reg <= rx_data;
                        last_cmd <= rx_data;
                        byte_index <= WAIT_ADDR;
                    end

                    WAIT_ADDR: begin
                        addr_reg <= rx_data;
                        byte_index <= WAIT_DATA;
                    end

                    WAIT_DATA: begin
                        if (cmd_reg == CMD_WRITE) begin
                            reg_wr_en <= 1'b1;
                            reg_wr_addr <= addr_reg;
                            reg_wr_data <= rx_data;
                        end else begin
                            cmd_error <= 1'b1;
                        end
                        byte_index <= WAIT_CMD;
                    end

                    default: begin
                        byte_index <= WAIT_CMD;
                    end
                endcase
            end
        end
    end
endmodule
