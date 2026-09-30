# ThoughtOrb & ThoughtOrbPill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the `ThoughtOrb` and `ThoughtOrbPill` components for Flutter Craft—an AI thinking orb and status pill replicating the exact Siri Wave optics from `ThoughtOrb.metal` using the Solar Amber & Coral Rose palette.

**Architecture:** A 100% self-contained single-file component (`lib/animations/thought_orb/thought_orb.dart`) with zero external dependencies. Driven by an `AnimationController.repeat()` loop, a `CustomPainter` rendering 4 horizontal equatorial sinusoidal membranes with Gaussian beam taper envelopes, crisp white crest line, smoked obsidian glass core, specular highlight, and dual-tone rim. Accompanied by a frosted glass `ThoughtOrbPill` with sequential pulsing dots.

**Tech Stack:** Flutter SDK (Dart, `package:flutter/material.dart`, `dart:math`, `package:flutter_test`).

---

### Task 1: Add Unit & Widget Tests for ThoughtOrb & ThoughtOrbPill

**Files:**
- Create: `test/thought_orb_test.dart`

- [ ] **Step 1: Write test suite in `test/thought_orb_test.dart`**
  Covering:
  1. `ThoughtOrb` renders standalone with specified size (e.g. 28, 48, 96).
  2. `ThoughtOrb` CustomPaint painter properties (palette, progress, speed) reflect configurations.
  3. `ThoughtOrbPill` renders orb, status text label, and 4 pulse dots.
  4. `ThoughtOrbPill` fires `onTap` callback when pressed.
  5. `ThoughtOrbPill` adapts background and ink tokens across Light and Dark brightness.
  6. Accessibility / reduced motion gracefully scales down animation speed.

- [ ] **Step 2: Run test to verify it fails**
  Run: `flutter test test/thought_orb_test.dart`
  Expected: FAIL with `Target of URI doesn't exist: 'package:flutter_craft/animations/thought_orb/thought_orb.dart'`

- [ ] **Step 3: Commit test file**
  ```bash
  git add test/thought_orb_test.dart
  git commit -m "test(thought_orb): add comprehensive unit and widget tests"
  ```

---

### Task 2: Implement Single-File ThoughtOrb & ThoughtOrbPill Component

**Files:**
- Create: `lib/animations/thought_orb/thought_orb.dart`

- [ ] **Step 1: Implement `ThoughtOrbPalette` model and built-in presets**
  - Bands (4 colors), ground core, crest, rimWarm, rimCool.
  - Presets: `.solar` (default), `.siri`, `.ocean`, `.emerald`.

- [ ] **Step 2: Implement `ThoughtOrbPainter` using exact Siri Wave math**
  - Circular glass mask.
  - Smoked obsidian radial ground wash (`#1E0B19` $\to$ `#120610` $\to$ `#090208`).
  - 4 equatorial sinusoidal ribbons with $(1 - x^2)^{1.75}$ taper envelope, frequency detuning, amplitude modulation, and phase drift.
  - White crest line on the primary harmonic wave.
  - Volumetric core illumination glow (`rgba(255, 250, 235, 0.40)`).
  - Off-center curved specular highlight.
  - Luminous dual-tone glass rim (`#FBBF24` $\to$ `#FB7185`).

- [ ] **Step 3: Implement `ThoughtOrb` StatefulWidget**
  - Ticker provider animation loop (`controller.repeat()`).
  - Support `size`, `palette`, `speed`, `animate`.
  - Handle reduced motion by scaling speed down to $0.15\times$.

- [ ] **Step 4: Implement `ThoughtOrbPill` and `_PulsingDots`**
  - Rounded pill container with frosted backdrop filter and adaptive borders.
  - Embedded `ThoughtOrb(size: orbSize)`.
  - Status label typography with smooth theme adaptation.
  - 4 animated pulse dots with 0.15s staggered phase offsets.
  - Tap gesture callback and touch feedback.

- [ ] **Step 5: Run tests and static analysis**
  Run: `flutter test test/thought_orb_test.dart`
  Run: `flutter analyze`
  Expected: All tests pass with 0 analyze issues.

- [ ] **Step 6: Commit component implementation**
  ```bash
  git add lib/animations/thought_orb/thought_orb.dart
  git commit -m "feat(thought_orb): create self-contained ThoughtOrb and ThoughtOrbPill with exact Siri Wave optics"
  ```

---

### Task 3: Showcase Catalog & Interactive Playground Integration

**Files:**
- Modify: `lib/showcase/data/showcase_data.dart`

- [ ] **Step 1: Register ThoughtOrb in `ShowcaseData.items`**
  - Add `ShowcaseItem` with id `'thought-orb'`, title `'Thought Orb'`, subtitle `'Apple Intelligence Siri wave mark with frosted glass status pill'`.
  - Category: `'AI & Feedback'`.
  - Tags: `['ai', 'siri', 'wave', 'glow', 'pill', 'loader']`.
  - Full code snippet and interactive playground preview.

- [ ] **Step 2: Build Interactive Playground controls for ThoughtOrb**
  - Playground widget showcasing both:
    1. Hero Standalone Orb with Size slider (24px to 120px) and Speed slider.
    2. Interactive `ThoughtOrbPill` with preset actions ("Thinking", "Searching web", "Drafting reply", "Analyzing data").
    3. Palette selector (Solar Amber, Siri, Ocean, Emerald).
    4. Dark / Light mode instant preview.

- [ ] **Step 3: Run static analysis and widget tests**
  Run: `flutter analyze && flutter test`
  Expected: All tests pass with 0 issues.

- [ ] **Step 4: Commit showcase integration**
  ```bash
  git add lib/showcase/data/showcase_data.dart
  git commit -m "feat(showcase): register ThoughtOrb and interactive playground in showcase catalog"
  ```

---

### Task 4: Component Documentation & Readme Updates

**Files:**
- Create: `lib/animations/thought_orb/README.md`
- Modify: `README.md`

- [ ] **Step 1: Create `lib/animations/thought_orb/README.md`**
  - Overview, key features (exact Siri wave math, zero dependencies, copy-paste ready).
  - Quickstart examples for both `ThoughtOrb` and `ThoughtOrbPill`.
  - API Reference table with parameters, types, and defaults.
  - Custom palette guide.

- [ ] **Step 2: Update root `README.md`**
  - Add `ThoughtOrb` to the showcase component table.
  - Update component counter to 5.

- [ ] **Step 3: Commit documentation**
  ```bash
  git add lib/animations/thought_orb/README.md README.md
  git commit -m "docs(thought_orb): add component README and update root catalog"
  ```

---

### Task 5: Full Verification, Git Push & Desktop Mirror Sync

- [ ] **Step 1: Run complete verification suite**
  Run: `flutter analyze`
  Run: `flutter test`
  Expected: 0 issues, 100% tests passing.

- [ ] **Step 2: Push to GitHub origin**
  Run: `git push origin main`

- [ ] **Step 3: Sync to Desktop mirror**
  Run: `cd /Users/charu/Desktop/flutter_craft && git pull origin main`
