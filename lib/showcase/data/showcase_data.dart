import 'package:flutter/material.dart';
import '../../animations/pacman_loader/pacman_loader.dart';
import '../../animations/spring_text/spring_text.dart';
import '../../animations/breathing_loader/breathing_loader.dart';
import '../../animations/profile_stack/profile_stack.dart';
import '../../animations/thought_orb/thought_orb.dart';
import '../models/showcase_item.dart';

final List<ShowcaseItem> showcaseItems = [
  ShowcaseItem(
    id: 'breathing-loader',
    title: 'Breathing Loader',
    description:
        'A transparent 3D particle sphere that expands, drifts, and rotates with continuous perspective depth.',
    category: ShowcaseCategory.animations,
    tags: ['3D', 'Particles', 'Loader', 'Math', 'CustomPainter'],
    sourceFilePath: 'lib/animations/breathing_loader/breathing_loader.dart',
    previewBuilder: (context) {
      return const Center(
        child: BreathingLoader(
          sphereSize: 90,
          dotSize: 3.5,
          width: 180,
          height: 180,
        ),
      );
    },
    playgroundBuilder: (context) {
      return const Center(
        child: BreathingLoader(
          sphereSize: 140,
          breathingSpeed: 1.25,
          rotationSpeed: 0.25,
          dotSize: 4.0,
        ),
      );
    },
    codeSnippet: '''
BreathingLoader(
  sphereSize: 140,
  breathingSpeed: 1.25,
  rotationSpeed: 0.25,
  dotSize: 4.0,
  primaryColor: Color(0xFFFBBF24),
  secondaryColor: Color(0xFFFB7185),
)
''',
  ),
  ShowcaseItem(
    id: 'thought-orb',
    title: 'Thought Orb',
    description:
        'An AI status mark replicating Apple Siri wave optics with 4 equatorial ribbons, Gaussian taper envelope, and Solar Amber palette.',
    category: ShowcaseCategory.animations,
    tags: ['AI', 'Siri', 'Wave', 'Glow', 'Pill', 'CustomPainter'],
    sourceFilePath: 'lib/animations/thought_orb/thought_orb.dart',
    previewBuilder: (context) {
      return const Center(
        child: ThoughtOrb(
          size: 72,
          palette: ThoughtOrbPalette.solar,
        ),
      );
    },
    playgroundBuilder: (context) {
      return const Center(
        child: ThoughtOrbPlayground(),
      );
    },
    codeSnippet: '''
// Hero Standalone Orb
ThoughtOrb(
  size: 160,
  palette: ThoughtOrbPalette.solar,
)

// Frosted Glass Status Pill
ThoughtOrbPill(
  labels: [
    'Thinking',
    'Searching',
    'Searching sources',
    'Drafting a reply',
  ],
  orbSize: 22,
)
''',
  ),
  ShowcaseItem(
    id: 'profile-stack',
    title: 'Profile Stack',
    description:
        'An interactive avatar group that springs into a selectable horizontal fan with tactile scrubbing and floating name tags.',
    category: ShowcaseCategory.animations,
    tags: ['Gestures', 'Interactive', 'Avatars', 'Spring', 'Controls'],
    sourceFilePath: 'lib/animations/profile_stack/profile_stack.dart',
    previewBuilder: (context) {
      return const Center(
        child: ProfileStack(
          names: [
            'Priya Raman',
            'Jonas Weber',
            'Amara Diallo',
            'Leo Brandt',
            'Sofia Marin',
            'Kenji Sato',
          ],
          size: 40,
          max: 4,
        ),
      );
    },
    playgroundBuilder: (context) {
      return const Center(
        child: ProfileStack(
          names: [
            'Priya Raman',
            'Jonas Weber',
            'Amara Diallo',
            'Leo Brandt',
            'Sofia Marin',
            'Kenji Sato',
          ],
          size: 52,
          max: 4,
        ),
      );
    },
    codeSnippet: '''
ProfileStack(
  names: [
    'Priya Raman',
    'Jonas Weber',
    'Amara Diallo',
    'Leo Brandt',
    'Sofia Marin',
    'Kenji Sato',
  ],
  size: 48,
  max: 4,
  onSelect: (name) => print('Selected \$name'),
)
''',
  ),
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
          fontSize: 18,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        ),
      );
    },
    playgroundBuilder: (context) {
      return const Center(
        child: SpringText(
          'Spring Text',
          fontSize: 32,
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
  fontSize: 32,
  maxDrag: 180,
  curveStrength: 0.70,
  bounce: 0.70,
)
''',
  ),
];

class ThoughtOrbPlayground extends StatelessWidget {
  const ThoughtOrbPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hero Standalone Orb with max size in center
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
                    blurRadius: 44,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: const ThoughtOrb(
                size: 160.0,
                palette: ThoughtOrbPalette.solar,
              ),
            ),
            const SizedBox(height: 36),

            // Companion Status Pill cycling states automatically
            const ThoughtOrbPill(
              labels: [
                'Thinking',
                'Searching',
                'Searching sources',
                'Drafting a reply',
              ],
              orbSize: 22,
              palette: ThoughtOrbPalette.solar,
            ),
          ],
        ),
      ),
    );
  }
}

