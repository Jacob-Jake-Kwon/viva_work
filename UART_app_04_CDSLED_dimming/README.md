# UART Application 04 - CdS LED Dimming

UART-controlled LED PWM dimming project with CdS sensor input and seven-segment status display. The design combines UART register writes, PWM LED output, CdS input filtering, and FND status display.

## Target Board

- Digilent Basys3
- CdS digital input on `JA[0]`
- UART input/output through `RsRx` and `RsTx`
- PWM LED output on `led[15:0]`
- Four-digit FND output through `seg`, `an`, and `dp`

## Register Map

| Address | Register | Description |
| --- | --- | --- |
| `0x00` | `ctrl_reg` | Bit 0 enables PWM. Bit 1 enables FND status display. |
| `0x01` | `duty_reg` | PWM duty value, 0 to 255. |

## Main Blocks

- `cds_input_filter`: synchronizes CdS input
- `uart_reg_write_controller`: accepts UART register writes
- `simple_register_map`: stores control/duty registers
- `led_pwm_controller`: drives PWM LEDs
- `fnd_status_3digit_display`: displays CdS/duty status on FND
- `basys3_uart_led_pwm_cds_fnd_top`: board-level top module

## Files

| Path | Description |
| --- | --- |
| `rtl/controllers/*.v` | Application controllers, register map, PWM, CdS, and FND logic. |
| `rtl/top/basys3_uart_led_pwm_cds_fnd_top.v` | Basys3 top module. |
| `rtl/uart_core`, `rtl/uart_rx`, `rtl/uart_tx` | Reusable UART core files. |
| `constraints/basys3_uart_led_pwm_cds_fnd_top.xdc` | Basys3 clock, UART, CdS, LED, and FND constraints. |

## Usage

Send register address/data byte pairs through UART. Enable PWM with `ctrl_reg[0]`, enable FND status with `ctrl_reg[1]`, and set brightness through `duty_reg`.
