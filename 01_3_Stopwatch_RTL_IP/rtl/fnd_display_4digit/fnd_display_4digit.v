module fnd_display_4digit(
    input clk,
    input reset,
    input [3:0] digit0,
    input [3:0] digit1,
    input [3:0] digit2,
    input [3:0] digit3,
    output [6:0] seg,
    output [3:0] an,
    output dp
);
    wire [1:0] digit_sel;
    wire [3:0] current_digit;
    fnd_scan_counter u_scan(.clk(clk), .reset(reset), .digit_sel(digit_sel));
    fnd_mux_4digit_dp u_mux(
        .digit0(digit0), .digit1(digit1), .digit2(digit2), .digit3(digit3),
        .digit_sel(digit_sel), .current_digit(current_digit), .an(an), .dp(dp)
    );
    fnd_decoder u_decoder(.bcd(current_digit), .seg(seg));
endmodule
