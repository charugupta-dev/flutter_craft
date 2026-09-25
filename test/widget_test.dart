import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_craft/main.dart';
import 'package:flutter_craft/animations/pacman_loader/pacman_loader.dart';
import 'package:flutter_craft/animations/spring_text/spring_text.dart';

void main() {
  testWidgets('FlutterCraftApp smoke test - verifies gallery and items',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterCraftApp());
    expect(find.text('Flutter Craft'), findsOneWidget);
    expect(find.byType(PacmanLoader), findsWidgets);
    expect(find.byType(SpringText), findsWidgets);
  });

  testWidgets('SpringText renders characters and responds to drag gesture',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SpringText(
              'Spring Text',
              fontSize: 36,
            ),
          ),
        ),
      ),
    );

    // Characters should be rendered
    expect(find.text('S'), findsOneWidget);
    expect(find.text('T'), findsOneWidget);

    // Perform vertical drag gesture
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(SpringText)),
    );
    await gesture.moveBy(const Offset(0, 80));
    await tester.pump();

    // Release drag and verify spring physics settles back
    await gesture.up();
    await tester.pump();
    await tester.pumpAndSettle();
  });

  testWidgets('SpringText adapts color to Dark and Light mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: const Scaffold(
            body: SpringText('Hi'),
          ),
        ),
      ),
    );

    final darkText = tester.widget<Text>(find.text('H'));
    expect(darkText.style?.color, Colors.white);

    await tester.pumpWidget(
      MaterialApp(
        home: Theme(
          data: ThemeData(brightness: Brightness.light),
          child: const Scaffold(
            body: SpringText('Hi'),
          ),
        ),
      ),
    );

    final lightText = tester.widget<Text>(find.text('H'));
    expect(lightText.style?.color, Colors.black);
  });
}
