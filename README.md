# Viva Work - FPGA UART and Digital Logic Projects

This repository contains organized Verilog HDL and XDC constraint files extracted and cleaned from a set of digital logic, Vivado IP, FSM, UART, and Basys3 FPGA practice PDFs.

The projects are arranged as independent folders so each topic can be opened, studied, simulated, or imported into Vivado separately.

## Repository Contents

| Folder | Description |
| --- | --- |
| `01_1_FPGA_Vivado_IP_concept` | Concept notes for Vivado IP workflow and IP Integrator usage. |
| `01_2_Vivado_IP_LED_blink` | Vivado IP-based LED blink project with Basys3 constraints and testbench. |
| `01_3_Stopwatch_RTL_IP` | Stopwatch RTL IP blocks and 4-digit FND display support modules. |
| `02_1_FSM_design` | Basic Moore and Mealy FSM examples. |
| `02_2_FSM_design_2` | Additional FSM and sequence detector examples. |
| `03_1_UART_RX_one_char` | UART receiver for one-character receive on Basys3. |
| `02_UART_RX_continuous_string` | UART receiver with line/string buffering and LED status output. |
| `02_UART_TX_design` | UART transmitter with button debounce, FIFO, sender, and TX FSM. |
| `04_UART_RXTX_design` | Combined UART RX/TX core and Basys3 echo-style top module. |
| `UART_app_01_Test_Core` | UART core loopback/test project. |
| `UART_app_02_ECHO` | UART echo application. |
| `UART_app_03_Reg_Map_LED_dimming` | UART register-map controlled LED PWM dimming project. |
| `UART_app_04_CDSLED_dimming` | UART + CdS sensor + LED PWM + FND status display project. |
| `UART_app_04_CDS_theory` | CdS sensor theory notes for the final application. |

## File Organization

Most hardware project folders use this layout:

```text
project_folder/
  README.md
  rtl/
    top/
    controllers/
    uart_core/
    uart_rx/
    uart_tx/
  constraints/
    *.xdc
  tb/
    *.v
```

Not every folder has every subdirectory. Concept-only folders contain documentation only.

## Target Hardware

The board-level projects target the Digilent Basys3 FPGA board.

- FPGA part: `xc7a35tcpg236-1`
- System clock: 100 MHz
- Common UART setting: 9600 baud, 8 data bits, no parity, 1 stop bit
- Main board I/O used across projects:
  - `clk`
  - `btnU`
  - `btnC`
  - `RsRx`
  - `RsTx`
  - `led[15:0]`
  - seven-segment display pins for FND projects
  - `JA[0]` for CdS input in the final application

## How to Use in Vivado

1. Create a new Vivado RTL project.
2. Select the Basys3 board or the part `xc7a35tcpg236-1`.
3. Add the Verilog files from the target folder's `rtl/` directory as design sources.
4. Add files from `tb/` as simulation sources when a testbench is provided.
5. Add the matching `.xdc` file from the `constraints/` directory.
6. Set the board-level top module shown in the project folder README.
7. Run synthesis, implementation, bitstream generation, and program the Basys3 board.

## Notes About the Sources

- Source files were reconstructed from PDF material and corrected where obvious PDF extraction errors appeared.
- Examples are intended for learning and FPGA practice.
- Some folders intentionally contain no RTL because the original PDF section was conceptual or theoretical.
- Each project folder has its own `README.md` with more specific module and usage details.

## Recommended GitHub Cleanup

Before committing, ignore macOS metadata files:

```gitignore
.DS_Store
```

You can also remove existing `.DS_Store` files from the repository folder before the first commit.

## License

No license has been selected yet. Add a license before publishing if other people should be allowed to reuse, modify, or distribute the code.
