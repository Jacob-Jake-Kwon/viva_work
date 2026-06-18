module stopwatch_core(
    input clk,
    input reset,
    input enable,
    input start_pulse,
    input stop_pulse,
    output running,
    output tick_0p01s,
    output [3:0] digit0,
    output [3:0] digit1,
    output [3:0] digit2,
    output [3:0] digit3
);
    wire count_enable;
    assign count_enable = enable & running & tick_0p01s;

    clock_divider_10ms u_tick(
        .clk(clk), .reset(reset), .enable(enable & running), .tick(tick_0p01s)
    );
    start_stop_control u_control(
        .clk(clk), .reset(reset), .start(start_pulse), .stop(stop_pulse), .running(running)
    );
    stopwatch_counter_4digit u_counter(
        .clk(clk), .reset(reset), .enable(count_enable),
        .digit0(digit0), .digit1(digit1), .digit2(digit2), .digit3(digit3)
    );
endmodule
