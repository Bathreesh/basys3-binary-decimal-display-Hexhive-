



# Basys 3 — Binary to Decimal 7-Segment Display

A Verilog project for the **Digilent Basys 3 FPGA** (Artix-7) that reads a 13-bit binary value from switches **SW0–SW12** and displays the decimal equivalent (**0–8191**) on the onboard 4-digit 7-segment display in real time.

---

## Demo

> Toggle any combination of SW0–SW12 and the 7-segment display instantly updates to show the decimal value.

---

## What It Does

| Input | Output |
|---|---|
| 13 switches (SW0–SW12) | 4-digit decimal on 7-segment display |
| Binary range: 0000000000000 – 1111111111111 | Decimal range: 0000 – 8191 |

---

## How It Works

### Problem
You cannot feed binary directly into a 7-segment display and get decimal — the display needs BCD (Binary Coded Decimal).

### Solution — Double Dabble Algorithm
The design uses the **Double Dabble (Shift-and-Add-3)** algorithm to convert 13-bit binary into four separate BCD digits — no division, pure combinational logic.

### Display — Time Division Multiplexing
All 4 digits share the same 7 segment lines. A ~1 kHz clock cycles through each digit rapidly enough that all four appear lit simultaneously to the human eye.

```
SW0–SW12  (13-bit binary)
       │
       ▼
 ┌─────────────┐
 │  bin_to_bcd │   Double Dabble
 └──────┬──────┘
        │  Thousands / Hundreds / Tens / Ones
        ▼
 ┌──────────────────┐
 │  seg7_controller │   Multiplexed driver
 └────────┬─────────┘
          │  an[3:0]  seg[6:0]
          ▼
   4-digit 7-segment display
```

---

## File Structure

```
basys3-binary-decimal-display/
├── src/
│   ├── top.v               Top-level module
│   ├── bin_to_bcd.v        13-bit binary → BCD (Double Dabble)
│   ├── clock_divider.v     100 MHz → ~1 kHz refresh clock
│   └── seg7_controller.v   4-digit 7-seg multiplexer + decoder
├── constraints/
│   └── basys3.xdc          Basys 3 pin assignments
└── README.md
```

---

## Module Overview

| Module | Function |
|---|---|
| `top.v` | Instantiates and wires all submodules |
| `bin_to_bcd.v` | Converts 13-bit binary to 4 BCD digits using Double Dabble |
| `clock_divider.v` | Divides 100 MHz clock to ~1 kHz for flicker-free display |
| `seg7_controller.v` | Multiplexes 4 digits, decodes BCD to 7-segment pattern |

---

## Pin Assignments

| Signal | FPGA Pin | Description |
|---|---|---|
| `clk` | W5 | 100 MHz system clock |
| `sw[0]` | V17 | LSB switch |
| `sw[12]` | W2 | MSB switch used |
| `seg[0]–seg[6]` | W7 → U7 | Segments (active LOW) |
| `an[0]–an[3]` | U2 → W4 | Anodes (active LOW) |

Full pin assignments → `constraints/basys3.xdc`

---

## Switch-to-Display Examples

| Switches ON | Binary | Display |
|---|---|---|
| None | 0000000000000 | 0000 |
| SW0 only | 0000000000001 | 0001 |
| SW1 only | 0000000000010 | 0002 |
| SW3 + SW1 | 0000000001010 | 0010 |
| SW9 only | 0001000000000 | 0512 |
| SW12 only | 1000000000000 | 4096 |
| All SW0–SW12 | 1111111111111 | 8191 |

---

## How to Run (Vivado)

1. Open Vivado → New Project → Part: `xc7a35tcpg236-1`
2. Add all `.v` files from `src/`
3. Add `constraints/basys3.xdc`
4. Right-click `top.v` → **Set as Top**
5. Run Synthesis → Run Implementation → Generate Bitstream
6. Open Hardware Manager → Auto Connect → Program Device
7. Flip switches and watch the display update

---

## Concepts Covered

- Double Dabble binary-to-BCD conversion
- Time-division multiplexing for 7-segment displays
- Synchronous clock division
- Modular Verilog design
- Basys 3 XDC constraint files

---

## Tools

- Vivado Design Suite (Xilinx/AMD)
- Verilog HDL
- Digilent Basys 3 — Artix-7 (`xc7a35tcpg236-1`)
---

## License

This project is open source under the [Hexhive](LICENSE).

