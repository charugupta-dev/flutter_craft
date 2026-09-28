# Breathing Loader: Solar Amber & Coral Rose Palette Design

## 1. Overview & Context

`flutter_craft` aims to deliver Apple-grade, organic micro-interactions and tactile components with zero external dependencies. The `BreathingLoader` component renders a 3D particle sphere using 170 Fibonacci-distributed points with continuous dual-axis rotation, perspective projection, depth-sorted alpha blending, and harmonic breathing expansion.

Previously, `BreathingLoader` used fallback monochrome slate/white tones. Following an interactive browser-based visual exploration across 5 distinct curated palettes, the **Solar Amber & Coral Rose (Option D)** palette was selected to establish a warm, celestial, and organic visual signature while maintaining high contrast in both Dark and Light themes.

---

## 2. Design Goals

1. **Organic Celestial Vibe:** Establish a warm solar aesthetic that accentuates the rhythmic "breathing" expansion and 3D depth of the particle sphere.
2. **Apple-Grade Adaptive Contrast:**
   - On OLED Dark mode (`#0F0F12`), use radiant, luminous tones that glow without blowing out particle edges.
   - On warm off-white canvas (`#EEEAE3`), use richer, saturated tones (`Amber 600` and `Rose 600`) to guarantee crisp particle definition and avoid washed-out contrast.
3. **Non-Breaking Single-File Architecture:**
   - Preserve zero external dependencies.
   - Retain optional `primaryColor` and `secondaryColor` parameter overrides so developers can still supply custom palettes.

---

## 3. Detailed Color Specification

| Theme Mode | Sphere Layer | Tone | Hex Code | Material Equivalent | Visual Function |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Dark Mode** (`#0F0F12`) | Primary (Core / High-Z) | Golden Amber | `#FBBF24` | Amber 400 | Radiant, glowing solar core at front of sphere |
| **Dark Mode** (`#0F0F12`) | Secondary (Drift / Low-Z) | Coral Rose | `#FB7185` | Rose 400 | Warm coral drift creating deep 3D perspective |
| **Light Mode** (`#EEEAE3`) | Primary (Core / High-Z) | Sunset Amber | `#D97706` | Amber 600 | High-contrast amber defined against off-white canvas |
| **Light Mode** (`#EEEAE3`) | Secondary (Drift / Low-Z) | Deep Rose | `#E11D48` | Rose 600 | Saturated coral-rose contouring with sharp edge definition |

---

## 4. Architectural & Component Changes

### 4.1 Component Default Colors (`lib/animations/breathing_loader/breathing_loader.dart`)
In `_BreathingLoaderState.build()`, update the default color resolution:

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
final defaultPrimary = isDark
    ? const Color(0xFFFBBF24) // Golden Amber 400
    : const Color(0xFFD97706); // Sunset Amber 600

final defaultSecondary = isDark
    ? const Color(0xFFFB7185) // Coral Rose 400
    : const Color(0xFFE11D48); // Deep Rose 600

final effectivePrimary = widget.primaryColor ?? defaultPrimary;
final effectiveSecondary = widget.secondaryColor ?? defaultSecondary;
```

### 4.2 Showcase Data (`lib/showcase/data/showcase_data.dart`)
- Update `codeSnippet` in the showcase registry to demonstrate the signature Solar Amber & Coral Rose palette:
```dart
BreathingLoader(
  sphereSize: 140,
  breathingSpeed: 1.25,
  rotationSpeed: 0.25,
  dotSize: 4.0,
  primaryColor: Color(0xFFFBBF24),
  secondaryColor: Color(0xFFFB7185),
)
```

### 4.3 Component Documentation (`lib/animations/breathing_loader/README.md`)
- Update the default colors description and usage code snippet.

---

## 5. Verification Plan

1. **Code Quality & Static Analysis:**
   - Run `flutter analyze` to ensure zero warnings or errors.
2. **Automated Widget & Unit Tests:**
   - Run `flutter test` to verify existing tests pass and add an explicit test verifying default color resolution in both light and dark modes.
3. **Visual Verification:**
   - Build and verify in iOS Simulator / web preview across both Light (`#EEEAE3`) and Dark (`#0F0F12`) themes.
