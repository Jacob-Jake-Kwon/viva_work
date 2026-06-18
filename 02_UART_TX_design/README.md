# UART TX Design

Basys3 UART transmitter project. Pressing `btnC` queues ASCII characters into a TX FIFO and sends them to the PC through `RsTx`.

## Target Board

- Digilent Basys3
- Clock: 100 MHz
- Send button: `btnC`
- Reset button: `btnU`
- UART transmit: `RsTx`
- Status LEDs: `led[15:0]`

## Main Blocks

- `button_debounce_pulse`: debounces button input and generates a one-clock pulse
- `uart_tx_fifo`: 16-byte transmit FIFO
- `uart_tx_sender`: reads FIFO entries and starts transmission
- `uart_tx_fsm`: UART 8N1 serial transmitter
- `uart_tx_core`: combined FIFO + sender + TX FSM
- `basys3_uart_tx_buffer_top`: board-level top module

## Files

| Path | Description |
| --- | --- |
| `rtl/uart_tx/*.v` | UART TX reusable core modules. |
| `rtl/top/basys3_uart_tx_buffer_top.v` | Basys3 top module. |
| `constraints/basys3_uart_tx_buffer_top.xdc` | Clock, button, UART TX, and LED constraints. |

## UART Settings

Default parameters use 100 MHz clock and 9600 baud.
