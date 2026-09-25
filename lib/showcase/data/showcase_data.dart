import 'package:flutter/material.dart';
import '../../animations/pacman_loader/pacman_loader.dart';
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
  color: Color(0xFFFACC15),
  showsPercentage: true,
)
''',
  ),
];
