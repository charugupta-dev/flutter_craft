# Thought Orb

An AI cognitive status mark inspired by Apple Intelligence and [SwiftPieces](https://swiftpieces.com/docs/components/ai/thought-orb), portraying an autonomous agent's active cognitive state (such as thinking, searching, reading, writing, or reasoning).

Instead of flat spinners or vertical liquid levels, `ThoughtOrb` faithfully replicates Apple's **Siri Wave** optical mechanics with 4 equatorial sinusoidal membranes, Gaussian beam taper envelopes, crisp white crest lines, smoked obsidian glass core, specular highlights, and a luminous dual-tone rim.

Accompanied by `ThoughtOrbPill`, a frosted glass pill containing the orb, status text, and four sequential animated pulsing dots.

---

## Features

- **Zero External Dependencies:** 100% self-contained single-file component (`thought_orb.dart`). Zero external packages, no `.metal` or SPIR-V shader files required. Built purely with Flutter's `CustomPainter`, `Canvas`, and `dart:math`.
- **Exact Siri Wave Optics:** Faithful port of the Apple Siri Wave kernel:
  - 4 equatorial sinusoidal membranes traveling horizontally through $y = 0$.
  - Taper envelope $(1 - x^2)^{1.75}$ strictly pinching the waves to zero at the spherical rim.
  - Needle-thin crisp white crest line on the primary harmonic wave.
  - Frequency detuning ($0.05$) and harmonic amplitude modulation across ribbons.
- **Smoked Obsidian Glass Core:** Deep glass interior (`#1E0B19` $\to$ `#090208`) with `BlendMode.screen` additive glow ensuring bright, radiant contrast on both warm off-white (`#EEEAE3`) and OLED dark (`#0F0F12`) canvases.
- **Built-in Palettes:**
  - `ThoughtOrbPalette.solar` (Default: Solar Amber & Coral Rose in harmony with `BreathingLoader`)
  - `ThoughtOrbPalette.siri` (Apple Intelligence: Cyan, Indigo, Magenta, Violet)
  - `ThoughtOrbPalette.ocean` (Azure, Teal, Blue, Cobalt)
  - `ThoughtOrbPalette.emerald` (Mint, Emerald, Lime, Forest)
- **Status Pill Control (`ThoughtOrbPill`):** Frosted glass container with responsive tap interaction, 3 dynamic loading dots, and automatic state cycling across multiple labels.
- **Accessibility & Reduced Motion:** Automatically detects `MediaQuery.disableAnimationsOf(context)` and scales down speed to a calm, subtle oscillation.

---

## Usage

Simply copy `thought_orb.dart` into your project and use it directly:

```dart
import 'thought_orb.dart';

// 1. Hero Standalone Orb
ThoughtOrb(
  size: 160,
  palette: ThoughtOrbPalette.solar,
  speed: 1.0,
);

// 2. Frosted Glass Status Pill with Cycling States
ThoughtOrbPill(
  labels: const [
    'Thinking',
    'Searching',
    'Searching sources',
    'Drafting a reply',
  ],
  orbSize: 22,
  palette: ThoughtOrbPalette.solar,
);

// 3. Static Status Pill
ThoughtOrbPill(
  label: 'Thinking',
  orbSize: 22,
  palette: ThoughtOrbPalette.solar,
  onTap: () => print('Pill tapped'),
);

// 4. Custom Color Palette
ThoughtOrb(
  size: 64,
  palette: ThoughtOrbPalette(
    bands: [
      Color(0xFF38BDF8),
      Color(0xFF818CF8),
      Color(0xFFC084FC),
      Color(0xFFE879F9),
    ],
    ground: Color(0xFF0F172A),
    crest: Colors.white,
    rimWarm: Color(0xFF38BDF8),
    rimCool: Color(0xFFC084FC),
  ),
);
```

---

## Parameters

### ThoughtOrb

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `size` | `double` | `28.0` | Diameter of the orb in points (e.g. 22–28 inside a pill, 64–160 at hero size). |
| `palette` | `ThoughtOrbPalette` | `ThoughtOrbPalette.solar` | Color scheme for wave bands, ground core, crest, and rim. |
| `speed` | `double` | `1.0` | Animation speed multiplier (1.0 = ~4.0s cycle). |
| `animate` | `bool` | `true` | Whether the wave animation is actively running. |

### ThoughtOrbPill

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `label` | `String?` | `null` | Single static status label text (e.g. "Thinking"). |
| `labels` | `List<String>?` | `null` | List of status labels to cycle through automatically with smooth animated transitions. |
| `cycleInterval` | `Duration` | `2400ms` | Duration spent on each label before transitioning to the next. |
| `orbSize` | `double` | `22.0` | Diameter of the embedded `ThoughtOrb`. |
| `palette` | `ThoughtOrbPalette` | `ThoughtOrbPalette.solar` | Palette passed to the embedded orb. |
| `onTap` | `VoidCallback?` | `null` | Optional tap callback. |
| `showDots` | `bool` | `true` | Whether to display the 3 animated loading dots. |
| `labelStyle` | `TextStyle?` | `null` | Optional custom text style for the status label. |

### ThoughtOrbPalette

| Property | Type | Description |
| :--- | :--- | :--- |
| `bands` | `List<Color>` | Exactly 4 harmonic wave membrane ribbon colors. |
| `ground` | `Color` | Center background color of the smoked obsidian glass core. |
| `crest` | `Color` | High-intensity white ridge line tracing the primary wave. |
| `rimWarm` | `Color` | Warm gradient start color for the outer glass rim. |
| `rimCool` | `Color` | Cool gradient end color for the outer glass rim. |
