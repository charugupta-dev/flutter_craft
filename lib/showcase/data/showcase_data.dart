import 'package:flutter/material.dart';
import '../../animations/pacman_loader/pacman_loader.dart';
import '../../animations/spring_text/spring_text.dart';
import '../models/showcase_item.dart';

final List<ShowcaseItem> showcaseItems = [
  ShowcaseItem(
    id: 'pacman-loader',
    title: 'Pacman Loader',
    description:
        'A retro-inspired loader where Pacman munches dots across a track with live progress percentage.',
    category: ShowcaseCategory.animations,
    tags: ['Animation', 'Loader', 'Retro', 'CustomPainter'],
    sourceFilePath: 'lib/animations/pacman_loader/pacman_loader.dart',
    previewBuilder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: const PacmanLoader(
          pacmanSize: 26,
          dotCount: 8,
          totalDuration: Duration(seconds: 4),
          showsPercentage: false,
        ),
      );
    },
    playgroundBuilder: (context) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: PacmanLoader(
            pacmanSize: 34.0,
            dotCount: 12,
            totalDuration: Duration(milliseconds: 4500),
            showsPercentage: true,
          ),
        ),
      );
    },
    codeSnippet: '''
PacmanLoader(
  totalDuration: Duration(milliseconds: 4500),
  dotCount: 12,
  pacmanSize: 34.0,
  showsPercentage: true,
)
''',
  ),
  ShowcaseItem(
    id: 'spring-text',
    title: 'Spring Text',
    description:
        'A line of text that bends under a vertical drag and springs back on release.',
    category: ShowcaseCategory.animations,
    tags: ['Gestures', 'Spring', 'Interactive', 'Physics', 'Text'],
    sourceFilePath: 'lib/animations/spring_text/spring_text.dart',
    previewBuilder: (context) {
      return const Center(
        child: SpringText(
          'Spring Text',
          fontSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        ),
      );
    },
    playgroundBuilder: (context) {
      return const Center(
        child: SpringText(
          'Spring Text',
          fontSize: 42,
          maxDrag: 180,
          curveStrength: 0.70,
          bounce: 0.70,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 140),
        ),
      );
    },
    codeSnippet: '''
SpringText(
  'Spring Text',
  fontSize: 42,
  maxDrag: 180,
  curveStrength: 0.70,
  bounce: 0.70,
)
''',
  ),
];
