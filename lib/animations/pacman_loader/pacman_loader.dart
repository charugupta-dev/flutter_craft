import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A delightful Pacman loader where Pacman munches dots across a track with live progress.
///
/// Crafted by Charu for `flutter_craft`.
/// Self-contained widget with zero external dependencies.
class PacmanLoader extends StatefulWidget {
  final Duration totalDuration;
  final int dotCount;
  final double pacmanSize;
  final Color? color;
  final bool showsPercentage;

  const PacmanLoader({
    super.key,
    this.totalDuration = const Duration(milliseconds: 4500),
    this.dotCount = 12,
    this.pacmanSize = 32.0,
    this.color,
    this.showsPercentage = true,
  });

  @override
  State<PacmanLoader> createState() => _PacmanLoaderState();
}

class _PacmanLoaderState extends State<PacmanLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _controller = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    )..repeat();
  }

  @override
  void didUpdateWidget(PacmanLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalDuration != widget.totalDuration) {
      _controller.duration = widget.totalDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor =
        widget.color ?? (isDark ? Colors.white : Colors.black);
    final dotCount = math.max(2, widget.dotCount);
    final pacmanSize = math.max(8.0, widget.pacmanSize);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _controller.value;
        final time = _stopwatch.elapsedMicroseconds / 1000000.0;
        final percentage = (progress * 100).toInt();

        return Semantics(
          label: 'Loading',
          value: '$percentage percent',
          excludeSemantics: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PacmanTrack(
                progress: progress,
                time: time,
                dotCount: dotCount,
                pacmanSize: pacmanSize,
                color: effectiveColor,
              ),
              if (widget.showsPercentage) ...[
                const SizedBox(height: 28),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: effectiveColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PacmanTrack extends StatelessWidget {
  final double progress;
  final double time;
  final int dotCount;
  final double pacmanSize;
  final Color color;

  const _PacmanTrack({
    required this.progress,
    required this.time,
    required this.dotCount,
    required this.pacmanSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final usableWidth = math.max(0.0, totalWidth - pacmanSize);
        final offset = usableWidth * progress.clamp(0.0, 1.0);

        return SizedBox(
          height: pacmanSize,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Dots track
              Padding(
                padding: EdgeInsets.symmetric(horizontal: pacmanSize / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dotCount, (index) {
                    final threshold =
                        dotCount > 1 ? index / (dotCount - 1) : 0.0;
                    final isEaten = progress >= threshold;

                    return AnimatedScale(
                      scale: isEaten ? 0.01 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOut,
                      child: AnimatedOpacity(
                        opacity: isEaten ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Animated Pacman
              Positioned(
                left: offset,
                child: SizedBox(
                  width: pacmanSize,
                  height: pacmanSize,
                  child: CustomPaint(
                    painter: _PacmanPainter(
                      time: time,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PacmanPainter extends CustomPainter {
  final double time;
  final Color color;

  _PacmanPainter({
    required this.time,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Mouth angle oscillates between ~2 deg and ~60 deg
    final mouthAngleDeg = 31.0 + 29.0 * math.sin(time * 14.0);
    final halfMouthRad = (mouthAngleDeg / 2.0) * (math.pi / 180.0);
    final sweepAngleRad = (2.0 * math.pi) - (2.0 * halfMouthRad);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw Pacman facing right with open/close wedge
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      halfMouthRad,
      sweepAngleRad,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _PacmanPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.color != color;
  }
}
