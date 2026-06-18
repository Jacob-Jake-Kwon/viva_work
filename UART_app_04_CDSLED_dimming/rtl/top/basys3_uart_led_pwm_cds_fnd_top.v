`timescale 1ns / 1ps

// basys3_uart_led_pwm_cds_fnd_top.v
//
// UART Register Map 기반 LED PWM 디밍 + CdS FND 상태 표시 Top 모듈이다.
//
// 기존 UART Register Map + LED PWM 구조는 유지한다.
// 이번 단계에서는 CdS 디지털 입력과 FND 상태 표시만 추가한다.
//
// CdS는 아날로그값이 아니다.
// 외부 TR / 비교기 / 히스테리시스 회로에서 ON/OFF로 변환된
// 1-bit 디지털 입력을 cds_sw_raw로 받는다.
//
// FND 표시 기준:
// 밝음 / 낮  -> L---
// 어두움 / 밤 -> d---
//
// Top Module은 기능을 직접 구현하지 않는다.
// Top Module은 보드 핀 연결, uart_core 연결,
// Controller 연결만 담당한다.
//
// UART 입력 포맷은 다음 3 Byte이다.
//
// CMD ADDR DATA
//
// 예시:
// 01 00 01 -> CTRL = 0x01
// 01 01 80 -> PWM_VALUE = 0x80
//
// XDC 기준:
// Digilent Basys-3-Master.xdc의 포트명을 따른다.
// CdS 입력은 JA[0]로 받는다.

module basys3_uart_led_pwm_cds_fnd_top #(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUD_RATE = 9600,
    parameter FIFO_DEPTH = 256,
    parameter FIFO_ADDR_WIDTH = 8
)(
    // Basys3 100 MHz Clock 입력이다.
    input  wire        clk,

    // Basys3 btnU 버튼이다.
    // 이번 과제에서는 Active-high Reset으로 사용한다.
    input  wire        btnU,

    // PC에서 FPGA로 들어오는 UART RX 신호이다.
    input  wire        RsRx,

    // PMOD JA 포트이다.
    // Basys-3-Master.xdc의 JA[0]를 CdS 디지털 입력으로 사용한다.
    input  wire [0:0]  JA,

    // FPGA에서 PC로 나가는 UART TX 신호이다.
    // 이번 과제에서는 TX 응답을 사용하지 않지만,
    // 기존 uart_core가 TX 포트를 가지므로 그대로 연결한다.
    output wire        RsTx,

    // Basys3 LED 16개 출력이다.
    output wire [15:0] led,

    // Basys3 FND 출력이다.
    output wire [6:0]  seg,
    output wire [3:0]  an,
    output wire        dp
);

    // btnU를 내부 Reset 신호로 사용한다.
    wire reset;

    // Active-high Reset이다.
    assign reset = btnU;

    // =========================================================
    // 기존 uart_core RX Stream 신호
    // =========================================================

    // uart_core가 복원한 수신 Byte이다.
    wire [7:0] rx_stream_data;

    // rx_stream_data가 유효함을 나타낸다.
    wire       rx_stream_valid;

    // 뒤쪽 controller가 수신 Byte를 받을 수 있음을 나타낸다.
    wire       rx_stream_ready;

    // =========================================================
    // 기존 uart_core TX Stream 신호
    // =========================================================

    wire [7:0] tx_stream_data;
    wire       tx_stream_valid;
    wire       tx_stream_ready;

    assign tx_stream_data  = 8'h00;
    assign tx_stream_valid = 1'b0;

    // =========================================================
    // uart_core 상태 신호
    // =========================================================

    wire rx_empty;
    wire rx_full;
    wire [FIFO_ADDR_WIDTH:0] rx_count;
    wire tx_empty;
    wire tx_full;
    wire [FIFO_ADDR_WIDTH:0] tx_count;
    wire tx_busy;
    wire tx_done;
    wire frame_error;
    wire overrun_error;

    // =========================================================
    // Internal Register Write Interface
    // =========================================================

    wire       reg_wr_en;
    wire [7:0] reg_wr_addr;
    wire [7:0] reg_wr_data;

    // =========================================================
    // Register Map 출력
    // =========================================================

    wire [7:0] ctrl_reg;
    wire [7:0] pwm_value_reg;
    wire       reg_error;

    // =========================================================
    // 확인용 상태 신호
    // =========================================================

    wire [1:0] byte_index;
    wire [7:0] last_cmd;
    wire       cmd_error;

    // =========================================================
    // CdS 상태 신호
    // =========================================================

    wire cds_sw_raw;
    wire cds_sw_sync;
    wire cds_is_light;
    wire [3:0] fnd_status_code;

    // Basys-3-Master.xdc의 JA[0] 포트를 CdS 디지털 입력으로 사용한다.
    assign cds_sw_raw = JA[0];

    // 4'hA는 L, 4'hB는 d이다.
    assign fnd_status_code = cds_is_light ? 4'hA : 4'hB;

    // =========================================================
    // 기존 uart_core 인스턴스
    // =========================================================

    uart_core #(
        .CLK_FREQ        (CLK_FREQ),
        .BAUD_RATE       (BAUD_RATE),
        .FIFO_DEPTH      (FIFO_DEPTH),
        .FIFO_ADDR_WIDTH (FIFO_ADDR_WIDTH)
    ) u_uart_core (
        .clk           (clk),
        .reset         (reset),

        .rx_serial     (RsRx),
        .tx_serial     (RsTx),

        .rx_out_data   (rx_stream_data),
        .rx_out_valid  (rx_stream_valid),
        .rx_out_ready  (rx_stream_ready),

        .rx_empty      (rx_empty),
        .rx_full       (rx_full),
        .rx_fifo_clear (1'b0),
        .rx_count      (rx_count),
        .frame_error   (frame_error),
        .overrun_error (overrun_error),

        .tx_in_data    (tx_stream_data),
        .tx_in_valid   (tx_stream_valid),
        .tx_in_ready   (tx_stream_ready),

        .tx_empty      (tx_empty),
        .tx_full       (tx_full),
        .tx_count      (tx_count),
        .tx_busy       (tx_busy),
        .tx_done       (tx_done)
    );

    // =========================================================
    // CMD ADDR DATA 고정 포맷 수신 제어
    // =========================================================

    uart_reg_write_controller u_uart_reg_write_controller (
        .clk         (clk),
        .reset       (reset),

        .in_data     (rx_stream_data),
        .in_valid    (rx_stream_valid),
        .in_ready    (rx_stream_ready),

        .reg_wr_en   (reg_wr_en),
        .reg_wr_addr (reg_wr_addr),
        .reg_wr_data (reg_wr_data),

        .byte_index  (byte_index),
        .last_cmd    (last_cmd),
        .cmd_error   (cmd_error)
    );

    // =========================================================
    // 최소 Register Map
    // =========================================================

    simple_register_map u_simple_register_map (
        .clk            (clk),
        .reset          (reset),

        .reg_wr_en      (reg_wr_en),
        .reg_wr_addr    (reg_wr_addr),
        .reg_wr_data    (reg_wr_data),

        .ctrl_reg       (ctrl_reg),
        .pwm_value_reg  (pwm_value_reg),
        .reg_error      (reg_error)
    );

    // =========================================================
    // LED PWM 디밍
    // =========================================================

    led_pwm_controller #(
        .PWM_PRESCALE(390)
    ) u_led_pwm_controller (
        .clk       (clk),
        .reset     (reset),

        .ctrl_reg  (ctrl_reg),
        .pwm_value (pwm_value_reg),

        .led       (led)
    );

    // =========================================================
    // CdS 디지털 입력 동기화 및 반전 처리
    // =========================================================

    cds_input_filter u_cds_input_filter (
        .clk          (clk),
        .reset        (reset),

        .cds_sw_raw   (cds_sw_raw),
        .cds_sw_sync  (cds_sw_sync),
        .cds_is_light (cds_is_light)
    );

    // =========================================================
    // FND 상태 표시
    // =========================================================

    fnd_status_3digit_display #(
        .CLK_FREQ_HZ (CLK_FREQ),
        .SCAN_HZ     (1000)
    ) u_fnd_status_3digit_display (
        .clk         (clk),
        .reset       (reset),
        .status_valid(ctrl_reg[1]),

        .status_code (fnd_status_code),

        // 이번 CdS 단계에서는 거리값이 없으므로 하위 3자리는 ---로 표시한다.
        .value_bcd   (12'h000),
        .value_valid (1'b0),

        .seg         (seg),
        .an          (an),
        .dp          (dp)
    );

endmodule
