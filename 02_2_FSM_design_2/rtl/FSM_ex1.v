module FSM_ex1(input wire clk, input wire reset, input wire in, output reg out);
    localparam A = 1'b0, B = 1'b1;
    reg state;
    always @(posedge clk) begin
        if (reset) state <= A;
        else state <= in ? B : A;
    end
    always @(*) out = (state == B);
endmodule
