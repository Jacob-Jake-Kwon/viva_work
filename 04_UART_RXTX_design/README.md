# UART RX/TX Design

Combined UART receive/transmit design for Basys3. The project includes reusable RX and TX cores plus a board-level top module that echoes received data through the transmitter.

## Main Blocks

- `uart_rx_core`: UART receiver with FIFO
- `uart_tx_core`: UART transmitter with FIFO
- `uart_core`: shared wrapper combining RX and TX
- `basys3_uart_rx_tx_top`: Basys3 top-level loopback/echo design

## Files

| Path | Description |
| --- | --- |
| `rtl/uart_rx/*.v` | UART RX modules. |
| `rtl/uart_tx/*.v` | UART TX modules. |
| `rtl/uart_core/uart_core.v` | Combined UART wrapper. |
| `rtl/top/basys3_uart_rx_tx_top.v` | Board-level top module. |
| `constraints/basys3_uart_rx_tx_top.xdc` | Basys3 UART, LED, clock, and reset constraints. |

## UART Settings

Default parameters use 100 MHz clock and 9600 baud.
