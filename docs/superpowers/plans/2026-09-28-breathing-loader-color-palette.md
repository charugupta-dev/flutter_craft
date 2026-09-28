# Breathing Loader Solar Amber & Coral Rose Palette Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Update `BreathingLoader` default colors to the signature Solar Amber & Coral Rose palette (Amber 400 & Rose 400 in Dark Mode, Amber 600 & Rose 600 in Light Mode) across the component, showcase, and documentation.

**Architecture:** Update `_BreathingLoaderState.build()` to resolve adaptive default colors based on `Theme.of(context).brightness`, maintaining single-file zero-dependency architecture and preserving custom parameter overrides.

**Tech Stack:** Flutter SDK (Dart, `package:flutter/material.dart`, `package:flutter_test`).

---

### Task 1: Add Color Adaptation Unit Tests for BreathingLoader

**Files:**
- Modify: `test/widget_test.dart`

- [ ] **Step 1: Write the failing tests for theme color adaptation**

Add tests to `test/widget_test.dart` verifying that `BreathingLoader` resolves to the new Solar Amber (`#D97706`) and Coral Rose (`#E11D48`) in Light Mode, and Golden Amber (`#FBBF24`) and Coral Rose (`#FB7185`) in Dark Mode:

```dart
  testWidgets('BreathingLoader adapts default colors to Light mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: const Scaffold(
          body: Center(
            child: BreathingLoader(
              sphereSize: 100,
            ),
          ),
        ),
      ),
    );

    final customPainterFinder = find.descendant(
      of: find.byType(BreathingLoader),
      matching: find.byType(CustomPaint),
    );
    expect(customPainterFinder, findsWidgets);

    final customPaint = tester.widget<CustomPaint>(customPainterFinder.first);
    final painter = customPaint.painter as dynamic;
    expect(painter.primaryColor, const Color(0xFFD97706));
    expect(painter.secondaryColor, const Color(0xFFE11D48));
  });

  testWidgets('BreathingLoader adapts default colors to Dark mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: const Scaffold(
          body: Center(
            child: BreathingLoader(
              sphereSize: 100,
            ),
          ),
        ),
      ),
    );

    final customPainterFinder = find.descendant(
      of: find.byType(BreathingLoader),
      matching: find.byType(CustomPaint),
    );
    expect(customPainterFinder, findsWidgets);

    final customPaint = tester.widget<CustomPaint>(customPainterFinder.first);
    final painter = customPaint.painter as dynamic;
    expect(painter.primaryColor, const Color(0xFFFBBF24));
    expect(painter.secondaryColor, const Color(0xFFFB7185));
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
export PATH="/Users/charu/development/flutter/bin:$PATH" && flutter test test/widget_test.dart
```
Expected: FAIL because `BreathingLoader` currently uses monochrome colors (`0xFF000000` / `0xFFFFFFFF`).

---

### Task 2: Implement Solar Amber & Coral Rose Defaults in BreathingLoader

**Files:**
- Modify: `lib/animations/breathing_loader/breathing_loader.dart:82-95`

- [ ] **Step 1: Update default color constants in `_BreathingLoaderState`**

In `lib/animations/breathing_loader/breathing_loader.dart`, update lines 82-95:

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

- [ ] **Step 2: Run tests to verify they pass**

Run:
```bash
export PATH="/Users/charu/development/flutter/bin:$PATH" && flutter test test/widget_test.dart
```
Expected: PASS with 7/7 tests passing.

- [ ] **Step 3: Commit component change**

```bash
git add lib/animations/breathing_loader/breathing_loader.dart test/widget_test.dart
git commit -m "feat(breathing_loader): apply Solar Amber and Coral Rose adaptive color palette"
```

---

### Task 3: Update Showcase Snippet and Documentation

**Files:**
- Modify: `lib/showcase/data/showcase_data.dart:117-126`
- Modify: `lib/animations/breathing_loader/README.md:27-37`

- [ ] **Step 1: Update `showcase_data.dart` code snippet**

In `lib/showcase/data/showcase_data.dart`:
```dart
    codeSnippet: '''
BreathingLoader(
  sphereSize: 140,
  breathingSpeed: 1.25,
  rotationSpeed: 0.25,
  dotSize: 4.0,
  primaryColor: Color(0xFFFBBF24),
  secondaryColor: Color(0xFFFB7185),
)
''',
```

- [ ] **Step 2: Update `lib/animations/breathing_loader/README.md`**

Update snippet and description in `lib/animations/breathing_loader/README.md` to reference the Solar Amber (`#FBBF24` / `#D97706`) and Coral Rose (`#FB7185` / `#E11D48`) defaults.

- [ ] **Step 3: Run static analysis**

Run:
```bash
export PATH="/Users/charu/development/flutter/bin:$PATH" && flutter analyze
```
Expected: "No issues found!"

- [ ] **Step 4: Commit documentation & showcase updates**

```bash
git add lib/showcase/data/showcase_data.dart lib/animations/breathing_loader/README.md
git commit -m "docs(breathing_loader): update showcase code snippet and component documentation"
```

---

### Task 4: Full Verification and Desktop Sync

**Files:**
- All modified files

- [ ] **Step 1: Run complete test suite and analyzer**

```bash
export PATH="/Users/charu/development/flutter/bin:$PATH" && flutter analyze && flutter test
```
Expected: Zero issues, all tests pass.

- [ ] **Step 2: Push to GitHub origin main**

```bash
git push origin main
```

- [ ] **Step 3: Pull changes into Desktop mirror**

```bash
cd /Users/charu/Desktop/flutter_craft && git pull origin main
```
