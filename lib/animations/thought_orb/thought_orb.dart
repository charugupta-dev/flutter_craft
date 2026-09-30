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
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Path clipPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.save();
    canvas.clipPath(clipPath);

    final Paint groundPaint = Paint()
      ..shader = RadialGradient(
        colors: [palette.ground, const Color(0xFF090208)],
        radius: 1.0,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, groundPaint);

    const int kBands = 4;
    const double kSeparation = 2.05;
    const double kDetune = 0.05;
    const double kAmplitude = 0.266;
    const double kFrequency = 1.45;
    const double kWidth = 0.115;
    const double kTaper = 1.75;

    for (int i = 0; i < kBands; i++) {
      final Color bandColor = palette.bands[i % palette.bands.length];
      
      final Paint bandPaint = Paint()
        ..color = bandColor.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.height * kWidth
        ..blendMode = BlendMode.screen;

      final Path bandPath = Path();
      
      final double width = size.width;
      final double height = size.height;

      const int steps = 100;
      for (int x = 0; x <= steps; x++) {
        final double normalizedX = (x / steps) * 2 - 1; 
        
        // Envelope (1 - x^2)^1.75 pinching waves at the boundary
        final double envelope = math.pow(math.max(0, 1 - normalizedX * normalizedX), kTaper).toDouble();
        
        final double phaseOffset = (i * kSeparation) + (animationValue * math.pi * 2);
        final double detuneOffset = i * kDetune;
        
        final double wave = math.sin((normalizedX * kFrequency * math.pi * 2) + phaseOffset + detuneOffset);
        
        final double y = wave * envelope * kAmplitude * height;
        
        final double screenX = center.dx + (normalizedX * width / 2);
        final double screenY = center.dy + y;

        if (x == 0) {
          bandPath.moveTo(screenX, screenY);
        } else {
          bandPath.lineTo(screenX, screenY);
        }
      }
      
      canvas.drawPath(bandPath, bandPaint);

      if (i == 0) {
        final Paint crestPaint = Paint()
          ..color = palette.crest.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..blendMode = BlendMode.screen;
        canvas.drawPath(bandPath, crestPaint);
      }
    }

    final Paint glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0x66FFFAEB), Colors.transparent],
        radius: 0.6,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..blendMode = BlendMode.screen;
    canvas.drawCircle(center, radius, glowPaint);

    final Paint specularPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withValues(alpha: 0.3), Colors.transparent],
        stops: const [0.0, 0.4],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, specularPaint);

    canvas.restore();

    final Paint rimPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [palette.rimWarm, palette.rimCool],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
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

class ThoughtOrbPill extends StatelessWidget {
  final String label;
  final double orbSize;
  final ThoughtOrbPalette palette;
  final VoidCallback? onTap;
  final bool showDots;
  final TextStyle? labelStyle;

  const ThoughtOrbPill({
    super.key,
    required this.label,
    this.orbSize = 22.0,
    this.palette = ThoughtOrbPalette.solar,
    this.onTap,
    this.showDots = true,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    
    final Color bgColor = isDark ? const Color(0xFF0F0F12) : const Color(0xFFEEEAE3);

    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ThoughtOrb(size: orbSize, palette: palette),
              const SizedBox(width: 8),
              Text(
                label,
                style: labelStyle ?? theme.textTheme.bodyMedium,
              ),
              if (showDots) ...[
                const SizedBox(width: 8),
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

class _PulsingDotsState extends State<_PulsingDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (index) {
            final double phase = (index * 0.15) / 1.5;
            double value = (_controller.value - phase) % 1.0;
            if (value < 0) value += 1.0;
            
            final double opacity = 0.3 + 0.7 * (1.0 - (value * 2 - 1).abs());
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).iconTheme.color?.withValues(alpha: opacity) ?? Colors.black.withValues(alpha: opacity),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
