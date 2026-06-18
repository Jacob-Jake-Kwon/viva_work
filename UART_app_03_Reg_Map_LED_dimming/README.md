# UART Application 03 - Register Map LED Dimming

UART-controlled LED PWM dimming project for Basys3. The design receives register address/data pairs through UART and uses them to control PWM brightness on the 16 LEDs.

## Register Map

| Address | Register | Description |
| --- | --- | --- |
| `0x00` | `ctrl_reg` | Control bits. Bit 0 enables PWM output. |
| `0x01` | `duty_reg` | PWM duty value, 0 to 255. |

## Main Blocks

- `uart_reg_write_controller`: receives address/data byte pairs
- `simple_register_map`: stores control and duty registers
- `led_pwm_controller`: drives LED PWM output
- `basys3_uart_led_pwm_min_top`: board-level top module

## Files

| Path | Description |
| --- | --- |
| `rtl/controllers/*.v` | Register write, register map, and PWM controller logic. |
| `rtl/top/basys3_uart_led_pwm_min_top.v` | Basys3 top module. |
| `rtl/uart_core`, `rtl/uart_rx`, `rtl/uart_tx` | Reusable UART core files. |
| `constraints/basys3_uart_led_pwm_min_top.xdc` | Basys3 clock, UART, reset, and LED constraints. |

## Usage

Send two UART bytes per command: first the register address, then the register value.
