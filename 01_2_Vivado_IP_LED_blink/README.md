# Vivado IP LED Blink

Basys3 LED blink practice using Vivado-generated IP and an HDL wrapper. The hardware design is built mainly in Vivado IP Integrator, while this folder stores the board constraint file and a simple simulation testbench.

## Target Board

- Digilent Basys3
- FPGA part: `xc7a35tcpg236-1`
- Clock: 100 MHz system clock on `W5`
- Output: LED0 on `U16`

## Files

| Path | Description |
| --- | --- |
| `constraints/basys3_ip_led_counter.xdc` | Basys3 clock and LED0 pin constraints. |
| `tb/tb_ip_led_counter_bd_wrapper.v` | Basic testbench for the Vivado-generated `ip_led_counter_bd_wrapper` module. |

## Vivado Notes

Create the block design and HDL wrapper in Vivado first. The testbench expects the generated top module to be named `ip_led_counter_bd_wrapper` with ports `clk` and `led`.
