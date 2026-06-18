# UART Application 02 - Echo

UART echo application for Basys3. Bytes received from the PC are read from the RX FIFO and written back to the TX path.

## Main Blocks

- `uart_echo_controller`: moves received bytes into the transmit path
- `uart_core`: combined UART RX/TX wrapper
- `basys3_uart_echo_top`: board-level echo top module

## Files

| Path | Description |
| --- | --- |
| `rtl/controllers/uart_echo_controller.v` | Echo control FSM/logic. |
| `rtl/top/basys3_uart_echo_top.v` | Basys3 top module. |
| `rtl/uart_core/uart_core.v` | Combined UART wrapper. |
| `rtl/uart_rx/*.v` | UART RX modules. |
| `rtl/uart_tx/*.v` | UART TX modules. |
| `constraints/basys3_uart_echo_top.xdc` | Basys3 UART and LED constraints. |

## Test Idea

Open a serial terminal at 9600 baud and type characters. Each character should be transmitted back by the FPGA.
