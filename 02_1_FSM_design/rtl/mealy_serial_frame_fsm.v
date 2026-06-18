module mealy_serial_frame_fsm(
    input wire clk,
    input wire reset,
    input wire din,
    output reg frame_detected
);
    localparam S_IDLE = 2'd0, S_A = 2'd1, S_AB = 2'd2;
    reg [1:0] state;
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            frame_detected <= 1'b0;
        end else begin
            frame_detected <= 1'b0;
            case (state)
                S_IDLE: state <= din ? S_A : S_IDLE;
                S_A: state <= din ? S_A : S_AB;
                S_AB: begin
                    frame_detected <= din;
                    state <= din ? S_A : S_IDLE;
                end
            endcase
        end
    end
endmodule
