# Breathing Loader

A transparent 3D particle sphere that expands, drifts, and rotates in three dimensions with continuous perspective depth.

---

## Features
- **Zero External Dependencies:** Built with pure Flutter `CustomPainter` and 3D vector rotation math.
- **True 3D Perspective Projection:** Depth-scaled particle sizes, rear-opacity falloff, and Z-index depth sorting for authentic depth perception.
- **Fibonacci Sphere Distribution:** 170 deterministic particles distributed via the golden spiral on a unit sphere.
- **Harmonic Motion:** Sinusoidal breathing contraction/expansion paired with subtle multi-axis turbulence and dual-axis rotation.
- **Accessible:** Includes accessibility semantics and honors reduced-motion preferences (`MediaQuery.disableAnimations`).

---

## Usage

Simply copy `breathing_loader.dart` into your project and use it:

```dart
import 'breathing_loader.dart';

// Basic usage
const BreathingLoader();

// Customized usage
const BreathingLoader(
  sphereSize: 150.0,
  breathingSpeed: 1.5,
  rotationSpeed: 0.35,
  dotSize: 5.0,
  primaryColor: Color(0xFFFBBF24),
  secondaryColor: Color(0xFFFB7185),
);
```

---

## Parameters

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `sphereSize` | `double` | `140.0` | Authored radius of the particle sphere (clamped 80.0 to 200.0). |
| `breathingSpeed` | `double` | `1.25` | Speed multiplier for expansion and contraction (clamped 0.5 to 2.5). |
| `rotationSpeed` | `double` | `0.25` | Speed multiplier for continuous Y-axis rotation (clamped 0.0 to 1.0). |
| `dotSize` | `double` | `4.0` | Base diameter of individual particles (clamped 3.0 to 14.0). |
| `primaryColor` | `Color?` | Adaptive: `#FBBF24` (dark) / `#D97706` (light) | Color of alternating particles (Solar Amber). |
| `secondaryColor` | `Color?` | Adaptive: `#FB7185` (dark) / `#E11D48` (light) | Color of alternating particles (Coral Rose). |
| `isAnimating` | `bool` | `true` | Whether the loader animation is actively running. |
| `width` | `double?` | `null` | Optional fixed width constraint. |
| `height` | `double?` | `null` | Optional fixed height constraint. |
