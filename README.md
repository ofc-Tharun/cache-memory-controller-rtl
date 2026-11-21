# Cache Memory Controller – RTL Design

## Overview
An educational direct-mapped cache controller implemented in Verilog HDL.

## Features
- Parameterized address and data widths
- Direct-mapped cache organization
- Read and write operations
- Cache hit and miss detection
- Valid-bit and tag comparison
- Basic Verilog testbench

## Default Configuration
- Address width: 8 bits
- Data width: 8 bits
- Index width: 2 bits
- Cache lines: 4
- Tag width: 6 bits

## Files
- `cache_controller.v` – cache controller RTL
- `cache_tb.v` – simulation testbench

## Simulation
You can simulate using Icarus Verilog:

```bash
iverilog -o cache_sim cache_controller.v cache_tb.v
vvp cache_sim
```

## Limitations
This is a learning project. It models cache storage and hit/miss behavior,
but does not include a backing main-memory model, refill/wait states,
write-back policy, or a complete CPU interface.

## Author
Logajanani
