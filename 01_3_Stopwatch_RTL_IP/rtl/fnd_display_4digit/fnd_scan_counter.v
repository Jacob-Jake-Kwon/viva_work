module fnd_scan_counter(
    input clk,
    input reset,
    output reg [1:0] digit_sel
);
    reg [15:0] scan_div;
    always @(posedge clk) begin
        if (reset) begin
            scan_div <= 16'd0;
            digit_sel <= 2'd0;
        end else begin
            scan_div <= scan_div + 1'b1;
            digit_sel <= scan_div[15:14];
        end
    end
endmodule
