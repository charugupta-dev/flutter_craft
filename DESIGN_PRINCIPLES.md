# Flutter Craft: Design Principles & Quality Benchmarks

> **The Vision:** Bringing Apple-grade craft, tactile physics, fluid spring gestures, and sensory micro-interactions to Flutter with zero external dependencies.

---

## 1. The Core Opportunity & Market Differentiation

Most Flutter applications suffer from **"Material Design fatigue"**—they are functionally robust but often feel like utilitarian Google forms rather than premium, buttery-smooth consumer experiences (e.g., Linear, Apple Fitness, Superwall, Cash App).

While existing Flutter repositories or registries (like FlutterFX) primarily port **web/marketing effects** (such as glowing border beams, hyper text, or static cards), **`flutter_craft`** targets the high-end gap pioneered in iOS by **SwiftPieces** and **WithAnimation**:

| Benchmark Dimension | Existing Flutter Sites / Packages | `flutter_craft` Standard |
| :--- | :--- | :--- |
| **Aesthetic Direction** | Web / SaaS landing page effects | **Apple HIG, iOS system apps, tactile refinement** |
| **Motion Philosophy** | Auto-playing static loops & timers | **Physics-driven, gesture-tracked, velocity-aware springs** |
| **Architecture** | Heavy `pubspec.yaml` dependencies | **100% self-contained single-folder drops (Zero deps)** |
| **Theme & Polish** | Hardcoded colors or accent themes | **Dynamic dark/light mode adaptation (white/black craft)** |
| **Accessibility** | Often ignored | **Built-in semantics & reduced-motion fallbacks** |

---

## 2. The 5 Golden Rules for Every Component

Whenever building or refining a component for `flutter_craft`, adhere to these five pillars:

### ① Zero External Dependencies (True Copy-Paste Architecture)
* Each animation or component must reside in its own isolated directory: `lib/animations/<name>/`.
* Every component must rely **strictly** on standard Flutter SDK libraries (`dart:math`, `package:flutter/material.dart`, `package:flutter/physics.dart`).
* A developer must be able to copy that single `.dart` file into any vanilla Flutter project and have it work immediately.

### ② Tactile & Physics-Driven Motion
* Favor natural physics simulations (`SpringSimulation`, inertia, velocity clamping) over artificial linear or generic cubic easing curves.
* For interactive gestures, ensure the widget can be "caught" mid-flight if the user touches the screen again while the animation is oscillating.

### ③ Seamless Dark & Light Adaptive Styling
* By default, every component must dynamically adapt its primary stroke, glyph, or foreground color:
  * **Dark Mode:** Clean, crisp **White** (`Colors.white`).
  * **Light Mode:** Sleek, deep **Black** (`Colors.black`).
* Always provide optional parameter overrides (`Color? color`, `TextStyle? textStyle`) so developers can customize without hacking the source.

### ④ Micro-Typography & Proportions
* Prefer subtle, refined, compact typography over oversized blocky text.
* Ensure font sizes, letter spacing, and hit-testing paddings feel balanced on mobile screens and modern high-DPI displays.

### ⑤ Distraction-Free Showcase Gallery
* Showcase detail screens must remain distraction-free: the interactive component centered on screen with clean AppBar controls (back navigation and instant theme toggle).
* Interactive previews in the gallery grid should allow direct touch feedback where applicable.

---
