# Design and Implementation of RISC-V RV32I Processor

<p align="center">
  <strong>32-bit RISC-V Processor | Verilog HDL | Five-Stage Pipeline</strong>
</p>

## 1. Project Overview

This project focuses on the design and implementation of a 32-bit RISC-V RV32I processor using Verilog HDL.

The processor follows a five-stage pipelined architecture to execute instructions through separate processing stages. The design includes instruction fetching, instruction decoding, execution, memory access and write-back.

The project uses Intel Quartus Prime Lite and ModelSim for FPGA development and RTL simulation.

## 2. Processor Architecture

The processor consists of five stages:

| Stage | Name | Function |
|---|---|---|
| IF | Instruction Fetch | Fetches instructions from instruction memory |
| ID | Instruction Decode | Decodes instructions and reads registers |
| EX | Execute | Performs ALU operations and branch calculations |
| MEM | Memory Access | Performs data memory read/write operations |
| WB | Write Back | Writes results into the register file |

## 3. Key Design Components

- Program Counter
- Instruction Memory
- Instruction Decoder
- Register File
- Immediate Generator
- Control Unit
- ALU and ALU Control
- Data Memory
- Pipeline Registers
- Forwarding Unit
- Branch Handling Logic

## 4. Pipeline Registers

The design uses four pipeline registers:

- IF/ID
- ID/EX
- EX/MEM
- MEM/WB

These registers transfer instruction data and control signals between consecutive pipeline stages.

## 5. Technologies and Tools

| Technology | Purpose |
|---|---|
| Verilog HDL | RTL design |
| Intel Quartus Prime Lite 20.1.1 | FPGA compilation |
| ModelSim Intel FPGA Edition 2020.1 | RTL simulation |
| DE10-Standard | FPGA target platform |

## 6. Repository Structure

```text
rv32i-processor/
│
├── RTL/
│   └── Verilog design modules
│
├── Testbenches/
│   └── Simulation testbenches
│
├── Quartus/
│   └── FPGA project and reports
│
├── Simulation/
│   └── Program memory files
│
├── README.md
└── .gitignore
```

*Note: Adjust this structure to match the actual folders in the repository.*

## 7. Simulation and Verification

The project includes individual module testbenches and processor-level simulation files.

Simulation is performed using ModelSim.

The initial simulation transcript records zero errors and two warnings. Instruction memory contents and test coverage should be checked when reproducing the simulation.

## 8. FPGA Implementation

The project includes a DE10-Standard FPGA top-level interface and Quartus project files.

The available Quartus fitter report records successful fitting for the reported design revision. Timing analysis also reports negative setup slack, so timing closure has not yet been demonstrated.

## 9. Future Improvements

- Complete verification of supported RV32I instructions.
- Improve hazard detection and forwarding.
- Verify branch and pipeline flush behaviour.
- Resolve timing violations.
- Perform complete FPGA hardware validation.
- Explore the RTL-to-GDSII implementation flow using Cadence tools.

## 10. Project Team

- Nithin Kumar M
- Parashuram R T
- Pavan V K
- Manje Gowda O Y

**Department:** Electronics and Communication Engineering  
**Institution:** Kalpataru Institute of Technology, Tiptur  
**Academic Year:** 2026–2027

## 11. Author

**Nithin Kumar M**

GitHub: https://github.com/NithinSynth

---

*Academic project developed as part of the Bachelor of Engineering programme in Electronics and Communication Engineering.*
