import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_craft/animations/fan_stack/fan_stack.dart';

void main() {
  const testNames = [
    'Priya Raman',
    'Jonas Weber',
    'Amara Diallo',
    'Leo Brandt',
    'Sofia Marin',
    'Kenji Sato',
  ];

  testWidgets('FanStack renders collapsed with visible avatars and overflow pill',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: FanStack(
              names: testNames,
              size: 48,
              max: 4,
            ),
          ),
        ),
      ),
    );

    // Initial 2-letter initials for first visible avatars
    expect(find.text('PR'), findsOneWidget);
    expect(find.text('JW'), findsOneWidget);
    expect(find.text('AD'), findsOneWidget);
    expect(find.text('LB'), findsOneWidget);

    // Overflow pill (+2)
    expect(find.text('+2'), findsOneWidget);

    // Captions are not visible when collapsed
    expect(find.text('Priya'), findsNothing);
  });

  testWidgets('FanStack fans open on tap showing all avatars and first-name captions',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: FanStack(
              names: testNames,
              size: 48,
              max: 4,
            ),
          ),
        ),
      ),
    );

    // Tap to expand
    await tester.tap(find.byType(FanStack));
    await tester.pumpAndSettle();

    // All initials visible
    expect(find.text('PR'), findsOneWidget);
    expect(find.text('JW'), findsOneWidget);
    expect(find.text('AD'), findsOneWidget);
    expect(find.text('LB'), findsOneWidget);
    expect(find.text('SM'), findsOneWidget);
    expect(find.text('KS'), findsOneWidget);

    // First-name captions visible
    expect(find.text('Priya'), findsOneWidget);
    expect(find.text('Jonas'), findsOneWidget);
    expect(find.text('Amara'), findsOneWidget);
    expect(find.text('Leo'), findsOneWidget);
    expect(find.text('Sofia'), findsOneWidget);
    expect(find.text('Kenji'), findsOneWidget);
  });

  testWidgets('Tapping an avatar fires onSelect and collapses',
      (WidgetTester tester) async {
    String? selectedName;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FanStack(
              names: testNames,
              size: 48,
              onSelect: (name) => selectedName = name,
            ),
          ),
        ),
      ),
    );

    // Fan open
    await tester.tap(find.byType(FanStack));
    await tester.pumpAndSettle();

    // Tap on Priya
    await tester.tap(find.text('PR'));
    await tester.pumpAndSettle();

    expect(selectedName, 'Priya Raman');

    // Should collapse back: captions disappear
    expect(find.text('Priya'), findsNothing);
  });

  testWidgets('FanStack adapts cut-out ring and labels across light and dark themes',
      (WidgetTester tester) async {
    // Light mode test
    await tester.pumpWidget(
      MaterialApp(
        home: Theme(
          data: ThemeData.light(),
          child: const Scaffold(
            body: Center(
              child: FanStack(
                key: ValueKey('light_stack'),
                names: testNames,
                size: 48,
                max: 4,
              ),
            ),
          ),
        ),
      ),
    );

    // Check light mode overflow ink
    final lightOverflow = tester.widget<Text>(find.text('+2'));
    expect(lightOverflow.style?.color, const Color(0xFF141414));

    // Check light mode cut-out ring
    final lightAvatarContainer = tester.widget<Container>(
      find.byKey(const ValueKey('fan_avatar_0')),
    );
    final lightDec = lightAvatarContainer.decoration as BoxDecoration;
    expect(lightDec.border?.top.color, const Color(0xFFEEEAE3));

    // Tap to open in light mode and inspect caption color
    await tester.tap(find.byType(FanStack));
    await tester.pumpAndSettle();

    final lightCaption = tester.widget<Text>(find.text('Priya'));
    expect(lightCaption.style?.color, const Color(0xFF6B6862));

    // Dark mode test
    await tester.pumpWidget(
      MaterialApp(
        home: Theme(
          data: ThemeData.dark(),
          child: const Scaffold(
            body: Center(
              child: FanStack(
                key: ValueKey('dark_stack'),
                names: testNames,
                size: 48,
                max: 4,
              ),
            ),
          ),
        ),
      ),
    );

    // Check dark mode overflow ink
    final darkOverflow = tester.widget<Text>(find.text('+2'));
    expect(darkOverflow.style?.color, const Color(0xFFF4F3EF));

    // Check dark mode cut-out ring
    final darkAvatarContainer = tester.widget<Container>(
      find.byKey(const ValueKey('fan_avatar_0')),
    );
    final darkDec = darkAvatarContainer.decoration as BoxDecoration;
    expect(darkDec.border?.top.color, const Color(0xFF0F0F12));

    // Tap to open in dark mode and inspect caption color
    await tester.tap(find.byType(FanStack));
    await tester.pumpAndSettle();

    final darkCaption = tester.widget<Text>(find.text('Priya'));
    expect(darkCaption.style?.color, const Color(0xFFA6A49F));
  });

  testWidgets('FanStack scrubbing selects avatar on pointer release',
      (WidgetTester tester) async {
    String? selectedName;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FanStack(
              names: testNames,
              size: 48,
              onSelect: (name) => selectedName = name,
            ),
          ),
        ),
      ),
    );

    // Hold for 300ms to open fan and engage scrub
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(FanStack)),
    );
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    // Move to avatar 1 ('Jonas Weber', around x = 62 offset)
    await gesture.moveBy(const Offset(62, 0));
    await tester.pump();

    // Release
    await gesture.up();
    await tester.pumpAndSettle();

    expect(selectedName, isNotNull);
  });

  testWidgets('FanStack respects reduced motion accessibility settings',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: Center(
              child: FanStack(
                names: testNames,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );

    // Tap to open
    await tester.tap(find.byType(FanStack));
    await tester.pumpAndSettle();

    // Captions visible
    expect(find.text('PR'), findsOneWidget);
    expect(find.text('Priya'), findsOneWidget);
  });
}
