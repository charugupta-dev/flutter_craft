# FanStack Component Design Specification

## 1. Overview & Purpose

`FanStack` is an interactive avatar group control inspired by high-end iOS UI patterns (SwiftPieces). In its default collapsed state, it presents an overlapping chain of avatars with cut-out borders and an overflow indicator (`+N`). When tapped or held, it springs open horizontally with staggered physics, allowing users to scrub across avatars, inspect floating name tags, and select a person with tactile haptic feedback.

For `flutter_craft`, `FanStack` is engineered as a **100% self-contained single-file component** with **zero external dependencies**, featuring an original **Studio Ceramic** color palette tailored to both warm off-white and OLED dark themes.

---

## 2. Visual Direction: Studio Ceramic Palette

Instead of generic web pastels, `flutter_craft` adopts an Apple Fine Woven & Matte Ceramic aesthetic:

### 2.1 Avatar Tile Colors
Deterministic assignment via FNV-1a 32-bit hash of the avatar name modulo palette length:
- **Terracotta Rust:** `#E06D53`
- **Aegean Slate Blue:** `#5E9CAE`
- **Ochre Gold:** `#DDA15E`
- **Celadon Jade:** `#7FA99B`
- **Heather Plum:** `#9B7E9F`
- **Warm Bisque:** `#E6CCB2`
- **Initials Ink:** `#1E1E24` (Deep charcoal contrast across all tiles)

### 2.2 Adaptive Environment Tokens

| Element | Light Mode (`#EEEAE3`) | Dark Mode (`#0F0F12`) | Description |
| :--- | :--- | :--- | :--- |
| **Cut-out Ring** | `#EEEAE3` | `#0F0F12` | Matches canvas to produce circular cutout notch |
| **Overflow Fill** | `#E0DDD5` | `#262626` | Pill background for `+N` badge |
| **Overflow Ink** | `#141414` | `#F4F3EF` | Pill typography for `+N` |
| **Caption Text** | `#6B6862` | `#A6A49F` | First name under fanned avatars |
| **Name Tag Pill** | `#141414` | `#F4F3EF` | Floating capsule above hovered avatar |
| **Name Tag Ink** | `#F4F3EF` | `#141414` | Text inside floating capsule |

---

## 3. Component Architecture & Public API

### 3.1 File Structure
- Single drop-in component: `lib/animations/fan_stack/fan_stack.dart`
- Documentation: `lib/animations/fan_stack/README.md`
- Showcase entry: Registered in `lib/showcase/data/showcase_data.dart`
- Test suite: `test/widget_test.dart` and dedicated component tests

### 3.2 Widget Signature
```dart
class FanStack extends StatefulWidget {
  final List<String> names;
  final List<ImageProvider?>? images;
  final double size;
  final int max;
  final double overlap;
  final ValueChanged<String>? onSelect;
  final bool? isFanned;
  final ValueChanged<bool>? onFannedChanged;
  final FanStackStyle? style;

  const FanStack({
    super.key,
    required this.names,
    this.images,
    this.size = 48.0,
    this.max = 4,
    this.overlap = 0.25,
    this.onSelect,
    this.isFanned,
    this.onFannedChanged,
    this.style,
  });
}
```

### 3.3 Style Configuration (`FanStackStyle`)
```dart
class FanStackStyle {
  final List<Color> colors;
  final Color ink;
  final Color? ring;
  final Color? overflowFill;
  final Color? overflowInk;
  final Color? caption;
  final Color? tagFill;
  final Color? tagInk;

  const FanStackStyle({
    this.colors = const [
      Color(0xFFE06D53),
      Color(0xFF5E9CAE),
      Color(0xFFDDA15E),
      Color(0xFF7FA99B),
      Color(0xFF9B7E9F),
      Color(0xFFE6CCB2),
    ],
    this.ink = const Color(0xFF1E1E24),
    this.ring,
    this.overflowFill,
    this.overflowInk,
    this.caption,
    this.tagFill,
    this.tagInk,
  });

  static const studioCeramic = FanStackStyle();
}
```

---

## 4. Mathematical Layout & Physics Engine

### 4.1 Horizontal Metrics
- `visibleCount = min(names.length, max)`
- `overflow = names.length - visibleCount`
- `collapsedStep = size * (1.0 - overlap)`
- `fannedStep = size + 14.0` (14px gap)
- Collapsed width: `visibleCount * collapsedStep + size`
- Fanned width: `(names.length - 1) * fannedStep + size`

### 4.2 Staggered Spring Animation
- Animation Controller drives progress from `0.0` (collapsed) to `1.0` (fanned).
- Opening stagger: Avatar `i` delays by `i * 0.035s`.
- Closing stagger: Avatar `i` reverses delay from right to left (`(names.length - 1 - i) * 0.035s`).
- Uses `SpringSimulation` or damped spring curve (`CurvedAnimation` with spring parameters) for an authentic iOS-grade bounce.

### 4.3 Lift & Elevation States
When an avatar is hovered / scrubbed:
- Scale increases from `1.0` to `1.18x`.
- Vertical offset shifts upward by `-4.0px`.
- BoxShadow expands: `BoxShadow(color: Colors.black.withOpacity(0.22), blurRadius: 10, offset: Offset(0, 6))`.
- Z-index elevates above all neighboring avatars (`names.length + 10`).
- Floating capsule tag displays full name at `y = -34px` with scale transition (0.6 -> 1.0).

---

## 5. Gesture Interaction & State Machine

1. **Tap (< 300ms):**
   - Toggles fan open or closed.
2. **Touch & Hold (300ms hold timer):**
   - Automatically fans open without lifting finger.
   - Enters live scrub tracking.
3. **Scrubbing (`onPanUpdate` / touch moves):**
   - Detects avatar under pointer: `index = (localX / fannedStep).floor()`.
   - Triggers `HapticFeedback.selectionClick()` whenever index changes.
4. **Release (`onPanEnd` / `onTapUp`):**
   - If released over an active avatar:
     - Triggers `HapticFeedback.mediumImpact()`.
     - Calls `onSelect?.call(names[index])`.
     - Folds stack back to collapsed state.
   - If released in empty region: collapses stack.

---

## 6. Accessibility & Reduced Motion

- Reads `MediaQuery.maybeOf(context)?.disableAnimations ?? false`.
- If reduced motion is active:
  - Stagger delays and spring bounce are disabled.
  - Avatars transition via smooth linear slide.
  - Lifted state uses high-contrast ring outline rather than aggressive scaling and floating tags.
- Full screen-reader semantics with `Semantics(label: "...", button: true)`.

---

## 7. Verification Plan

1. **Automated Tests (`test/widget_test.dart`):**
   - Test collapsed state: visible avatars count and `+N` overflow pill rendering.
   - Test fanned expansion: tap unfolds all avatars, captions become visible.
   - Test avatar selection: tap on avatar calls `onSelect` with correct name.
   - Test light/dark theme adaptation for cut-out rings and text inks.
2. **Static Analysis:**
   - Run `flutter analyze` ensuring 0 warnings.
3. **Gallery Verification:**
   - Add to showcase catalog and verify in iOS Simulator.
