# UART Application 04 - CdS LED Dimming

UART-controlled LED PWM dimming project with CdS sensor input and seven-segment status display. The design combines UART register writes, PWM LED output, CdS input filtering, and FND status display.

## Target Board

- Digilent Basys3
- CdS digital input on `JA[0]`
- UART input/output through `RsRx` and `RsTx`
- PWM LED output on `led[15:0]`
- Four-digit FND output through `seg`, `an`, and `dp`

## Register Write Packet Format

The UART command is a 3-byte raw binary packet, not an ASCII string parser.

| Byte | Meaning | Value |
| --- | --- | --- |
| 1 | Command | `0x01` for register write |
| 2 | Register address | `0x00` for CTRL, `0x01` for PWM value |
| 3 | Register data | Value to store |

Examples:

| Raw bytes to send | Result |
| --- | --- |
| `01 00 00` | `CTRL = 0x00`: LED off, FND shows `----` |
| `01 00 01` | `CTRL = 0x01`: LED PWM on, FND shows `----` |
| `01 00 02` | `CTRL = 0x02`: LED off, FND shows `L---` or `d---` |
| `01 00 03` | `CTRL = 0x03`: LED PWM on, FND shows `L---` or `d---` |
| `01 01 80` | `PWM_VALUE = 0x80`: about 50 percent LED brightness |

If a serial terminal sends the text `010003`, the FPGA receives ASCII bytes `0x30 0x31 0x30 0x30 0x30 0x33`, which is not the PDF protocol. Use a serial tool that can send raw hex bytes.

## Register Map

| Address | Register | Description |
| --- | --- | --- |
| `0x00` | `ctrl_reg` | Bit 0 enables LED PWM. Bit 1 enables CdS FND status display. |
| `0x01` | `pwm_value_reg` | PWM duty value, 0 to 255. |

## Expected Board Behavior

- `CTRL[0]` controls LED PWM only.
- `CTRL[1]` controls FND CdS status display only.
- `JA[0] = 1` means bright/light and displays `L---` when `CTRL[1] = 1`.
- `JA[0] = 0` means dark and displays `d---` when `CTRL[1] = 1`.
- The CdS input does not gate the LED PWM. LED PWM depends on `CTRL[0]` and `pwm_value_reg`.

## Main Blocks

- `uart_reg_write_controller`: accepts 3-byte UART register write packets
- `simple_register_map`: stores `ctrl_reg` and `pwm_value_reg`
- `led_pwm_controller`: drives all 16 LEDs with the same 8-bit PWM duty
- `cds_input_filter`: synchronizes CdS input from `JA[0]`
- `fnd_status_3digit_display`: displays `L---`, `d---`, or `----`
- `basys3_uart_led_pwm_cds_fnd_top`: board-level top module

## Files

| Path | Description |
| --- | --- |
| `rtl/controllers/*.v` | Application controllers, register map, PWM, CdS, and FND logic. |
| `rtl/top/basys3_uart_led_pwm_cds_fnd_top.v` | Basys3 top module. |
| `rtl/uart_core`, `rtl/uart_rx`, `rtl/uart_tx` | Reusable UART core files. |
| `constraints/basys3_uart_led_pwm_cds_fnd_top.xdc` | Basys3 clock, UART, CdS, LED, and FND constraints. |
| `tb/top/tb_basys3_uart_led_pwm_cds_fnd_top.v` | Simulation testbench using actual UART RX serial waveform. |

## Vivado Setup

Set the design top module to `basys3_uart_led_pwm_cds_fnd_top`.

For simulation, set the simulation top module to `tb_basys3_uart_led_pwm_cds_fnd_top`.
