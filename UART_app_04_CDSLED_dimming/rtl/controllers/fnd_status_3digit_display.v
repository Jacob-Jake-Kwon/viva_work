`timescale 1ns / 1ps
module fnd_status_3digit_display(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire cds_is_light,
    input wire [7:0] duty,
    output reg [6:0] seg,
    output reg [3:0] an,
    output wire dp
);
    reg [15:0] scan_div;
    reg [3:0] nibble;
    assign dp = 1'b1;
    always @(posedge clk) begin
        if (reset) scan_div <= 16'd0;
        else scan_div <= scan_div + 1'b1;
    end
    always @(*) begin
        an = 4'b1111;
        nibble = 4'h0;
        if (enable) begin
            case (scan_div[15:14])
                2'd0: begin an = 4'b1110; nibble = duty[3:0]; end
                2'd1: begin an = 4'b1101; nibble = duty[7:4]; end
                2'd2: begin an = 4'b1011; nibble = cds_is_light ? 4'hA : 4'hB; end
                default: begin an = 4'b0111; nibble = 4'h0; end
            endcase
        end
        case (nibble)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            default: seg = 7'b1111111;
        endcase
    end
endmodule
