Upgrading Geeetech A10 (GT2560 V4) to BTT SKR Mini E3 V3
> Status: Verified Wiring & Configuration
> Target Hardware: Geeetech A10 (Stock 18-pin harness), BTT SKR Mini E3 V3
> Objective: Mainboard migration without replacing the main extruder wire harness.
> 
This guide documents the specific pin mappings, safety isolations, and firmware settings required to replace the stock GT2560 V4.0 board with an SKR Mini E3 V3.
⚠️ Critical Safety Warnings
> [!DANGER]
> HIGH VOLTAGE HAZARD > Do NOT reuse the Geeetech external DC MOSFET module for switching AC mains (PS-ON). That module is designed for low-voltage DC only. Connecting AC mains to it will create a direct fire and electrocution hazard. Use a proper solid-state relay (SSR) or rated AC relay for PS-ON control.
> 
> [!WARNING]
> BOARD SHORT RISK (BLTouch Isolation) > If you are not using a BLTouch, you must isolate specific wires in the 18-pin harness. Four wires (PB5, Z0-, VCC, GND) carry voltage or ground paths that can short the SKR board if left floating and touching metal. See Section 4.
> 
1. Power & Peripherals
Heated Bed
The SKR Mini E3 V3 has a powerful onboard MOSFET for the bed. The external Geeetech MOSFET is unnecessary for the bed heater itself.
 * Remove the external heated-bed MOSFET module.
 * Connect the Bed Heater wires directly to the SKR HB screw terminal.
 * Connect the Bed Thermistor to the THB port.
Endstops
Geeetech uses 3-wire endstops (VCC, GND, SIG), while SKR uses 2-wire (GND, SIG).
 * Solution: Plug the Geeetech 3-pin connector into the SKR 2-pin header such that GND and SIG align. The VCC pin will overhang and remain unconnected.
 * Best Practice: Depin and insulate the VCC wire entirely to prevent accidental shorts.
Display (BTT TFT35)
 * Marlin Mode (12864 Emulation): Connect EXP1 and EXP2 ribbon cables.
 * Touchscreen Mode: Connect the 5-pin RS232 cable to the TFT header.
 * Usage: You can wire both. Switch modes by long-pressing the encoder wheel.
2. Extruder Harness Re-termination
The stock A10 uses a specific 2x9 (18-pin) connector. You must cut this connector and re-crimp (or splice) the wires into groups for the SKR board.
> [!NOTE]
> Colors listed below are from the stock harness. Always verify pin continuity with a multimeter before cutting.
> 
Wiring Table
| Function | 18-Pin Location (Label) | Wire Color(s) | SKR Mini E3 V3 Destination | Connector Type |
|---|---|---|---|---|
| Hotend Heater | Row 9 Right (HE0)
Row 8 Left (VDC) | Thick RED
Thick BLACK | HE0 Screw Terminal | Ferrule / Bare Wire |
| Hotend Thermistor | Row 5 Left (T0)
Row 5 Right (T0) | Thin BLACK
Thin WHITE | TH0 | JST-XH (2-pin) |
| Hotend Fan (Always On) | Row 8 Right (VDC)
Row 1 Left (FAN0-) | (+) ORANGE
(-) GREEN | FAN0 | JST-XH (2-pin) |
| Part Cooling Fan | Row 8 Right (VDC) Split
Row 6 L/R (PGND1) Join | (+) ORANGE Split
(-) YELLOW + VIOLET | FAN1 | JST-XH (2-pin) |
Wiring Diagram (Mermaid)
graph LR
    subgraph Harness["Geeetech 18-Pin Harness"]
        HE_P[Red/Black (HE0/VDC)]
        TH_P[Black/White (T0)]
        HF_P[Orange/Green (VDC/FAN0-)]
        PC_P[Orange/Yell+Purp (VDC/PGND1)]
    end

    subgraph SKR["SKR Mini E3 V3"]
        HE_TERM[HE0 Terminal]
        TH_PORT[TH0 Port]
        FAN0_PORT[FAN0 Port]
        FAN1_PORT[FAN1 Port]
    end

    HE_P -->|Heater Power| HE_TERM
    TH_P -->|Temp Sense| TH_PORT
    HF_P -->|Hotend Cooling| FAN0_PORT
    PC_P -->|Part Cooling| FAN1_PORT

3. Critical Wire Isolation (No BLTouch)
If you are NOT using a BLTouch, the following wires from the 18-pin harness are dangerous. They connect to pins on the extruder PCB that are not in use, but if they touch the frame or other components, they can short the mainboard.
Action: Cut these wires short and insulate them individually with heat shrink or electrical tape.
| Pin Location | Label | Color | Action |
|---|---|---|---|
| Row 2 Left | PB5 | Gray | ISOLATE |
| Row 2 Right | Z0- | Blue | ISOLATE |
| Row 3 Left | VCC | Yellow (Thin) | ISOLATE |
| Row 4 Left | GND | Brown | ISOLATE |
Use a standard mechanical switch plugged into the SKR Z-STOP port for your Z-homing.
4. Marlin Firmware Configuration
In Configuration.h and Configuration_adv.h, ensure the following settings are applied to match the hardware changes.
// --- Configuration.h ---

// Motherboard Definition
#define MOTHERBOARD BOARD_BTT_SKR_MINI_E3_V3_0

// Serial Port Settings (TFT35 uses Serial 2 usually)
#define SERIAL_PORT 1
#define SERIAL_PORT_2 2
#define BAUDRATE 115200

// Stepper Drivers (SKR Mini E3 V3 has integrated TMC2209)
#define X_DRIVER_TYPE  TMC2209
#define Y_DRIVER_TYPE  TMC2209
#define Z_DRIVER_TYPE  TMC2209
#define E0_DRIVER_TYPE TMC2209

// Thermistors (Verified for stock A10 sensors)
#define TEMP_SENSOR_0 1
#define TEMP_SENSOR_BED 1

// Endstop Inverting (Adjust based on `M119` testing)
// Stock switches are usually N/O, but check your wiring logic.
#define X_MIN_ENDSTOP_INVERTING false
#define Y_MIN_ENDSTOP_INVERTING false
#define Z_MIN_ENDSTOP_INVERTING false

// Direction Settings (If motors run backwards, toggle these)
#define INVERT_X_DIR true 
#define INVERT_Y_DIR true
#define INVERT_Z_DIR false
#define INVERT_E0_DIR true

Appendix: Full 18-Pin Connector Map
For troubleshooting purposes, here is the complete pinout of the stock Geeetech connector.
<details>
<summary><strong>Click to expand pinout table</strong></summary>
| Row | Side | Label | Color | Status |
|---|---|---|---|---|
| 1 | Left | FAN0- | Green | Used (Hotend Fan -) |
| 1 | Right | FAN1- | (empty) | N/C |
| 2 | Left | PB5 | Gray | Isolate (BLT) |
| 2 | Right | Z0- | Blue | Isolate (BLT) |
| 3 | Left | VCC | Yellow | Isolate (BLT) |
| 3 | Right | T1 | (empty) | N/C |
| 4 | Left | GND | Brown | Isolate (BLT) |
| 4 | Right | T1 | (empty) | N/C |
| 5 | Left | T0 | Black | Used (Thermistor) |
| 5 | Right | T0 | White | Used (Thermistor) |
| 6 | Left | PGND1 | Yellow | Used (Part Fan -) |
| 6 | Right | PGND1 | Purple | Used (Part Fan -) |
| 7 | Left | VDC | (empty) | N/C |
| 7 | Right | PGND1 | (empty) | N/C |
| 8 | Left | VDC | Red | Used (Heater +) |
| 8 | Right | VDC | Orange | Used (Fans +) |
| 9 | Left | HE1 | (empty) | N/C |
| 9 | Right | HE0 | Black | Used (Heater -) |
</details>
