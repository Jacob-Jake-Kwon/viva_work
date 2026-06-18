# Stopwatch RTL IP

Four-digit stopwatch logic prepared as reusable RTL blocks for Vivado IP packaging. The design counts hundredths of a second and drives a multiplexed 4-digit seven-segment display.

## Main Blocks

- `stopwatch_core`: top-level stopwatch counter IP
- `clock_divider_10ms`: generates a 0.01 second tick from the 100 MHz clock
- `start_stop_control`: stores running/stopped state
- `stopwatch_counter_4digit`: BCD digit counter
- `fnd_display_4digit`: 4-digit seven-segment display driver

## Files

| Path | Description |
| --- | --- |
| `rtl/stopwatch_core/*.v` | Stopwatch timing, control, and BCD counting logic. |
| `rtl/fnd_display_4digit/*.v` | Seven-segment scan, mux, decimal point, and BCD decode logic. |
| `constraints/basys3_stopwatch.xdc` | Basys3 clock, buttons, switch, LED, and FND constraints. |

## Vivado Notes

Package `rtl/stopwatch_core` and `rtl/fnd_display_4digit` as separate RTL IP blocks, then connect them in IP Integrator or instantiate them directly in a top-level wrapper.
