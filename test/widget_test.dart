import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_craft/main.dart';
import 'package:flutter_craft/animations/pacman_loader/pacman_loader.dart';

void main() {
  testWidgets('FlutterCraftApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterCraftApp());
    expect(find.text('Flutter Craft'), findsOneWidget);
    expect(find.byType(PacmanLoader), findsWidgets);
  });
}
