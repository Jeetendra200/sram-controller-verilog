# SRAM Controller Design and Verification

## Project Overview

This project implements an SRAM Controller using Verilog HDL.

Supported Operations:

- Write
- Read
- Clear
- Repeat Copy
- PEC Verification
- Command Verification
- Internal Target Abort Detection

---

## Directory Structure

```
sram-controller-verilog
│
├── rtl
│   └── sram_controller.v
│
├── tb
│   └── tb_sram_controller.v
│
├── docs
│   └── waveform.png
│
└── README.md
```

---

## Features

### Write Command (00)

Stores data at a specified address.

### Read Command (01)

Reads data from memory.

### Clear Command (10)

Clears the memory location.

### Repeat Copy Command (11)

Copies data into multiple consecutive addresses.

### Error Detection

- Data Error
- Command Error
- Internal Target Abort

---

## Simulation

Compile:

```bash
iverilog -o sim rtl/sram_controller.v tb/tb_sram_controller.v
```

Run:

```bash
vvp sim
```

Open waveform:

```bash
waveform.vcd
```

---

## Results

Waveform demonstrating:

- Write Operation
- Read Operation
- Clear Operation
- Repeat Copy Operation
- Error Detection

![Waveform](docs/waveform.png)

---

## Author

Jeetendra M

M.Tech VLSI Design

Manipal Institute of Technology, Bengaluru
