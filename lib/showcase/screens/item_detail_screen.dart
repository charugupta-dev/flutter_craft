import 'package:flutter/material.dart';
import '../models/showcase_item.dart';

class ItemDetailScreen extends StatelessWidget {
  final ShowcaseItem item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: item.playgroundBuilder(context),
      ),
    );
  }
}
