# ThoughtOrb & ThoughtOrbPill Component Design Specification

## 1. Overview & Purpose

`ThoughtOrb` is an AI status mark inspired by Apple Intelligence and [SwiftPieces ThoughtOrb](https://swiftpieces.com/docs/components/ai/thought-orb). It portrays an autonomous AI agent's active cognitive state (such as thinking, searching, reading, writing, or reasoning).

Instead of vertical fluid fills or flat spinners, `ThoughtOrb` faithfully replicates Apple's **Siri Wave** optical mechanics:
- Four thin sinusoidal ribbons traversing horizontally along the equator ($y = 0$).
- A Gaussian beam envelope $(1 - x^2)^{1.75}$ strictly tapering the wave amplitudes to zero at the spherical rim.
- A high-intensity crisp white crest line following the primary wave path.
- A smoked obsidian glass core (`#1E0B19` -> `#090208`) ensuring intense chromatic saturation and contrast on both light and dark backgrounds.
- Top-left specular curved reflection and a dual-tone luminous glass rim.

In addition to the standalone `ThoughtOrb`, this design includes `ThoughtOrbPill`, a frosted glass pill containing the orb, status text, and four sequential animated pulsing dots.

For `flutter_craft`, the component is engineered as a **100% self-contained single-file component** with **zero external dependencies** (no shader assets, no external packages), implemented entirely with Flutter's `CustomPainter`, `Canvas`, and math.

---

## 2. Visual Direction & Color Palettes

### 2.1 The Solar Amber & Coral Rose Palette (Default)
In harmony with `BreathingLoader`, the default palette uses the radiant Solar Amber & Coral Rose scheme:

| Band / Layer | Color Code | Visual Role |
| :--- | :--- | :--- |
| **Band 0** | `#FBBF24` (Golden Amber 400) | Primary top wave ribbon |
| **Band 1** | `#F97316` (Sunset Orange 500) | Mid-warm harmonic ribbon |
| **Band 2** | `#FB7185` (Coral Rose 400) | Vivid accent ribbon |
| **Band 3** | `#E11D48` (Deep Rose 600) | Deep harmonic ribbon |
| **White Crest** | `#FFFFFF` (80% opacity) | Needle-thin specular ridge |
| **Ground Core** | `#1E0B19` $\to$ `#090208` | Smoked obsidian glass interior |
| **Luminous Center**| `rgba(255, 250, 235, 0.40)` | Central volumetric core illumination |
| **Glass Rim** | `#FBBF24` $\to$ `#FB7185` | Dual-tone equatorial glass perimeter |
| **Glass Reflection**| `rgba(255, 255, 255, 0.65)` | Curved top-left specular lens sheen |

### 2.2 Palette Configuration (`ThoughtOrbPalette`)
Users can configure custom palettes or select built-in presets:
- `ThoughtOrbPalette.solar` (Default: Solar Amber & Coral Rose)
- `ThoughtOrbPalette.siri` (Classic Apple Intelligence: Cyan `#38BDF8`, Indigo `#6366F1`, Magenta `#EC4899`, Violet `#8B5CF6`)
- `ThoughtOrbPalette.ocean` (Deep Azure `#38BDF8`, Electric Teal `#14B8A6`, Cobalt `#3B82F6`, Deep Sea `#0284C7`)
- `ThoughtOrbPalette.emerald` (Mint `#34D399`, Emerald `#10B981`, Lime `#A3E635`, Forest `#059669`)

---

## 3. Mathematical Wave Model (Ported from ThoughtOrb.metal)

The wave animation faithfully implements the exact mathematics of Apple's `ThoughtOrb.metal` kernel:

### 3.1 Parameters
- `kBands = 4`
- `kSpeed = 1.311`
- `kSeparation = 2.05` (phase shift between successive ribbons)
- `kDetune = 0.05` (slight frequency variation across ribbons)
- `kAmplitude = 0.266` (normalized to orb radius)
- `kFrequency = 1.45`
- `kWidth = 0.115`
- `kTaper = 1.75`

### 3.2 Normalized Coordinate Space
All calculations evaluate in normalized coordinates:
$$x \in [-1.0, 1.0], \quad y \in [-1.0, 1.0]$$
The spherical perimeter is bounded by $x^2 + y^2 \le 1.0$.

### 3.3 Equatorial Envelope & Ribbon Math
For each band $i \in \{0, 1, 2, 3\}$:
$$\text{centred} = i - \frac{\text{kBands} - 1}{2} = i - 1.5$$
$$\text{drift} = t \cdot \text{kSpeed} \cdot 2.4$$
$$\text{phase} = \text{drift} + \text{centred} \cdot \text{kSeparation}$$
$$\text{amp} = \text{kAmplitude} \cdot (1.0 - |\text{centred}| \cdot \text{kDetune} \cdot 1.1) \cdot (0.82 + 0.18 \cdot \sin(t \cdot \text{kSpeed} \cdot 0.48 + \text{centred} \cdot 1.1))$$
$$\text{freq} = \text{kFrequency} \cdot (1.0 + \text{centred} \cdot \text{kDetune})$$
$$\text{bw} = \text{kWidth} \cdot (1.0 + |\text{centred}| \cdot 0.55)$$

For any horizontal coordinate $x \in [-1.0, 1.0]$:
$$\text{env} = \max(0.0, 1.0 - x^2)^{\text{kTaper}}$$
$$\text{wave} = \sin(x \cdot \text{freq} \cdot \pi + \text{phase})$$
$$y_{\text{center}}(x) = \text{env} \cdot \text{amp} \cdot \text{wave}$$
$$y_{\text{upper}}(x) = y_{\text{center}}(x) + 0.6 \cdot \text{bw} \cdot \text{env}$$
$$y_{\text{lower}}(x) = y_{\text{center}}(x) - 0.6 \cdot \text{bw} \cdot \text{env}$$

Each ribbon is painted as a closed polygon between $y_{\text{upper}}$ and $y_{\text{lower}}$ using a linear gradient with edge fading, overlaid with a center spine stroke and rendered with `BlendMode.screen` for additive luminous blending.

### 3.4 White Crest Line
On the dominant central harmonic wave, a sharp 1.2px crest line is stroked in semi-translucent pure white:
$$y_{\text{crest}}(x) = \text{env} \cdot \text{kAmplitude} \cdot \sin(x \cdot \text{kFrequency} \cdot \pi + \text{drift})$$

---

## 4. Component Architecture & Public API

### 4.1 File Structure
- **Single Component File:** `lib/animations/thought_orb/thought_orb.dart`
  Contains:
  - `ThoughtOrb` (Standalone widget)
  - `ThoughtOrbPill` (Frosted glass status pill)
  - `ThoughtOrbPalette` (Palette data model + presets)
  - `ThoughtOrbPainter` (CustomPainter implementing the shader math)
- **Documentation:** `lib/animations/thought_orb/README.md`
- **Showcase Integration:** `lib/showcase/data/showcase_data.dart`
- **Unit & Widget Tests:** `test/thought_orb_test.dart`

### 4.2 Widget Signatures

#### `ThoughtOrb`
```dart
class ThoughtOrb extends StatefulWidget {
  final double size;
  final ThoughtOrbPalette palette;
  final double speed;
  final bool animate;

  const ThoughtOrb({
    super.key,
    this.size = 28.0,
    this.palette = ThoughtOrbPalette.solar,
    this.speed = 1.0,
    this.animate = true,
  });
...
}
```

#### `ThoughtOrbPill`
```dart
class ThoughtOrbPill extends StatelessWidget {
  final String label;
  final double orbSize;
  final ThoughtOrbPalette palette;
  final VoidCallback? onTap;
  final bool showDots;
  final TextStyle? labelStyle;

  const ThoughtOrbPill({
    super.key,
    required this.label,
    this.orbSize = 22.0,
    this.palette = ThoughtOrbPalette.solar,
    this.onTap,
    this.showDots = true,
    this.labelStyle,
  });
...
}
```

### 4.3 Adaptive Theme Tokens

| Element | Light Mode (`#EEEAE3`) | Dark Mode (`#0F0F12`) | Description |
| :--- | :--- | :--- | :--- |
| **Pill Background** | `rgba(255, 255, 255, 0.75)` | `rgba(255, 255, 255, 0.08)` | Frosted glass backdrop |
| **Pill Border** | `rgba(0, 0, 0, 0.08)` | `rgba(255, 255, 255, 0.12)` | Subtle glass edge |
| **Pill Shadow** | `0 4px 14px rgba(0,0,0,0.06)` | `0 4px 18px rgba(0,0,0,0.30)` | Ambient elevation |
| **Pill Typography** | `#1E1E24` (Charcoal) | `#F4F3EF` (Warm White) | Status text color |
| **Pulsing Dots** | `#1E1E24` (0.3 to 1.0) | `#F4F3EF` (0.3 to 1.0) | Sequential dot train |

---

## 5. Reduced Motion & Performance

- **Reduced Motion:** If `MediaQuery.maybeOf(context)?.disableAnimations == true`, animation speed scales down to $0.15\times$ with smoothed harmonic amplitudes rather than rapid ribbons.
- **60/120 FPS Performance:** 
  - Standard `AnimationController.repeat()` driven by vsync.
  - Trigonometric step count optimized to 48 steps per band for seamless curves with sub-millisecond CPU frame rendering time.
  - Zero heap allocation during `paint` execution by reusing mutable `Path` and `Paint` objects.

---

## 6. Verification Plan

1. **Unit & Widget Tests (`test/thought_orb_test.dart`):**
   - Render `ThoughtOrb` at various sizes (24, 48, 96).
   - Render `ThoughtOrbPill` with label and verify presence of 4 pulse dots.
   - Verify tap callback triggers when tapping `ThoughtOrbPill`.
   - Verify color adaptation across Light and Dark themes.
   - Verify reduced motion disables high-speed drift.
2. **Analysis & SDK Integrity:**
   - Run `flutter analyze` with 0 warnings/errors.
   - Run all existing 13 tests plus new tests (`flutter test`).
3. **Showcase Visual Verification:**
   - Register in `ShowcaseData` and verify playground controls (Size slider, Palette selector, Status text input).
