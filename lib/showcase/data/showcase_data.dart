import 'package:flutter/material.dart';
import '../../animations/pacman_loader/pacman_loader.dart';
import '../../animations/spring_text/spring_text.dart';
import '../../animations/breathing_loader/breathing_loader.dart';
import '../../animations/fan_stack/fan_stack.dart';
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
    id: 'fan-stack',
    title: 'Fan Stack',
    description:
        'An interactive avatar group that springs into a selectable horizontal fan with tactile scrubbing and floating name tags.',
    category: ShowcaseCategory.animations,
    tags: ['Gestures', 'Interactive', 'Avatars', 'Spring', 'Controls'],
    sourceFilePath: 'lib/animations/fan_stack/fan_stack.dart',
    previewBuilder: (context) {
      return const Center(
        child: FanStack(
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
    playgroundBuilder: (context) => const _FanStackPlayground(),
    codeSnippet: '''
FanStack(
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

class _FanStackPlayground extends StatefulWidget {
  const _FanStackPlayground();

  @override
  State<_FanStackPlayground> createState() => _FanStackPlaygroundState();
}

class _FanStackPlaygroundState extends State<_FanStackPlayground> {
  String? _selectedName;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FanStack(
            names: const [
              'Priya Raman',
              'Jonas Weber',
              'Amara Diallo',
              'Leo Brandt',
              'Sofia Marin',
              'Kenji Sato',
            ],
            size: 52,
            max: 4,
            onSelect: (name) {
              setState(() {
                _selectedName = name;
              });
            },
          ),
          const SizedBox(height: 36),
          AnimatedOpacity(
            opacity: _selectedName != null ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF262626)
                    : const Color(0xFFE0DDD5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _selectedName != null ? 'Selected: $_selectedName' : '',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                  color: isDark
                      ? const Color(0xFFF4F3EF)
                      : const Color(0xFF1E1E24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
