# Spring Text

A tactile, playful line of text that bends under vertical drag gestures and springs back with realistic physics upon release.

Crafted by **Charu** for `flutter_craft`.

---

## Features
- **Zero External Dependencies:** Built with pure Flutter `Transform`, `GestureDetector`, and `SpringSimulation` (`package:flutter/physics.dart`).
- **Tactile Spring Physics:** Faithful port of SwiftUI's interactive spring motion with configurable bounce and damping.
- **Adaptive Theme:** Automatically renders White in Dark Mode and Black in Light Mode, or accepts any custom color/style.
- **Accessible:** Includes semantics and honors reduced motion preferences (`MediaQuery.disableAnimations`).

---

## Usage

Simply copy `spring_text.dart` into your project and use it:

```dart
import 'spring_text.dart';

// Basic usage (adaptive white/black theme)
const SpringText('Spring Text');

// Customized usage
const SpringText(
  'Spring Text',
  fontSize: 48.0,
  maxDrag: 180.0,
  curveStrength: 0.70,
  bounce: 0.75,
  color: Colors.white,
);
```

---

## Parameters

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `text` | `String` | *required* | The text string to bend and animate. |
| `fontSize` | `double` | `40.0` | Font size (clamped between 20.0 and 72.0). |
| `color` | `Color?` | `null` | Text color. When null, adapts to White (Dark Mode) or Black (Light Mode). |
| `textStyle` | `TextStyle?` | `null` | Optional custom `TextStyle` applied to characters. |
| `maxDrag` | `double` | `180.0` | Maximum vertical displacement in points (clamped 60 to 260). |
| `curveStrength` | `double` | `0.70` | Intensity of the catenary bend arc (clamped 0.2 to 1.0). |
| `bounce` | `double` | `0.70` | Spring bounciness / damping upon release (clamped 0.0 to 0.9). |
| `characterSpacing` | `double` | `2.0` | Spacing between characters in points. |
| `padding` | `EdgeInsetsGeometry` | `EdgeInsets.symmetric(h: 24, v: 48)` | Hit-testing touch target area around the text. |
