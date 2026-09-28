# Fan Stack

An interactive avatar group control that sits in an overlapping chain and springs open into a selectable horizontal fan with live scrubbing, floating capsule name tags, and an original Studio Ceramic palette.

---

## Features
- **Zero External Dependencies:** Built entirely with pure Flutter primitives, `AnimationController`, custom spring curves, and pointer gesture recognition.
- **Studio Ceramic Palette:** A deterministic earthy, warm ceramic color palette (Terracotta, Aegean Slate, Ochre, Celadon, Heather Plum, Warm Bisque) paired with deep charcoal ink.
- **Organic Spring Physics:** Staggered spring animations expand and collapse the avatar chain with authentic physical momentum.
- **Tactile Scrubbing & Haptics:** Long-press or drag across the fan to scrub through participants with haptic selection feedback and floating full-name pill tags.
- **Theme-Adaptive:** Automatically adapts cut-out rings, overflow badges, and typography to light and dark theme brightness.
- **Accessibility Ready:** Honors system reduced motion preferences (`MediaQuery.disableAnimationsOf(context)`), and exposes comprehensive semantics for screen readers.

---

## Usage

Simply copy `fan_stack.dart` into your project and use it:

```dart
import 'fan_stack.dart';

// Basic usage with names
FanStack(
  names: const [
    'Priya Raman',
    'Jonas Weber',
    'Amara Diallo',
    'Leo Brandt',
    'Sofia Marin',
    'Kenji Sato',
  ],
  size: 48,
  max: 4,
  onSelect: (name) => print('Selected $name'),
);

// Custom avatar images with initials fallback
FanStack(
  names: const ['Alex Chen', 'Samira Khan'],
  avatars: const [
    NetworkImage('https://example.com/avatar1.jpg'),
    null, // falls back to initials
  ],
  size: 52,
);
```

---

## Parameters

### FanStack

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `names` | `List<String>` | *required* | Participant full names used for avatar initials and labels. |
| `avatars` | `List<ImageProvider?>?` | `null` | Optional image providers corresponding to names. Falls back to initials when null. |
| `size` | `double` | `48.0` | Base diameter of each avatar circle in points (clamped 28.0 to 80.0). |
| `max` | `int` | `4` | Maximum avatars shown in the collapsed stack before the `+N` pill (clamped >= 1). |
| `spacing` | `double?` | `null` | Horizontal spacing between avatar centers when fanned open (defaults to `size + 14`). |
| `overlap` | `double?` | `null` | Center-to-center offset between avatars in collapsed stack (defaults to `size * 0.44`). |
| `style` | `FanStackStyle` | `FanStackStyle.studioCeramic` | Visual style token configuration (palette, ring, tag fills, ink). |
| `onSelect` | `ValueChanged<String>?` | `null` | Callback invoked with the selected participant name upon tap or scrub release. |
| `onFanStateChanged` | `ValueChanged<bool>?` | `null` | Callback invoked when the fan stack transitions between expanded (`true`) and collapsed (`false`). |

### FanStackStyle

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `colors` | `List<Color>` | Studio Ceramic (6 tones) | Deterministic color list used to tint initials tiles via FNV-1a hash. |
| `ink` | `Color` | `#1E1E24` | Text color for initials tiles. |
| `ring` | `Color?` | Adaptive | Cut-out border ring color (defaults to canvas tone `#EEEAE3` / `#0F0F12`). |
| `overflowFill` | `Color?` | Adaptive | Background color for the `+N` overflow pill. |
| `overflowInk` | `Color?` | Adaptive | Text color for the `+N` overflow pill. |
| `caption` | `Color?` | Adaptive | Text color for the first-name captions rendered below fanned avatars. |
| `tagFill` | `Color?` | Adaptive | Background color for the floating full-name capsule tag. |
| `tagInk` | `Color?` | Adaptive | Text color for the floating full-name capsule tag. |
