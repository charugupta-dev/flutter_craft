import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ThoughtOrbPalette {
  final List<Color> bands;
  final Color ground;
  final Color crest;
  final Color rimWarm;
  final Color rimCool;

  const ThoughtOrbPalette({
    required this.bands,
    required this.ground,
    required this.crest,
    required this.rimWarm,
    required this.rimCool,
  });

  static const ThoughtOrbPalette solar = ThoughtOrbPalette(
    bands: [
      Color(0xFFFBBF24),
      Color(0xFFF97316),
      Color(0xFFFB7185),
      Color(0xFFE11D48)
    ],
    ground: Color(0xFF1E0B19),
    crest: Colors.white,
    rimWarm: Color(0xFFFBBF24),
    rimCool: Color(0xFFFB7185),
  );

  static const ThoughtOrbPalette siri = ThoughtOrbPalette(
    bands: [
      Colors.cyan,
      Colors.indigo,
      Color(0xFFFF00FF),
      Colors.purple,
    ],
    ground: Color(0xFF0F0F12),
    crest: Colors.white,
    rimWarm: Colors.cyan,
    rimCool: Colors.purple,
  );

  static const ThoughtOrbPalette ocean = ThoughtOrbPalette(
    bands: [
      Colors.blueAccent,
      Colors.teal,
      Colors.blue,
      Colors.cyan,
    ],
    ground: Color(0xFF0A192F),
    crest: Colors.white,
    rimWarm: Colors.blueAccent,
    rimCool: Colors.cyan,
  );

  static const ThoughtOrbPalette emerald = ThoughtOrbPalette(
    bands: [
      Colors.greenAccent,
      Colors.green,
      Colors.lightGreen,
      Color(0xFF228B22),
    ],
    ground: Color(0xFF0A2F1D),
    crest: Colors.white,
    rimWarm: Colors.greenAccent,
    rimCool: Colors.lightGreen,
  );
}

class ThoughtOrbPainter extends CustomPainter {
  final ThoughtOrbPalette palette;
  final double animationValue;

  ThoughtOrbPainter({
    required this.palette,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = math.min(size.width, size.height) / 2 * 0.92;
    if (radius <= 0) return;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Path clipPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.save();
    canvas.clipPath(clipPath);

    // 1. Smoked Obsidian ground wash
    final Paint groundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          palette.ground,
          palette.ground.withValues(alpha: 0.85),
          const Color(0xFF090208),
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, groundPaint);

    // 2. Exact 4 Siri Wave Membranes travelling through equator
    const int kBands = 4;
    const double kSpeed = 1.311;
    const double kSeparation = 2.05;
    const double kDetune = 0.05;
    const double kAmplitude = 0.266;
    const double kFrequency = 1.45;
    const double kWidth = 0.115;
    const double kTaper = 1.75;

    final double t = animationValue * math.pi * 2 * kSpeed;
    final double drift = t * 2.4;
    const double mid = (kBands - 1) * 0.5;

    for (int i = 0; i < kBands; i++) {
      final double centred = i - mid;
      final double amp = kAmplitude *
          (1.0 - centred.abs() * kDetune * 1.1) *
          (0.82 + 0.18 * math.sin(t * 0.48 + centred * 1.1));
      final double freq = kFrequency * (1.0 + centred * kDetune);
      final double phase = drift + centred * kSeparation;
      final double bw = kWidth * (1.0 + centred.abs() * 0.55);

      final Color bandColor = palette.bands[i % palette.bands.length];

      final Path ribbonPath = Path();
      final Path spinePath = Path();
      const int steps = 60;

      final List<Offset> upperPoints = [];
      final List<Offset> lowerPoints = [];
      final List<Offset> centerPoints = [];

      for (int s = 0; s <= steps; s++) {
        final double px = (s / steps) * 2 - 1; // -1 to 1
        final double env = math.pow(math.max(0.0, 1.0 - px * px), kTaper).toDouble();
        final double wave = math.sin(px * freq * math.pi + phase);
        final double centerY = env * amp * wave;
        final double halfBw = (bw * 0.6) * env;

        final double screenX = center.dx + px * radius;
        final double upperY = center.dy - (centerY + halfBw) * radius;
        final double lowerY = center.dy - (centerY - halfBw) * radius;
        final double midY = center.dy - centerY * radius;

        upperPoints.add(Offset(screenX, upperY));
        lowerPoints.add(Offset(screenX, lowerY));
        centerPoints.add(Offset(screenX, midY));
      }

      if (upperPoints.isNotEmpty) {
        ribbonPath.moveTo(upperPoints[0].dx, upperPoints[0].dy);
        for (int k = 1; k < upperPoints.length; k++) {
          ribbonPath.lineTo(upperPoints[k].dx, upperPoints[k].dy);
        }
        for (int k = lowerPoints.length - 1; k >= 0; k--) {
          ribbonPath.lineTo(lowerPoints[k].dx, lowerPoints[k].dy);
        }
        ribbonPath.close();

        // Horizontal ribbon gradient with fade at ends
        final Paint ribbonPaint = Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              bandColor.withValues(alpha: 0.0),
              bandColor.withValues(alpha: 0.75),
              bandColor.withValues(alpha: 0.85),
              bandColor.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..blendMode = BlendMode.screen;

        canvas.drawPath(ribbonPath, ribbonPaint);

        // Center spine stroke
        spinePath.moveTo(centerPoints[0].dx, centerPoints[0].dy);
        for (int k = 1; k < centerPoints.length; k++) {
          spinePath.lineTo(centerPoints[k].dx, centerPoints[k].dy);
        }

        final Paint spinePaint = Paint()
          ..color = bandColor.withValues(alpha: 0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.2, radius * 0.04)
          ..blendMode = BlendMode.screen;

        canvas.drawPath(spinePath, spinePaint);
      }
    }

    // 3. Thin white crest on the main sine wave
    final Path crestPath = Path();
    const int crestSteps = 60;
    for (int s = 0; s <= crestSteps; s++) {
      final double px = (s / crestSteps) * 2 - 1;
      final double env = math.pow(math.max(0.0, 1.0 - px * px), kTaper).toDouble();
      final double wave = math.sin(px * kFrequency * math.pi + drift);
      final double centerY = env * kAmplitude * wave;
      final double screenX = center.dx + px * radius;
      final double screenY = center.dy - centerY * radius;

      if (s == 0) {
        crestPath.moveTo(screenX, screenY);
      } else {
        crestPath.lineTo(screenX, screenY);
      }
    }

    final Paint crestPaint = Paint()
      ..color = palette.crest.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, radius * 0.025)
      ..blendMode = BlendMode.screen;

    canvas.drawPath(crestPath, crestPaint);

    // 4. Central Luminous Core
    final Paint coreGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0x73FFFAF0),
          palette.rimWarm.withValues(alpha: 0.25),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.85))
      ..blendMode = BlendMode.screen;
    canvas.drawCircle(center, radius, coreGlow);

    // 5. Specular top-left glass reflection
    final Offset specularCenter = Offset(
      center.dx - radius * 0.35,
      center.dy - radius * 0.40,
    );
    final Paint specularPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.55),
          Colors.white.withValues(alpha: 0.15),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: specularCenter, radius: radius * 0.55));
    canvas.drawCircle(center, radius, specularPaint);

    canvas.restore();

    // 6. Luminous Glass Rim
    final Paint rimPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          palette.rimWarm,
          Colors.white.withValues(alpha: 0.7),
          palette.rimCool,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, radius * 0.045);
    canvas.drawCircle(center, radius, rimPaint);
  }

  @override
  bool shouldRepaint(ThoughtOrbPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.palette != palette;
  }
}

class ThoughtOrb extends StatefulWidget {
  final double size;
  final ThoughtOrbPalette palette;
  final double speed;
  final bool animate;

  const ThoughtOrb({
    super.key,
    this.size = 28.0,
    this.palette = ThoughtOrbPalette.solar,
    this.speed = 1.0,
    this.animate = true,
  });

  @override
  State<ThoughtOrb> createState() => _ThoughtOrbState();
}

class _ThoughtOrbState extends State<ThoughtOrb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAnimation();
  }

  @override
  void didUpdateWidget(ThoughtOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speed != widget.speed || oldWidget.animate != widget.animate) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    final bool reducedMotion = MediaQuery.maybeOf(context)?.disableAnimations == true;
    final double actualSpeed = reducedMotion ? 0.15 : widget.speed;

    if (widget.animate && actualSpeed > 0) {
      _controller.duration = Duration(milliseconds: (4000 / actualSpeed).round());
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: ThoughtOrbPainter(
              palette: widget.palette,
              animationValue: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class ThoughtOrbPill extends StatefulWidget {
  final String? label;
  final List<String>? labels;
  final Duration cycleInterval;
  final double orbSize;
  final ThoughtOrbPalette palette;
  final VoidCallback? onTap;
  final bool showDots;
  final TextStyle? labelStyle;

  const ThoughtOrbPill({
    super.key,
    this.label,
    this.labels,
    this.cycleInterval = const Duration(milliseconds: 2400),
    this.orbSize = 22.0,
    this.palette = ThoughtOrbPalette.solar,
    this.onTap,
    this.showDots = true,
    this.labelStyle,
  }) : assert(
          label != null || labels != null,
          'Either label or labels must be provided',
        );

  @override
  State<ThoughtOrbPill> createState() => _ThoughtOrbPillState();
}

class _ThoughtOrbPillState extends State<ThoughtOrbPill> {
  Timer? _timer;
  int _currentIndex = 0;

  List<String> get _effectiveLabels {
    if (widget.labels != null && widget.labels!.isNotEmpty) {
      return widget.labels!;
    }
    if (widget.label != null) {
      return [widget.label!];
    }
    return ['Thinking'];
  }

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(ThoughtOrbPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.labels != widget.labels ||
        oldWidget.label != widget.label ||
        oldWidget.cycleInterval != widget.cycleInterval) {
      _timer?.cancel();
      _currentIndex = 0;
      _startTimerIfNeeded();
    }
  }

  void _startTimerIfNeeded() {
    final labels = _effectiveLabels;
    if (labels.length > 1) {
      _timer = Timer.periodic(widget.cycleInterval, (_) {
        if (mounted) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % labels.length;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bgColor =
        isDark ? const Color(0xFF0F0F12) : const Color(0xFFEEEAE3);

    final labels = _effectiveLabels;
    final String currentText = labels[_currentIndex % labels.length];

    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ThoughtOrb(size: widget.orbSize, palette: widget.palette),
              const SizedBox(width: 9),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.22),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  currentText,
                  key: ValueKey<String>(currentText),
                  style: widget.labelStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        letterSpacing: -0.2,
                        color: isDark
                            ? const Color(0xFFF4F3EF)
                            : const Color(0xFF1E1E24),
                      ),
                ),
              ),
              if (widget.showDots) ...[
                const SizedBox(width: 6),
                const _PulsingDots(key: Key('pulsing_dots')),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _PulsingDots extends StatefulWidget {
  const _PulsingDots({super.key});

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dotColor =
        isDark ? const Color(0xFFF4F3EF) : const Color(0xFF1E1E24);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(3, (index) {
            final double phase = index * 0.20;
            final double t = (_controller.value - phase) % 1.0;
            final double normalizedT = t < 0 ? t + 1.0 : t;

            // Smooth active wave
            final double activeFactor = normalizedT <= 0.5
                ? math.sin(normalizedT * 2 * math.pi)
                : 0.0;
            final double clamped = math.max(0.0, activeFactor);

            final double dy = -2.5 * clamped;
            final double opacity = 0.30 + 0.70 * clamped;
            final double scale = 0.85 + 0.25 * clamped;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Transform.translate(
                offset: Offset(0, dy),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 3.5,
                    height: 3.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotColor.withValues(alpha: opacity),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
