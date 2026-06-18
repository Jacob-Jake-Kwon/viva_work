`timescale 1ns / 1ps

// simple_register_map.v
//
// 이번 과제에서 사용하는 최소 Register Map 모듈이다.
//
// 지원 Register는 2개이다.
//
// 0x00 : CTRL
// 0x01 : PWM_VALUE
//
// CTRL Register는 LED PWM 기능을 켜고 끄는 용도이다.
// PWM_VALUE Register는 LED 밝기값을 저장하는 용도이다.
//
// CdS 입력 방향은 외부 회로에서 맞춘다.
// FPGA 내부에서는 반전 Register를 두지 않는다.

module simple_register_map(
    input  wire       clk,
    input  wire       reset,

    // Register Write 요청 신호이다.
    input  wire       reg_wr_en,

    // Write 대상 Register 주소이다.
    input  wire [7:0] reg_wr_addr,

    // Write할 Register 데이터이다.
    input  wire [7:0] reg_wr_data,

    // CTRL Register 출력이다.
    output reg [7:0]  ctrl_reg,

    // PWM_VALUE Register 출력이다.
    output reg [7:0]  pwm_value_reg,

    // 정의되지 않은 주소에 Write가 들어오면 1 Clock 동안 1이 된다.
    output reg        reg_error
);

    localparam ADDR_CTRL      = 8'h00;
    localparam ADDR_PWM_VALUE = 8'h01;

    always @(posedge clk) begin
        if (reset) begin
            ctrl_reg      <= 8'h00;
            pwm_value_reg <= 8'h00;
            reg_error     <= 1'b0;
        end else begin
            reg_error <= 1'b0;

            if (reg_wr_en) begin
                case (reg_wr_addr)
                    ADDR_CTRL: begin
                        ctrl_reg <= reg_wr_data;
                    end

                    ADDR_PWM_VALUE: begin
                        pwm_value_reg <= reg_wr_data;
                    end

                    default: begin
                        reg_error <= 1'b1;
                    end
                endcase
            end
        end
    end

endmodule
