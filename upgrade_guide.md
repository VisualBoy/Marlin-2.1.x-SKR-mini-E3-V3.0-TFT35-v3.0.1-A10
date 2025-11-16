# Upgrading Geeetech A10 (GT2560 V4) → BTT SKR Mini E3 V3
Status: Verified Wiring & Configuration  
Target hardware: Geeetech A10 (stock 18‑pin harness) → BTT SKR Mini E3 V3  
Objective: Replace the GT2560 V4.0 mainboard with the SKR Mini E3 V3 without swapping the main extruder harness.

---

## Summary
This guide documents the required pin mappings, safety isolations, and recommended Marlin settings to migrate from the GT2560 V4.0 to the BTT SKR Mini E3 V3 while keeping the stock 18‑pin extruder harness.

Read the safety warnings and verify every wire with a multimeter before cutting, crimping, or connecting.

---

## Critical Safety Warnings

### DANGER — High voltage hazard
Do NOT reuse the Geeetech external DC MOSFET module to switch AC mains (PS‑ON). That module is designed for low‑voltage DC only. Connecting AC mains to it may cause electrocution, fire, or irreversible damage.

### WARNING — Board short risk (BLTouch-related pins)
If you are NOT using a BLTouch, isolate the following wires in the 18‑pin harness. These pins (PB5, Z0‑, VCC, GND) provide voltage or ground paths that can short to the frame or other connectors, causing damage or a fire risk.

Action: Cut these wires short and insulate each individually with heat shrink or high‑quality electrical tape.

---

## Tools & Parts checklist
- Multimeter (for continuity testing)
- Wire cutters / strippers
- Crimping tool and ferrules or soldering iron + heat shrink
- JST‑XH 2‑pin housings (if re‑terminating)
- Heat shrink or electrical tape
- Optional: small mechanical switch for Z‑stop if isolating BLTouch pins

---

## 1) Power & Peripherals

### Heated bed
- The SKR Mini E3 V3 includes a robust onboard bed MOSFET; the external Geeetech MOSFET is not required.
  - Remove the external heated‑bed MOSFET module.
  - Connect the bed heater wires directly to the SKR HB screw terminal.
  - Connect the bed thermistor to the SKR THB port.

### Endstops
- Geeetech uses 3‑wire endstops (VCC, GND, SIG); SKR uses 2‑wire (GND, SIG).
  - Plug the 3‑pin connector into the SKR 2‑pin header aligning GND and SIG; the VCC pin will overhang and remain unconnected.
  - Best practice: depin and insulate the VCC wire completely to avoid accidental shorts.

### Display (BTT TFT35)
- Marlin Mode (12864 emulation): connect EXP1 and EXP2 ribbons.
- Touchscreen Mode: connect the 5‑pin RS232 cable to the TFT header.
- You may wire both and switch modes by long‑pressing the encoder.

---

## 2) Extruder Harness re‑termination
The A10 uses a 2×9 (18‑pin) connector. You must cut the connector and re‑crimp or splice wires into groups for the SKR.

Note: Colors below reflect the stock harness. Always verify continuity with a multimeter before cutting.

Wiring table (mapping from stock harness → SKR Mini E3 V3):
| Function | 18‑Pin Location (Label) | Wire Color(s) | SKR Mini E3 V3 Destination | Connector / Notes |
|---|---:|---|---|---|
| Hotend heater (+ / -) | Row 8 Left (VDC) / Row 9 Right (HE0) | Thick RED / Thick BLACK | HE0 screw terminal | Use ferrules or bare wire to screw terminal |
| Hotend thermistor | Row 5 Left / Row 5 Right (T0) | Thin BLACK / Thin WHITE | TH0 port | JST‑XH 2‑pin |
| Hotend fan (always on) | Row 8 Right (VDC) / Row 1 Left (FAN0-) | (+) ORANGE / (-) GREEN | FAN0 (fan header) | JST‑XH 2‑pin |
| Part cooling fan | Row 8 Right (VDC) split + Row 6 L/R (PGND1) | (+) ORANGE split / (-) YELLOW + VIOLET | FAN1 (fan header) | JST‑XH 2‑pin |

Wiring diagram (Mermaid)
```mermaid
graph LR
    subgraph Harness["Geeetech 18‑Pin Harness"]
        HE_P[Red Black (HE0/VDC)]
        TH_P[Black White (T0)]
        HF_P[Orange Green (VDC/FAN0-)]
        PC_P[Orange Yell+Purp (VDC/PGND1)]
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
```

Quick wiring checklist
- [ ] Verify each harness wire with multimeter.
- [ ] Cut and re‑terminate heater wires to HE0 terminal (use ferrules).
- [ ] Re‑terminate thermistor to TH0 JST connector.
- [ ] Connect fans to FAN0 and FAN1 as required.
- [ ] Insulate any unused/overhanging pins.

---

## 3) Critical wire isolation (If NOT using BLTouch)
If you are not using a BLTouch, the following wires must be isolated — they connect to pins used by the extruder PCB and can be live or ground paths.

| Pin location | Label | Color | Required action |
|---|---:|---|---|
| Row 2 Left | PB5 | Gray | Cut short & insulate (ISOLATE) |
| Row 2 Right | Z0- | Blue | Cut short & insulate (ISOLATE) |
| Row 3 Left | VCC | Thin Yellow | Cut short & insulate (ISOLATE) |
| Row 4 Left | GND | Brown | Cut short & insulate (ISOLATE) |

Note: If you plan to use a BLTouch, follow BLTouch wiring and configuration procedures instead of isolating these pins.

Replace the BLTouch wiring with a standard mechanical switch in the SKR Z‑STOP port if you isolate BLTouch pins.

---

## 4) Marlin firmware configuration
Below are the baseline settings used when this migration was verified. Adjust as required for your specific printer and test with M119, heater/thermistor readings, and stepper movement.

Configuration.h (excerpt)
```c
// --- Configuration.h ---

// Motherboard
#define MOTHERBOARD BOARD_BTT_SKR_MINI_E3_V3_0

// Serial ports (TFT35 commonly uses Serial2)
#define SERIAL_PORT 1
#define SERIAL_PORT_2 2
#define BAUDRATE 115200

// Stepper driver types (onboard TMC2209)
#define X_DRIVER_TYPE  TMC2209
#define Y_DRIVER_TYPE  TMC2209
#define Z_DRIVER_TYPE  TMC2209
#define E0_DRIVER_TYPE TMC2209

// Thermistors (stock A10 sensors verified)
#define TEMP_SENSOR_0 1
#define TEMP_SENSOR_BED 1

// Endstop logic (verify with M119)
#define X_MIN_ENDSTOP_INVERTING false
#define Y_MIN_ENDSTOP_INVERTING false
#define Z_MIN_ENDSTOP_INVERTING false

// Motor directions — toggle if axes move the wrong way
#define INVERT_X_DIR true
#define INVERT_Y_DIR true
#define INVERT_Z_DIR false
#define INVERT_E0_DIR true
```

Notes
- Always validate endstop behavior using M119 before enabling homing routines.
- Verify thermistor readings at room temperature and after heating.
- If you have different heaters/thermistors, set TEMP_SENSOR_* accordingly.

---

## Appendix — Full 18‑Pin connector map
<details>
<summary><strong>Click to expand full pinout table</strong></summary>

| Row | Side | Label | Color | Status |
|---:|---|---|---|---|
| 1 | Left | FAN0- | Green | Used (Hotend Fan -) |
| 1 | Right | FAN1- | (empty) | N/C |
| 2 | Left | PB5 | Gray | Isolate (BLT) |
| 2 | Right | Z0- | Blue | Isolate (BLT) |
| 3 | Left | VCC | Thin Yellow | Isolate (BLT) |
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

---

