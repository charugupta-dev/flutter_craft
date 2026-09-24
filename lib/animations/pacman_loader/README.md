# Pacman Loader

A smooth, delightful Pacman loading animation where Pacman munches dots across a track with live progress percentage.

Crafted by **Charu** for `flutter_craft`.

---

## Features
- **Zero External Dependencies:** Built with pure Flutter `CustomPainter` and `AnimatedBuilder`.
- **Responsive:** Automatically adapts to any parent width using `LayoutBuilder`.
- **Customizable:** Adjust duration, dot count, pacman size, colors, and toggle percentage.

---

## Usage

Simply copy `pacman_loader.dart` into your project and use it:

```dart
import 'pacman_loader.dart';

// Basic usage
PacmanLoader();

// Customized usage
PacmanLoader(
  totalDuration: Duration(seconds: 4),
  dotCount: 12,
  pacmanSize: 36.0,
  color: Color(0xFFFACC15), // Classic Pacman yellow
  showsPercentage: true,
);
```

---

## Parameters

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `totalDuration` | `Duration` | `Duration(milliseconds: 4500)` | Time for Pacman to complete one full track run. |
| `dotCount` | `int` | `12` | Number of dots on the track to eat. |
| `pacmanSize` | `double` | `32.0` | Diameter of the Pacman character. |
| `color` | `Color?` | `Theme primary` | Color of Pacman, dots, and percentage text. |
| `showsPercentage` | `bool` | `true` | Whether to display the monospaced progress text below. |
