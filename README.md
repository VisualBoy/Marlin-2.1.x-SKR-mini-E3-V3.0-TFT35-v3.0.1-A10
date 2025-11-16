# Upgrading Geeetech A10 GT2560 V4 to BTT SKR Mini E3 V3 — Guide

This guide documents verified wiring, safety precautions, and Marlin configuration notes for migrating a Geeetech A10 (GT2560 V4.0) to a BigTreeTech SKR Mini E3 V3. It assumes you have the stock 18‑pin (2×9) "EXTRUDER" cable and have verified the connector pin labels before cutting or re‑terminating. Follow safety warnings exactly.

---

## Quick Checklist
- **Remove** the external heated‑bed MOSFET module and connect bed wires directly to the SKR heated‑bed screw terminal.  
- **Do not reuse** the old DC MOSFET for mains PS‑ON; use a proper AC relay.  
- **Isolate** four BLTouch‑related wires in the 18‑pin harness (if you do not have a BLTouch).  
- **Cut and re‑terminate** the 18‑pin cable according to the mapping table.  
- **Transfer hardware settings** from the A10 configuration into Marlin for SKR.

---

## 1. Power and Peripherals

### External MOSFET Module
- The SKR Mini E3 V3 has an onboard heated‑bed MOSFET sized for direct bed connection. You may remove the external DC MOSFET module and connect the bed + and – directly to the SKR **DC Heated Bed screw terminal**.
- **Warning**: Do **NOT** reuse the external DC MOSFET module for switching AC mains (PS‑ON). That module is for low‑voltage DC only and will create a fire/electrocution hazard. Use a rated AC relay or proper mains switching device for PS‑ON.

### Endstops
- Geeetech endstops are 3‑wire (VCC, GND, SIG); the SKR expects 2‑wire (GND, SIG).
- You can plug the 3‑pin plug into the SKR 2‑pin endstop header so GND and SIG align; the VCC pin will remain unconnected.
- Preferred: de‑pin and remove the VCC wire and individually insulate it so it cannot short.

---

## 2. BTT TFT35 Display
- **Marlin Mode (12864 emulation)**: connect display EXP1 and EXP2 ribbons to SKR EXP1/EXP2.  
- **Touchscreen Mode**: connect the 5‑pin RS232 cable to the SKR **TFT** port.  
- You can wire both and switch modes on the TFT by long‑pressing the encoder.

---

## 3. Extruder Harness Re‑termination (verified)
Cut the 18‑pin (2×9) harness and re‑terminate groups to the SKR board connectors. The table below maps each function, the verified 18‑pin location, wire color(s), and the SKR destination.

| **Function** | **18‑Pin Location & Label** | **Wire Color** | **SKR Mini E3 V3 Port** |
|---|---:|---|---|
| Hotend Heater | Row 9 Right HE0; Row 8 Left VDC | Thick RED; Thick BLACK | Hot End Heater (screw terminal) |
| Hotend Thermistor | Row 5 Left T0; Row 5 Right T0 | Thin BLACK; Thin WHITE | T0 (JST‑XH 2‑pin) |
| Hotend Fan FAN0 | +: Row 8 Right VDC; –: Row 1 Left FAN0- | +: ORANGE; –: GREEN | FAN0 (JST‑XH 2‑pin) |
| Part Cooling Fan | +: Row 8 Right VDC (split); –: Row 6 Left PGND1 & Row 6 Right PGND1 (join) | +: ORANGE (split); –: YELLOW + VIOLET (joined) | Part Cooling Fan (JST‑XH 2‑pin) |

---

## 4. Critical Live Wires to Isolate (no BLTouch)
You indicated you do **not** have a BLTouch. Four wires in the 18‑pin harness will be live at 5 V on the SKR when powered. These must be cut and individually insulated. Failure to isolate them will short the board and can destroy the SKR.

- Pin (2, Left) PB5 — Gray — isolate individually  
- Pin (2, Right) Z0- — Blue — isolate individually  
- Pin (3, Left) VCC — Yellow (thin) — isolate individually  
- Pin (4, Left) GND — Brown — isolate individually

After isolation, connect a standard mechanical Z endstop to the SKR **Z‑STOP** port.

---

## 5. Firmware (Marlin) Essentials

```cpp
// Motherboard
#define MOTHERBOARD BOARD_BTT_SKR_MINI_E3_V3_0

// Stepper driver types
#define X_DRIVER_TYPE  TMC2209
#define Y_DRIVER_TYPE  TMC2209
#define Z_DRIVER_TYPE  TMC2209
#define E0_DRIVER_TYPE TMC2209

// Thermistors (use values from your old A10 config)
#define TEMP_SENSOR_0 1
#define TEMP_SENSOR_BED 1

// Endstop logic
#define X_MIN_ENDSTOP_INVERTING false
#define Y_MIN_ENDSTOP_INVERTING false
#define Z_MIN_ENDSTOP_INVERTING false
```

---

## 6. 18‑Pin Connector Mapping (verified)

| **Row** | **Side** | **Label** | **Color** | **Status** |
|---:|---:|---|---|---:|
| 1 | Left | FAN0- | Green | Connected |
| 1 | Right | FAN1- | (empty) | Not populated |
| 2 | Left | PB5 | Gray | Connected |
| 2 | Right | Z0- | Blue | Connected |
| 3 | Left | VCC | Yellow | Connected |
| 3 | Right | T1 | (empty) | Not populated |
| 4 | Left | GND | Brown | Connected |
| 4 | Right | T1 | (empty) | Not populated |
| 5 | Left | T0 | Black | Connected |
| 5 | Right | T0 | White | Connected |
| 6 | Left | PGND1 | Yellow | Connected |
| 6 | Right | PGND1 | Purple | Connected |
| 7 | Left | VDC | (empty) | Not populated |
| 7 | Right | PGND1 | (empty) | Not populated |
| 8 | Left | VDC | Red | Connected |
| 8 | Right | VDC | Orange | Connected |
| 9 | Left | HE1 | (empty) | Not populated |
| 9 | Right | HE0 | Black | Connected |

---

## KiCad ASCII Wiring Diagram

```text
┌───────────────────────────────────────────────────────────────────────┐
│   GEEETECH A10 – 18-PIN EXTRUDER CONNECTOR (2×9)                     │
│                                                                       │
│   ROW 9   [HE1] White        [HE0] Black                              │
│   ROW 8   [VDC] Red          [VDC] Orange → +24V FAN/HEATER          │
│   ROW 7   [VDC] Grey         [PGND1] White                            │
│   ROW 6   [PGND1] Yellow     [PGND1] Purple                           │
│   ROW 5   [T0] Black         [T0] White                               │
│   ROW 4   [GND] Brown        [T1] White                               │
│   ROW 3   [VCC] Yellow       [T1] White                               │
│   ROW 2   [PB5] Grey         [Z0-] Blue                               │
│   ROW 1   [FAN0-] Green      [FAN1-] White                            │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘

             ↓  Re-terminated wires
─────────────────────────────────────────────────────────────────────────────

                        ┌───────────────────────────────┐
                        │   SKR MINI E3 V3 – INPUTS     │
                        └───────────────────────────────┘


════════════════════════ HOTEND HEATER (HE0) ════════════════════════

18-PIN:
    • HE0 → Black (Row 9 Right)
    • VDC → Red (Row 8 Left)

SKR:
    ┌──────────────────────────┐
    │  HE0 SCREW TERMINAL      │
    │  +  → RED                │
    │  –  → BLACK              │
    └──────────────────────────┘


════════════════════════ HOTEND THERMISTOR (T0) ═════════════════════

18-PIN:
    • T0 Left  → Black  (Row 5 Left)
    • T0 Right → White  (Row 5 Right)

SKR:
    ┌──────────────────────────┐
    │  T0 (JST-XH 2-PIN)       │
    │  SIG/GND → Black/White   │
    └──────────────────────────┘


════════════════════════ HOTEND FAN (FAN0) ══════════════════════════

18-PIN:
    • +VDC → Orange (Row 8 Right)
    • FAN0- → Green (Row 1 Left

════════════════════════ PART COOLING FAN ═══════════════════════════

18-PIN:
    • +VDC → Orange (Row 8 Right split)
    • GND  → YELLOW + VIOLET joined (Row 6 L/R PGND1)

SKR:
    ┌──────────────────────────┐
    │ PART COOLING FAN         │
    │  + → Orange (split)      │
    │  – → Yellow+Violet       │
    └──────────────────────────┘


════════════════════════ ENDSTOP (Z) ════════════════════════════════

**IMPORTANT:** You indicated *no BLTouch* → these four wires must be ISOLATED:

    • PB5  (Gray)  
    • Z0-  (Blue)  
    • VCC  (Thin Yellow)  
    • GND  (Brown)  

SKR:
    ┌──────────────────────────┐
    │ MECHANICAL Z ENDSTOP     │
    │  SIG/GND → New cable     │
    └──────────────────────────┘


════════════════════════ TFT DISPLAY ════════════════════════════════

SKR:
    ┌──────────────┬───────────────┐
    │ EXP1 / EXP2  │ TFT (RS232)   │
    └──────────────┴───────────────┘
Toggle modes on TFT via encoder long-press.

───────────────────────────────────────────────────────────────────────────
```

---

# Marlin 3D Printer Firmware

![GitHub](https://img.shields.io/github/license/marlinfirmware/marlin.svg)
![GitHub contributors](https://img.shields.io/github/contributors/marlinfirmware/marlin.svg)
![GitHub Release Date](https://img.shields.io/github/release-date/marlinfirmware/marlin.svg)
[![Build Status](https://github.com/MarlinFirmware/Marlin/workflows/CI/badge.svg?branch=bugfix-2.0.x)](https://github.com/MarlinFirmware/Marlin/actions)

<img align="right" width=175 src="buildroot/share/pixmaps/logo/marlin-250.png" />

Additional documentation can be found at the [Marlin Home Page](https://marlinfw.org/).
Please test this firmware and let us know if it misbehaves in any way. Volunteers are standing by!

## Marlin 2.0 Bugfix Branch

__Not for production use. Use with caution!__

Marlin 2.0 takes this popular RepRap firmware to the next level by adding support for much faster 32-bit and ARM-based boards while improving support for 8-bit AVR boards. Read about Marlin's decision to use a "Hardware Abstraction Layer" below.

This branch is for patches to the latest 2.0.x release version. Periodically this branch will form the basis for the next minor 2.0.x release.

Download earlier versions of Marlin on the [Releases page](https://github.com/MarlinFirmware/Marlin/releases).

## Building Marlin 2.0

To build Marlin 2.0 you'll need [Arduino IDE 1.8.8 or newer](https://www.arduino.cc/en/main/software) or [PlatformIO](https://docs.platformio.org/en/latest/ide.html#platformio-ide). We've posted detailed instructions on [Building Marlin with Arduino](https://marlinfw.org/docs/basics/install_arduino.html) and [Building Marlin with PlatformIO for ReArm](https://marlinfw.org/docs/basics/install_rearm.html) (which applies well to other 32-bit boards).

## Hardware Abstraction Layer (HAL)

Marlin 2.0 introduces a layer of abstraction so that all the existing high-level code can be built for 32-bit platforms while still retaining full 8-bit AVR compatibility. Retaining AVR compatibility and a single code-base is important to us, because we want to make sure that features and patches get as much testing and attention as possible, and that all platforms always benefit from the latest improvements.

### Current HALs

  #### AVR (8-bit)

  board|processor|speed|flash|sram|logic|fpu
  ----|---------|-----|-----|----|-----|---
  [Arduino AVR](https://www.arduino.cc/)|ATmega, ATTiny, etc.|16-20MHz|64-256k|2-16k|5V|no

  #### DUE

  boards|processor|speed|flash|sram|logic|fpu
  ----|---------|-----|-----|----|-----|---
  [Arduino Due](https://www.arduino.cc/en/Guide/ArduinoDue), [RAMPS-FD](https://www.reprap.org/wiki/RAMPS-FD), etc.|[SAM3X8E ARM-Cortex M3](https://www.microchip.com/wwwproducts/en/ATsam3x8e)|84MHz|512k|64+32k|3.3V|no

  #### ESP32

  board|processor|speed|flash|sram|logic|fpu
  ----|---------|-----|-----|----|-----|---
  [ESP32](https://www.espressif.com/en/products/hardware/esp32/overview)|Tensilica Xtensa LX6|160-240MHz variants|---|---|3.3V|---

  #### LPC1768 / LPC1769

  boards|processor|speed|flash|sram|logic|fpu
  ----|---------|-----|-----|----|-----|---
  [Re-ARM](https://www.kickstarter.com/projects/1245051645/re-arm-for-ramps-simple-32-bit-upgrade)|[LPC1768 ARM-Cortex M3](https://www.nxp.com/products/microcontrollers-and-processors/arm-based-processors-and-mcus/lpc-cortex-m-mcus/lpc1700-cortex-m3/512kb-flash-64kb-sram-ethernet-usb-lqfp100-package:LPC1768FBD100)|100MHz|512k|32+16+16k|3.3-5V|no
  [MKS SBASE](https://reprap.org/forum/read.php?13,499322)|LPC1768 ARM-Cortex M3|100MHz|512k|32+16+16k|3.3-5V|no
  [Selena Compact](https://github.com/Ales2-k/Selena)|LPC1768 ARM-Cortex M3|100MHz|512k|32+16+16k|3.3-5V|no
  [Azteeg X5 GT](https://www.panucatt.com/azteeg_X5_GT_reprap_3d_printer_controller_p/ax5gt.htm)|LPC1769 ARM-Cortex M3|120MHz|512k|32+16+16k|3.3-5V|no
  [Smoothieboard](https://reprap.org/wiki/Smoothieboard)|LPC1769 ARM-Cortex M3|120MHz|512k|64k|3.3-5V|no

  #### SAMD51

  boards|processor|speed|flash|sram|logic|fpu
  ----|---------|-----|-----|----|-----|---
  [Adafruit Grand Central M4](https://www.adafruit.com/product/4064)|[SAMD51P20A ARM-Cortex M4](https://www.microchip.com/wwwproducts/en/ATSAMD51P20A)|120MHz|1M|256k|3.3V|yes

  #### STM32F1

  boards|processor|speed|flash|sram|logic|fpu
  ----|---------|-----|-----|----|-----|---
  [Arduino STM32](https://github.com/rogerclarkmelbourne/Arduino_STM32)|[STM32F1](https://www.st.com/en/microcontrollers-microprocessors/stm32f103.html) ARM-Cortex M3|72MHz|256-512k|48-64k|3.3V|no
  [Geeetech3D GTM32](https://github.com/Geeetech3D/Diagram/blob/master/Rostock301/Hardware_GTM32_PRO_VB.pdf)|[STM32F1](https://www.st.com/en/microcontrollers-microprocessors/stm32f103.html) ARM-Cortex M3|72MHz|256-512k|48-64k|3.3V|no

  #### STM32F4

  boards|processor|speed|flash|sram|logic|fpu
  ----|---------|-----|-----|----|-----|---
  [STEVAL-3DP001V1](https://www.st.com/en/evaluation-tools/steval-3dp001v1.html)|[STM32F401VE Arm-Cortex M4](https://www.st.com/en/microcontrollers-microprocessors/stm32f401ve.html)|84MHz|512k|64+32k|3.3-5V|yes

  #### Teensy++ 2.0

  boards|processor|speed|flash|sram|logic|fpu
  ----|---------|-----|-----|----|-----|---
  [Teensy++ 2.0](https://www.microchip.com/wwwproducts/en/AT90USB1286)|[AT90USB1286](https://www.microchip.com/wwwproducts/en/AT90USB1286)|16MHz|128k|8k|5V|no

  #### Teensy 3.1 / 3.2

  boards|processor|speed|flash|sram|logic|fpu
  ----|---------|-----|-----|----|-----|---
  [Teensy 3.2](https://www.pjrc.com/store/teensy32.html)|[MK20DX256VLH7](https://www.mouser.com/ProductDetail/NXP-Freescale/MK20DX256VLH7) ARM-Cortex M4|72MHz|256k|32k|3.3V-5V|yes

  #### Teensy 3.5 / 3.6

  boards|processor|speed|flash|sram|logic|fpu
  ----|---------|-----|-----|----|-----|---
  [Teensy 3.5](https://www.pjrc.com/store/teensy35.html)|[MK64FX512VMD12](https://www.mouser.com/ProductDetail/NXP-Freescale/MK64FX512VMD12) ARM-Cortex M4|120MHz|512k|192k|3.3-5V|yes
  [Teensy 3.6](https://www.pjrc.com/store/teensy36.html)|[MK66FX1M0VMD18](https://www.mouser.com/ProductDetail/NXP-Freescale/MK66FX1M0VMD18) ARM-Cortex M4|180MHz|1M|256k|3.3V|yes

  #### Teensy 4.0 / 4.1

  boards|processor|speed|flash|sram|logic|fpu
  ----|---------|-----|-----|----|-----|---
  [Teensy 4.0](https://www.pjrc.com/store/teensy40.html)|[IMXRT1062DVL6A](https://www.mouser.com/new/nxp-semiconductors/nxp-imx-rt1060-crossover-processor/) ARM-Cortex M7|600MHz|1M|2M|3.3V|yes
  [Teensy 4.1](https://www.pjrc.com/store/teensy41.html)|[IMXRT1062DVJ6A](https://www.mouser.com/new/nxp-semiconductors/nxp-imx-rt1060-crossover-processor/) ARM-Cortex M7|600MHz|1M|2M|3.3V|yes

## Submitting Patches

Proposed patches should be submitted as a Pull Request against the ([bugfix-2.0.x](https://github.com/MarlinFirmware/Marlin/tree/bugfix-2.0.x)) branch.

- This branch is for fixing bugs and integrating any new features for the duration of the Marlin 2.0.x life-cycle.
- Follow the [Coding Standards](https://marlinfw.org/docs/development/coding_standards.html) to gain points with the maintainers.
- Please submit Feature Requests and Bug Reports to the [Issue Queue](https://github.com/MarlinFirmware/Marlin/issues/new/choose). Support resources are also listed there.
- Whenever you add new features, be sure to add tests to `buildroot/tests` and then run your tests locally, if possible.
  - It's optional: Running all the tests on Windows might take a long time, and they will run anyway on GitHub.
  - If you're running the tests on Linux (or on WSL with the code on a Linux volume) the speed is much faster.
  - You can use `make tests-all-local` or `make tests-single-local TEST_TARGET=...`.
  - If you prefer Docker you can use `make tests-all-local-docker` or `make tests-all-local-docker TEST_TARGET=...`.

### [RepRap.org Wiki Page](https://reprap.org/wiki/Marlin)

## Credits

The current Marlin dev team consists of:

 - Scott Lahteine [[@thinkyhead](https://github.com/thinkyhead)] - USA &nbsp; [Donate](https://www.thinkyhead.com/donate-to-marlin) / Flattr: [![Flattr Scott](https://api.flattr.com/button/flattr-badge-small.png)](https://flattr.com/submit/auto?user_id=thinkyhead&url=https://github.com/MarlinFirmware/Marlin&title=Marlin&language=&tags=github&category=software)
 - Roxanne Neufeld [[@Roxy-3D](https://github.com/Roxy-3D)] - USA
 - Chris Pepper [[@p3p](https://github.com/p3p)] - UK
 - Bob Kuhn [[@Bob-the-Kuhn](https://github.com/Bob-the-Kuhn)] - USA
 - João Brazio [[@jbrazio](https://github.com/jbrazio)] - Portugal
 - Erik van der Zalm [[@ErikZalm](https://github.com/ErikZalm)] - Netherlands &nbsp; [![Flattr Erik](https://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=ErikZalm&url=https://github.com/MarlinFirmware/Marlin&title=Marlin&language=&tags=github&category=software)

## License

Marlin is published under the [GPL license](/LICENSE) because we believe in open development. The GPL comes with both rights and obligations. Whether you use Marlin firmware as the driver for your open or closed-source product, you must keep Marlin open, and you must provide your compatible Marlin source code to end users upon request. The most straightforward way to comply with the Marlin license is to make a fork of Marlin on Github, perform your modifications, and direct users to your modified fork.

While we can't prevent the use of this code in products (3D printers, CNC, etc.) that are closed source or crippled by a patent, we would prefer that you choose another firmware or, better yet, make your own.
