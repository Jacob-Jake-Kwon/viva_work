# UART Application 01 - Test Core

Hardware test project for checking the combined UART core on Basys3. It receives bytes from `RsRx`, forwards them into the transmitter, and exposes status on LEDs.

## Purpose

Use this folder to verify that the shared UART RX/TX core works before building higher-level UART applications.

## Main Blocks

- `uart_core`: combined RX/TX wrapper
- `uart_core_loopback_test_top`: board-level test wrapper
- UART RX and TX submodules reused from the core design

## Files

| Path | Description |
| --- | --- |
| `rtl/uart_core/uart_core.v` | Combined UART core. |
| `rtl/uart_rx/*.v` | UART RX modules. |
| `rtl/uart_tx/*.v` | UART TX modules. |
| `rtl/top/uart_core_loopback_test_top.v` | Basys3 top module for core testing. |
| `constraints/uart_core_loopback_test_top.xdc` | Board constraints. |

## UART Settings

Use 9600 baud, 8 data bits, no parity, 1 stop bit.
