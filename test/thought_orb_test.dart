import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_craft/animations/thought_orb/thought_orb.dart';

void main() {
  testWidgets('ThoughtOrb renders standalone at given sizes', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: ThoughtOrb(size: 28.0))));
    expect(find.byType(ThoughtOrb), findsOneWidget);
    final Size size28 = tester.getSize(find.byType(ThoughtOrb));
    expect(size28, const Size(28.0, 28.0));

    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: ThoughtOrb(size: 64.0))));
    final Size size64 = tester.getSize(find.byType(ThoughtOrb));
    expect(size64, const Size(64.0, 64.0));

    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: ThoughtOrb(size: 96.0))));
    final Size size96 = tester.getSize(find.byType(ThoughtOrb));
    expect(size96, const Size(96.0, 96.0));
  });

  testWidgets('ThoughtOrb CustomPaint uses ThoughtOrbPainter with configured palette', (WidgetTester tester) async {
    const palette = ThoughtOrbPalette.solar;
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: ThoughtOrb(palette: palette))));
    
    final customPaint = tester.widget<CustomPaint>(find.descendant(
      of: find.byType(ThoughtOrb),
      matching: find.byType(CustomPaint),
    ).first);
    
    expect(customPaint.painter, isA<ThoughtOrbPainter>());
    final painter = customPaint.painter as ThoughtOrbPainter;
    expect(painter.palette, equals(palette));
  });

  testWidgets('ThoughtOrbPill renders orb, label text, and 3 loading dots', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: ThoughtOrbPill(label: 'Thinking...'))));
    
    expect(find.byType(ThoughtOrb), findsOneWidget);
    expect(find.text('Thinking...'), findsOneWidget);
    
    expect(find.byKey(const Key('pulsing_dots')), findsOneWidget);
  });

  testWidgets('ThoughtOrbPill cycles through multiple labels over time', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ThoughtOrbPill(
            labels: ['Thinking', 'Searching', 'Searching sources', 'Drafting a reply'],
            cycleInterval: Duration(milliseconds: 1000),
          ),
        ),
      ),
    );

    expect(find.text('Thinking'), findsOneWidget);
    expect(find.text('Searching'), findsNothing);

    // Fast-forward past one cycle interval
    await tester.pump(const Duration(milliseconds: 1050));
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Searching'), findsOneWidget);
  });

  testWidgets('ThoughtOrbPill triggers onTap callback when pressed', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ThoughtOrbPill(
      label: 'Tap Me',
      onTap: () => tapped = true,
    ))));
    
    await tester.tap(find.byType(ThoughtOrbPill));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('ThoughtOrbPill adapts background and ink tokens across light and dark themes', (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: Theme(
        data: ThemeData.light(),
        child: const ThoughtOrbPill(label: 'Theme'),
      ),
    ));
    final lightMaterial = tester.widget<Material>(find.descendant(of: find.byType(ThoughtOrbPill), matching: find.byType(Material)).first);
    expect(lightMaterial.color, equals(const Color(0xFFEEEAE3)));

    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: Theme(
        data: ThemeData.dark(),
        child: const ThoughtOrbPill(key: Key('dark'), label: 'Theme'),
      ),
    ));
    final darkMaterial = tester.widget<Material>(find.descendant(of: find.byType(ThoughtOrbPill), matching: find.byType(Material)).first);
    expect(darkMaterial.color, equals(const Color(0xFF0F0F12)));
  });

  testWidgets('ThoughtOrb handles reduced motion without crashing or errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: Scaffold(body: ThoughtOrb()),
      ),
    ));
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
  });
}
