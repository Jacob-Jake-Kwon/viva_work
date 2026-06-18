module stopwatch_counter_4digit(
    input clk,
    input reset,
    input enable,
    output reg [3:0] digit0,
    output reg [3:0] digit1,
    output reg [3:0] digit2,
    output reg [3:0] digit3
);
    wire carry0 = (digit0 == 4'd9);
    wire carry1 = (digit0 == 4'd9) && (digit1 == 4'd9);
    wire carry2 = (digit0 == 4'd9) && (digit1 == 4'd9) && (digit2 == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0; digit1 <= 4'd0; digit2 <= 4'd0; digit3 <= 4'd0;
        end else if (enable) begin
            digit0 <= carry0 ? 4'd0 : digit0 + 1'b1;
            if (carry0) digit1 <= (digit1 == 4'd9) ? 4'd0 : digit1 + 1'b1;
            if (carry1) digit2 <= (digit2 == 4'd9) ? 4'd0 : digit2 + 1'b1;
            if (carry2) digit3 <= (digit3 == 4'd9) ? 4'd0 : digit3 + 1'b1;
        end
    end
endmodule
