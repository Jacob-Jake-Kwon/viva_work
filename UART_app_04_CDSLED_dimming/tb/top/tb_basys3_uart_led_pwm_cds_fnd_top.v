`timescale 1ns / 1ps

// tb_basys3_uart_led_pwm_cds_fnd_top.v
//
// basys3_uart_led_pwm_cds_fnd_top.v의 테스트벤치이다.
//
// 검증 흐름:
// 1. UART로 CTRL = 0x03 Write
// 2. UART로 PWM_VALUE = 0x80 Write
// 3. JA[0] = 1이면 cds_is_light = 1, FND 상태 코드 L 확인
// 4. JA[0] = 0이면 cds_is_light = 0, FND 상태 코드 d 확인
// 5. UART로 CTRL = 0x00 Write 후 LED/FND OFF 확인

module tb_basys3_uart_led_pwm_cds_fnd_top;

    parameter CLK_FREQ = 100_000_000;
    parameter BAUD_RATE = 1_000_000;
    parameter CLK_PERIOD_NS = 10;
    parameter BIT_PERIOD_NS = 1_000_000_000 / BAUD_RATE;

    reg clk;
    reg btnU;
    reg RsRx;
    reg [0:0] JA;

    wire RsTx;
    wire [15:0] led;
    wire [6:0] seg;
    wire [3:0] an;
    wire dp;

    basys3_uart_led_pwm_cds_fnd_top #(
        .CLK_FREQ  (CLK_FREQ),
        .BAUD_RATE (BAUD_RATE)
    ) dut (
        .clk  (clk),
        .btnU (btnU),
        .RsRx (RsRx),
        .JA   (JA),
        .RsTx (RsTx),
        .led  (led),
        .seg  (seg),
        .an   (an),
        .dp   (dp)
    );

    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD_NS / 2) clk = ~clk;
    end

    task uart_send_byte;
        input [7:0] data;
        integer i;
        begin
            RsRx = 1'b1;
            #(BIT_PERIOD_NS);

            RsRx = 1'b0;
            #(BIT_PERIOD_NS);

            for (i = 0; i < 8; i = i + 1) begin
                RsRx = data[i];
                #(BIT_PERIOD_NS);
            end

            RsRx = 1'b1;
            #(BIT_PERIOD_NS);
        end
    endtask

    task uart_send_write_packet;
        input [7:0] addr;
        input [7:0] data;
        begin
            uart_send_byte(8'h01);
            uart_send_byte(addr);
            uart_send_byte(data);
        end
    endtask

    initial begin
        RsRx = 1'b1;
        JA   = 8'h00;
        btnU = 1'b1;
        #(CLK_PERIOD_NS * 20);

        btnU = 1'b0;
        #(BIT_PERIOD_NS * 5);

        uart_send_write_packet(8'h00, 8'h03);
        #(BIT_PERIOD_NS * 5);

        if (dut.u_simple_register_map.ctrl_reg !== 8'h03) begin
            $display("ERROR: CTRL write failed. ctrl_reg=%h", dut.u_simple_register_map.ctrl_reg);
            $finish;
        end

        uart_send_write_packet(8'h01, 8'h80);
        #(BIT_PERIOD_NS * 5);

        if (dut.u_simple_register_map.pwm_value_reg !== 8'h80) begin
            $display("ERROR: PWM_VALUE write failed. pwm_value_reg=%h", dut.u_simple_register_map.pwm_value_reg);
            $finish;
        end

        // 밝음 입력이다.
        // 외부 회로에서 밝음이면 JA[0] = 1로 맞춘다.
        JA[0] = 1'b1;
        #(CLK_PERIOD_NS * 10);

        if (dut.cds_is_light !== 1'b1) begin
            $display("ERROR: CdS light state failed. cds_is_light=%b", dut.cds_is_light);
            $finish;
        end

        if (dut.fnd_status_code !== 4'hA) begin
            $display("ERROR: FND L status failed. fnd_status_code=%h", dut.fnd_status_code);
            $finish;
        end

        // 어두움 입력이다.
        // 외부 회로에서 어두우면 JA[0] = 0으로 맞춘다.
        JA[0] = 1'b0;
        #(CLK_PERIOD_NS * 10);

        if (dut.cds_is_light !== 1'b0) begin
            $display("ERROR: CdS dark state failed. cds_is_light=%b", dut.cds_is_light);
            $finish;
        end

        if (dut.fnd_status_code !== 4'hB) begin
            $display("ERROR: FND d status failed. fnd_status_code=%h", dut.fnd_status_code);
            $finish;
        end

        uart_send_write_packet(8'h00, 8'h00);
        #(BIT_PERIOD_NS * 5);

        if (led !== 16'h0000) begin
            $display("ERROR: LED off failed. led=%h", led);
            $finish;
        end

        $display("PASS: UART LED PWM + CdS FND light status test completed.");
        $finish;
    end

endmodule
