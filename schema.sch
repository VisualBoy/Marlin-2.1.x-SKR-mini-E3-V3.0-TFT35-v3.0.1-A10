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
    • FAN0- → Green (Row 1 Left)

SKR:
    ┌──────────────────────────┐
    │  FAN0 (JST-XH 2-PIN)     │
    │  +  → Orange             │
    │  –  → Green              │
    └──────────────────────────┘


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
    │ EXP1 / EXP2  │ TFT (RS232)    │
    └──────────────┴───────────────┘
Toggle modes on TFT via encoder long-press.

───────────────────────────────────────────────────────────────────────────