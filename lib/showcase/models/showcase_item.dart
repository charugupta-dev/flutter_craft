import 'package:flutter/material.dart';

enum ShowcaseCategory {
  all('All'),
  animations('Animations'),
  buttons('Buttons'),
  components('Components'),
  shaders('Shaders');

  final String label;
  const ShowcaseCategory(this.label);
}

class ShowcaseItem {
  final String id;
  final String title;
  final String description;
  final ShowcaseCategory category;
  final List<String> tags;
  final Widget Function(BuildContext) previewBuilder;
  final Widget Function(BuildContext) playgroundBuilder;
  final String sourceFilePath;
  final String codeSnippet;

  const ShowcaseItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.previewBuilder,
    required this.playgroundBuilder,
    required this.sourceFilePath,
    required this.codeSnippet,
  });
}
