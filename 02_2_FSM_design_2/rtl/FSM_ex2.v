module FSM_ex2(input wire clk, input wire reset, input wire in, output reg out);
    localparam S0 = 2'd0, S1 = 2'd1, S2 = 2'd2;
    reg [1:0] state;
    always @(posedge clk) begin
        if (reset) state <= S0;
        else case (state)
            S0: state <= in ? S1 : S0;
            S1: state <= in ? S2 : S0;
            default: state <= in ? S2 : S0;
        endcase
    end
    always @(*) out = (state == S2);
endmodule
