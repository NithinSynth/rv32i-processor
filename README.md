# RISC-V RV32I Processor

Academic project: **Design and Implementation of RISC-V RV32I Processor**  
Academic year: 2026–2027

## Overview
This repository contains Verilog HDL source files, module-level and integration testbenches, Quartus project descriptors, sample instruction-memory files, and selected Quartus report files from the supplied project archive.

The source archive contains fetch, decode, execute, control, ALU, register-file, memory, branch, forwarding, and pipeline-related modules. Review the top-level integration and module interfaces before treating this snapshot as a reproducible complete processor build.

## Repository layout
- `RTL/` — Verilog HDL design modules.
- `Testbenches/` — Verilog testbenches.
- `Quartus/` — Quartus project descriptors and selected reports.
- `Simulation/Program/` — sample instruction-memory images.

## Tools
- Intel Quartus Prime Lite 20.1.1 (project files indicate this version)
- ModelSim Intel FPGA Edition / ModelSim-Altera
- Verilog HDL

## Getting started
1. Install a compatible Intel Quartus Prime version and ModelSim.
2. Open the `.qpf` project in `Quartus/`.
3. Check the project revision, top-level entity, source-file paths, device selection, and pin assignments. The supplied `.qsf` references files in its original folder layout, so paths may need to be updated after cloning this reorganized repository.
4. Compile and resolve any source/interface errors.
5. Run the relevant testbench in ModelSim. Add the exact compile/run commands and verified results here after re-testing this repository snapshot.

## Verification status
The uploaded archive includes many testbench files and selected historical reports. Their presence alone does not establish that every test passes or that the integrated design is fully verified. Re-run simulations from a clean checkout and record the results.

The supplied Quartus report set is for the revision named `Program_counter`; do not interpret that report as proof that every processor module or the complete integrated CPU has been successfully implemented, timing-closed, or demonstrated on an FPGA board.

## Notes
- Generated Quartus folders (`db/`, `incremental_db/`) and ModelSim work/wave databases are intentionally excluded; they can be regenerated locally.
- Backup files (`*.bak`) and local ModelSim configuration files are excluded.
- Add screenshots, board demonstration evidence, and the final project report only after checking that they are current and approved for public sharing.
- Review all files for personal information, credentials, license restrictions, and institutional requirements before making the repository public.

## Project team
Add or confirm the approved team-member names and institutional details before publishing.
