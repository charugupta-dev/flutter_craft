import 'package:flutter/material.dart';
import '../models/showcase_item.dart';

class ItemDetailScreen extends StatelessWidget {
  final ShowcaseItem item;
  final VoidCallback onToggleTheme;

  const ItemDetailScreen({
    super.key,
    required this.item,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: item.playgroundBuilder(context),
      ),
    );
  }
}
