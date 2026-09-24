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
          color: Color(0xFFFACC15),
          showsPercentage: false,
        ),
      );
    },
    playgroundBuilder: (context) => const _PacmanPlayground(),
    codeSnippet: '''
PacmanLoader(
  totalDuration: Duration(milliseconds: 4500),
  dotCount: 12,
  pacmanSize: 32.0,
  color: Color(0xFFFACC15),
  showsPercentage: true,
)
''',
  ),
];

class _PacmanPlayground extends StatefulWidget {
  const _PacmanPlayground();

  @override
  State<_PacmanPlayground> createState() => _PacmanPlaygroundState();
}

class _PacmanPlaygroundState extends State<_PacmanPlayground> {
  double _size = 34.0;
  double _durationSeconds = 4.5;
  int _dotCount = 12;
  bool _showsPercentage = true;
  Color _color = const Color(0xFFFACC15);

  final List<Color> _palette = const [
    Color(0xFFFACC15), // Classic Yellow
    Color(0xFF38BDF8), // Cyan
    Color(0xFFF43F5E), // Rose / Ghost Pink
    Color(0xFF10B981), // Emerald
    Color(0xFF818CF8), // Indigo
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Live Component Preview Box
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: PacmanLoader(
            key: ValueKey('$_size-$_durationSeconds-$_dotCount-$_showsPercentage-$_color'),
            pacmanSize: _size,
            dotCount: _dotCount,
            totalDuration: Duration(milliseconds: (_durationSeconds * 1000).toInt()),
            color: _color,
            showsPercentage: _showsPercentage,
          ),
        ),

        const Divider(height: 48),

        // Controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Color Picker Row
              Row(
                children: [
                  const Text('Color: ', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  ..._palette.map((c) {
                    final isSelected = _color == c;
                    return GestureDetector(
                      onTap: () => setState(() => _color = c),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                          boxShadow: isSelected
                              ? [BoxShadow(color: c.withValues(alpha: 0.5), blurRadius: 8)]
                              : null,
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Size Slider
              Row(
                children: [
                  const SizedBox(width: 80, child: Text('Size:')),
                  Expanded(
                    child: Slider(
                      value: _size,
                      min: 20,
                      max: 60,
                      onChanged: (v) => setState(() => _size = v),
                    ),
                  ),
                  Text('${_size.toInt()} pt'),
                ],
              ),

              // Duration Slider
              Row(
                children: [
                  const SizedBox(width: 80, child: Text('Duration:')),
                  Expanded(
                    child: Slider(
                      value: _durationSeconds,
                      min: 1.5,
                      max: 8.0,
                      divisions: 13,
                      onChanged: (v) => setState(() => _durationSeconds = v),
                    ),
                  ),
                  Text('${_durationSeconds.toStringAsFixed(1)}s'),
                ],
              ),

              // Dot Count Slider
              Row(
                children: [
                  const SizedBox(width: 80, child: Text('Dots:')),
                  Expanded(
                    child: Slider(
                      value: _dotCount.toDouble(),
                      min: 4,
                      max: 20,
                      divisions: 16,
                      onChanged: (v) => setState(() => _dotCount = v.toInt()),
                    ),
                  ),
                  Text('$_dotCount'),
                ],
              ),

              // Show Percentage Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Show Percentage'),
                value: _showsPercentage,
                onChanged: (v) => setState(() => _showsPercentage = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
