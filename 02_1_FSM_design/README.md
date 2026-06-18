# FSM Design

Basic finite-state-machine examples for button and serial-pattern behavior. These modules are useful as small reference designs before building UART control logic.

## Modules

| Module | Description |
| --- | --- |
| `moore_button_3press_fsm` | Moore FSM that turns an output on after three button pulses. |
| `mealy_serial_frame_fsm` | Mealy FSM for detecting a short serial input pattern. |

## Files

| Path | Description |
| --- | --- |
| `rtl/moore_button_3press_fsm.v` | Button pulse counting FSM. |
| `rtl/mealy_serial_frame_fsm.v` | Serial frame/pattern detection FSM. |

## Notes

These examples are simulation-oriented and do not require an XDC file unless they are wrapped by a board-level top module.
