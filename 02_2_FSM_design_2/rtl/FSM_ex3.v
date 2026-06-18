module FSM_ex3(input wire clk, input wire reset, input wire din, output reg dout);
    localparam S0 = 2'd0, S1 = 2'd1, S10 = 2'd2, S101 = 2'd3;
    reg [1:0] state;
    always @(posedge clk) begin
        if (reset) begin state <= S0; dout <= 1'b0; end
        else begin
            dout <= 1'b0;
            case (state)
                S0: state <= din ? S1 : S0;
                S1: state <= din ? S1 : S10;
                S10: state <= din ? S101 : S0;
                S101: begin dout <= !din; state <= din ? S1 : S0; end
            endcase
        end
    end
endmodule
