import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_craft/main.dart';
import 'package:flutter_craft/animations/pacman_loader/pacman_loader.dart';
import 'package:flutter_craft/animations/spring_text/spring_text.dart';
import 'package:flutter_craft/animations/breathing_loader/breathing_loader.dart';
import 'package:flutter_craft/showcase/data/showcase_data.dart';
import 'package:flutter_craft/showcase/screens/item_detail_screen.dart';

void main() {
  testWidgets('FlutterCraftApp smoke test - verifies gallery and items',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterCraftApp());
    expect(find.text('Flutter Craft'), findsOneWidget);
    expect(find.byType(PacmanLoader), findsWidgets);
    expect(find.byType(SpringText), findsWidgets);

    // Scroll down to bring third item into view
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
    await tester.pump();
    expect(find.byType(BreathingLoader), findsWidgets);
  });

  testWidgets(
      'ItemDetailScreen displays clean view with Flutter Craft brand and corner buttons',
      (WidgetTester tester) async {
    final springItem = showcaseItems.firstWhere((i) => i.id == 'spring-text');
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFEEEAE3),
        ),
        home: ItemDetailScreen(
          item: springItem,
          onToggleTheme: () {},
        ),
      ),
    );

    // No item title in the AppBar center
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.title, isNull);

    // Leading corner has back button
    expect(find.byTooltip('Back'), findsOneWidget);

    // Trailing corner has theme toggle button
    expect(find.byTooltip('Toggle Theme'), findsOneWidget);

    // No Flutter Craft text on detail screen (distraction-free)
    expect(find.text('Flutter Craft'), findsNothing);

    // Centered animation is present
    expect(find.byType(SpringText), findsOneWidget);
  });

  testWidgets('BreathingLoader renders and animates 3D particles',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: BreathingLoader(
              sphereSize: 100,
              dotSize: 4.0,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(BreathingLoader), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    await tester.pump(const Duration(milliseconds: 500));
  });

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

  testWidgets('SpringText renders characters and responds to drag gesture',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SpringText(
              'Spring Text',
              fontSize: 32,
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
