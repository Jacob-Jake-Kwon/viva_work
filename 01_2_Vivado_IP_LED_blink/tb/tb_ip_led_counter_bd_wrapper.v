`timescale 1ns / 1ps
module tb_ip_led_counter_bd_wrapper;
    reg clk;
    wire led;
    ip_led_counter_bd_wrapper dut(.clk(clk), .led(led));
    initial clk = 1'b0;
    always #5 clk = ~clk;
    initial begin
        #2000000;
        $finish;
    end
endmodule
