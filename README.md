

# Upgrading Geeetech A10 GT2560 V4 to BTT SKR Mini E3 V3 — Guide

This guide documents verified wiring, safety precautions, and Marlin configuration notes for migrating a Geeetech A10 (GT2560 V4.0) to a BigTreeTech SKR Mini E3 V3. It assumes the stock 18-pin (2×9) EXTRUDER cable is present and that the pin labels have been verified before cutting or re-terminating. Follow all safety guidance precisely.


---

Summary Checklist

Remove any external heated-bed MOSFET and connect the bed directly to the SKR heated-bed screw terminal.

Do not reuse the old DC MOSFET as a mains PS-ON device—use a proper AC relay.

Isolate four BLTouch-related wires in the 18-pin harness (will carry 5 V when powered).

Cut and re-terminate the 18-pin cable to the SKR ports listed below.

Use the provided Marlin configuration snippet and migrate the rest of the A10 configuration accordingly.



---

1. Power and Peripherals

External MOSFET Module

The SKR Mini E3 V3 includes an onboard heated-bed MOSFET suitable for direct bed wiring. Remove the external DC MOSFET module and connect the bed +/− to the SKR heated-bed screw terminal.

> Warning:
Do not use the external DC MOSFET module to switch AC mains (PS-ON). It is designed only for low-voltage DC and will pose a fire/electrocution risk. Use a rated AC relay or proper mains switching system.



Endstops

Geeetech endstops use 3 wires (VCC, GND, SIG); the SKR expects 2 wires (GND, SIG).

You may plug the Geeetech 3-pin connector into the SKR 2-pin header ensuring GND and SIG align. VCC will remain unconnected.

Preferred: remove the VCC wire from the connector and insulate it individually to prevent shorts.



---

2. BTT TFT35 Display Connections

Marlin Mode (12864 emulation): connect EXP1 and EXP2 ribbons to SKR EXP1/EXP2.

Touchscreen Mode: connect the 5-pin RS232 cable to the SKR TFT port.


Both modes can be connected simultaneously; switch modes via long-press on the TFT encoder.


---

3. Extruder Harness Re-Termination (Verified)

Cut the 18-pin harness and re-terminate groups to the corresponding SKR connectors.
Verified mapping:

Function	18-Pin Location & Label	Wire Color	SKR Mini E3 V3 Port

Hotend Heater	Row 9 Right HE0; Row 8 Left VDC	Thick RED; Thick BLACK	Hotend Heater (screw terminal)
Hotend Thermistor	Row 5 Left T0; Row 5 Right T0	Thin BLACK; Thin WHITE	T0 (JST-XH 2-pin)
Hotend Fan (FAN0)	+: Row 8 Right VDC; −: Row 1 Left FAN0-	+ ORANGE; − GREEN	FAN0 (JST-XH 2-pin)
Part-Cooling Fan	+: Row 8 Right VDC (split); −: Row 6 Left/Right PGND1 (join)	+ ORANGE (split); − YELLOW + VIOLET (joined)	Part-Cooling Fan (JST-XH 2-pin)


Notes

When splitting or joining wires, ensure mechanically solid joints, correct polarity, and proper insulation (heat-shrink, strain relief).

Incorrect fan polarity may damage the fan.



---

4. Critical Live Wires to Isolate (No BLTouch)

Without a BLTouch installed, four wires in the 18-pin harness carry 5 V when the SKR is powered. These must be individually cut and insulated.

18-Pin	Label	Color	Action

Pin 2 Left	PB5	Gray	Isolate individually
Pin 2 Right	Z0-	Blue	Isolate individually
Pin 3 Left	VCC	Thin Yellow	Isolate individually
Pin 4 Left	GND	Brown	Isolate individually


After isolating these wires, connect a standard mechanical Z endstop to the SKR Z-STOP header.


---

5. Firmware (Marlin) Essentials

Port all relevant hardware configuration details from the original A10 build into the SKR Marlin firmware.

Minimal required entries:

// Motherboard
#define MOTHERBOARD BOARD_BTT_SKR_MINI_E3_V3_0

// Stepper driver types
#define X_DRIVER_TYPE  TMC2209
#define Y_DRIVER_TYPE  TMC2209
#define Z_DRIVER_TYPE  TMC2209
#define E0_DRIVER_TYPE TMC2209

// Thermistors (match original A10 config)
#define TEMP_SENSOR_0    1
#define TEMP_SENSOR_BED  1

// Endstop logic
#define X_MIN_ENDSTOP_INVERTING false
#define Y_MIN_ENDSTOP_INVERTING false
#define Z_MIN_ENDSTOP_INVERTING false

To-Do:

[ ] Port steps/mm, accelerations, PID values, probe offsets, motor currents, and precise sensor types.

[ ] Verify TMC2209 UART wiring and enable UART mode in Marlin if using sensorless homing or driver diagnostics.



---

6. 18-Pin Connector — Full Schema & Reference

Verified 2×9 EXTRUDER connector mapping:

Row	Left Pin	Left Color	Left Icon	Right Pin	Right Color	Right Icon

1	FAN0-	Green	Fan	FAN1-	White	Fan
2	PB5	Grey	GPIO	Z0-	Blue	Sensor
3	VCC	Yellow	Power	T1	White	Timer
4	GND	Brown	Ground	T1	White	Timer
5	T0	Black	Timer	T0	White	Timer
6	PGND1	Yellow	Power GND	PGND1	Purple	Power GND
7	VDC	Grey	Power	PGND1	White	Timer (?)
8	VDC	Red	Heater	VDC	Orange	Heater
9	HE1	White	Heater	HE0	Black	Heater



---

Final Safety & Verification Steps

Confirm pin identities before cutting any wires.

Before connecting mains, power the SKR from the PSU and verify that only expected 5 V lines are live.

Validate heater and thermistor continuity/resistance before enabling heaters in firmware.

Begin with conservative motor-current and PID values; run PID autotune on the hotend.

Use proper strain relief, insulation, and cable management.



---


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
