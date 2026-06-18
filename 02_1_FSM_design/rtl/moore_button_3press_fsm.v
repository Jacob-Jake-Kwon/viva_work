module moore_button_3press_fsm(
    input wire clk,
    input wire reset,
    input wire button_pulse,
    output reg led_on
);
    localparam S0 = 2'd0, S1 = 2'd1, S2 = 2'd2, S3 = 2'd3;
    reg [1:0] state;
    always @(posedge clk) begin
        if (reset) state <= S0;
        else if (button_pulse) begin
            case (state)
                S0: state <= S1;
                S1: state <= S2;
                S2: state <= S3;
                default: state <= S0;
            endcase
        end
    end
    always @(*) led_on = (state == S3);
endmodule
