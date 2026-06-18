# UART RX One Character

Basys3 UART receiver project for receiving one byte at a time. The last received byte and receiver status signals are displayed on LEDs.

## Target Board

- Digilent Basys3
- UART RX input: `RsRx`
- UART TX held idle: `RsTx`
- Reset: `btnU`
- LED output: `led[15:0]`

## Main Blocks

- `uart_rx_sync`: synchronizes asynchronous UART input
- `uart_rx_fsm`: samples UART 8N1 frames
- `uart_rx_fifo`: stores received bytes
- `uart_rx_core`: combines RX sync, FSM, and FIFO
- `basys3_uart_rx_top`: board-level top module

## Files

| Path | Description |
| --- | --- |
| `rtl/uart_rx/*.v` | Reusable UART RX core modules. |
| `rtl/top/basys3_uart_rx_top.v` | Basys3 top module for one-character receive. |
| `constraints/basys3_uart_rx_top.xdc` | Basys3 clock, reset, UART, and LED constraints. |

## UART Settings

Use 9600 baud, 8 data bits, no parity, 1 stop bit.
