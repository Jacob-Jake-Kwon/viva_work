module start_stop_control(
    input clk,
    input reset,
    input start,
    input stop,
    output reg running
);
    always @(posedge clk) begin
        if (reset) running <= 1'b0;
        else if (start) running <= 1'b1;
        else if (stop) running <= 1'b0;
    end
endmodule
