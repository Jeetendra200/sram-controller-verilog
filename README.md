# SRAM Controller Design and Verification

## Overview

This project implements an SRAM Controller using Verilog HDL. The controller supports memory write, read, clear, and repeat-copy operations along with error detection and command verification mechanisms.

The design was developed and verified using a custom Verilog testbench and waveform analysis.

---

## Features

### Write Operation (Command = 2'b00)

* Writes input data to the specified SRAM address.

### Read Operation (Command = 2'b01)

* Reads data from the specified SRAM address.

### Clear Operation (Command = 2'b10)

* Clears the contents of the specified memory location.

### Repeat Copy Operation (Command = 2'b11)

* Writes the same data into multiple consecutive memory locations.

### Error Detection

* Data Error Detection using PEC verification.
* Command Error Detection.
* Internal Target Abort detection for invalid X/Z inputs.

---

## SRAM Controller Architecture

```text
                +----------------------+
                |   SRAM Controller    |
                +----------------------+
                   |              |
                   |              |
            Command/Data      Status Flags
                   |
                   v
             +-----------+
             | SRAM Array|
             +-----------+
```

---

## Directory Structure

```text
sram-controller-verilog
│
├── rtl
│   └── sram_controller.v
│
├── testbench
│   └── tb_sram_controller.v
│
├── waveform
│   └── waveform.png
│
└── README.md
```

---

## Test Cases

| Test Case                       | Status |
| ------------------------------- | ------ |
| Write Operation                 | Pass   |
| Read Operation                  | Pass   |
| Clear Operation                 | Pass   |
| Repeat Copy Operation           | Pass   |
| PEC Verification                | Pass   |
| Command Verification            | Pass   |
| Internal Target Abort Detection | Pass   |

---

## Simulation Flow

Compile Design and Testbench:

```bash
iverilog -o sim rtl/sram_controller.v testbench/tb_sram_controller.v
```

Run Simulation:

```bash
vvp sim
```

Generate Waveform:

```bash
gtkwave waveform.vcd
```

---

## Skills Demonstrated

* Verilog HDL
* RTL Design
* Memory Controller Design
* Functional Verification
* Testbench Development
* Digital System Design
* Error Detection Logic
* Waveform Debugging

---

## Author

Jeetendra M

M.Tech VLSI Design

Manipal Institute of Technology, Bengaluru

GitHub: https://github.com/Jeetendra200

