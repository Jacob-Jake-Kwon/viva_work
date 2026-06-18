`timescale 1ns / 1ps

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
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) dut (
        .clk(clk),
        .btnU(btnU),
        .RsRx(RsRx),
        .JA(JA),
        .RsTx(RsTx),
        .led(led),
        .seg(seg),
        .an(an),
        .dp(dp)
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
        JA = 1'b0;
        btnU = 1'b1;

        #(CLK_PERIOD_NS * 20);
        btnU = 1'b0;
        #(BIT_PERIOD_NS * 5);

        uart_send_write_packet(8'h00, 8'h02);
        #(BIT_PERIOD_NS * 5);
        if (dut.u_simple_register_map.ctrl_reg !== 8'h02) begin
            $display("ERROR: CTRL 0x02 write failed. ctrl_reg=%h", dut.u_simple_register_map.ctrl_reg);
            $finish;
        end

        JA[0] = 1'b1;
        #(CLK_PERIOD_NS * 10);
        if (dut.cds_is_light !== 1'b1 || dut.fnd_status_code !== 4'hA) begin
            $display("ERROR: CdS light/FND L failed.");
            $finish;
        end

        JA[0] = 1'b0;
        #(CLK_PERIOD_NS * 10);
        if (dut.cds_is_light !== 1'b0 || dut.fnd_status_code !== 4'hB) begin
            $display("ERROR: CdS dark/FND d failed.");
            $finish;
        end

        uart_send_write_packet(8'h01, 8'h80);
        #(BIT_PERIOD_NS * 5);
        if (dut.u_simple_register_map.pwm_value_reg !== 8'h80) begin
            $display("ERROR: PWM_VALUE 0x80 write failed. pwm_value=%h", dut.u_simple_register_map.pwm_value_reg);
            $finish;
        end

        uart_send_write_packet(8'h00, 8'h03);
        #(BIT_PERIOD_NS * 20);
        if (dut.u_simple_register_map.ctrl_reg !== 8'h03) begin
            $display("ERROR: CTRL 0x03 write failed. ctrl_reg=%h", dut.u_simple_register_map.ctrl_reg);
            $finish;
        end

        uart_send_write_packet(8'h00, 8'h00);
        #(BIT_PERIOD_NS * 5);
        if (dut.u_simple_register_map.ctrl_reg !== 8'h00) begin
            $display("ERROR: CTRL 0x00 write failed. ctrl_reg=%h", dut.u_simple_register_map.ctrl_reg);
            $finish;
        end

        $display("PASS: basys3_uart_led_pwm_cds_fnd_top");
        $finish;
    end
endmodule
