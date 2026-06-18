module clock_divider_10ms(
    input clk,
    input reset,
    input enable,
    output reg tick
);
    reg [19:0] count_div;
    always @(posedge clk) begin
        if (reset) begin
            count_div <= 20'd0;
            tick <= 1'b0;
        end else begin
            tick <= 1'b0;
            if (enable) begin
                if (count_div == 20'd999_999) begin
                    count_div <= 20'd0;
                    tick <= 1'b1;
                end else begin
                    count_div <= count_div + 1'b1;
                end
            end else begin
                count_div <= 20'd0;
            end
        end
    end
endmodule
