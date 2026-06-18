# UART RX Continuous String

UART receiver project that collects incoming bytes into a line buffer and reports receive status on Basys3 LEDs. It extends the one-character UART RX design with BRAM-style line buffering.

## Target Board

- Digilent Basys3
- UART RX input: `RsRx`
- UART TX idle output: `RsTx`
- Status display: `led[15:0]`
- Reset: `btnU`

## Main Blocks

- `uart_rx_core`: synchronized UART byte receiver with FIFO
- `rx_bram_line_buffer`: stores incoming bytes until newline/carriage return
- `basys3_uart_bram_line_rx_top`: board-level top module

## Files

| Path | Description |
| --- | --- |
| `rtl/uart_rx/*.v` | UART synchronization, receive FSM, FIFO, and core. |
| `rtl/rx_bram_line_buffer.v` | Line buffer and overflow/discard state logic. |
| `rtl/top/basys3_uart_bram_line_rx_top.v` | Basys3 top module. |
| `constraints/basys3_uart_bram_line_rx_top.xdc` | Clock, reset, UART, and LED pin constraints. |

## UART Settings

Use 9600 baud, 8 data bits, no parity, 1 stop bit.
