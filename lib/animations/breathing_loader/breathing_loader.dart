import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A transparent particle sphere that expands, drifts, and rotates in three dimensions.
///
/// Self-contained widget with zero external dependencies.
class BreathingLoader extends StatefulWidget {
  /// Authored diameter of the particle sphere (clamped between 80.0 and 200.0).
  final double sphereSize;

  /// Speed multiplier for the periodic breathing contraction/expansion (clamped between 0.5 and 2.5).
  final double breathingSpeed;

  /// Speed multiplier for the Y-axis rotation (clamped between 0.0 and 1.0).
  final double rotationSpeed;

  /// Base diameter of each particle in points (clamped between 3.0 and 14.0).
  final double dotSize;

  /// Primary color used for alternating particles (defaults to Solar Amber).
  final Color? primaryColor;

  /// Secondary color used for alternating particles (defaults to Coral Rose).
  final Color? secondaryColor;

  /// Whether the animation is currently active.
  final bool isAnimating;

  /// Optional fixed width for the widget.
  final double? width;

  /// Optional fixed height for the widget.
  final double? height;

  const BreathingLoader({
    super.key,
    this.sphereSize = 140.0,
    this.breathingSpeed = 1.25,
    this.rotationSpeed = 0.25,
    this.dotSize = 4.0,
    this.primaryColor,
    this.secondaryColor,
    this.isAnimating = true,
    this.width,
    this.height,
  });

  @override
  State<BreathingLoader> createState() => _BreathingLoaderState();
}

class _BreathingLoaderState extends State<BreathingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Stopwatch _stopwatch;
  static final List<_BreathingParticle> _particles =
      _BreathingParticle.makeCloud(170);

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(BreathingLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _stopwatch.start();
        _controller.repeat();
      } else {
        _controller.stop();
        _stopwatch.stop();
      }
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
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultPrimary = isDark
        ? const Color(0xFFFBBF24) // Golden Amber 400
        : const Color(0xFFD97706); // Sunset Amber 600

    final defaultSecondary = isDark
        ? const Color(0xFFFB7185) // Coral Rose 400
        : const Color(0xFFE11D48); // Deep Rose 600

    final effectivePrimary = widget.primaryColor ?? defaultPrimary;
    final effectiveSecondary = widget.secondaryColor ?? defaultSecondary;

    final sphereSize =
        (widget.sphereSize.isFinite ? widget.sphereSize : 140.0)
            .clamp(80.0, 200.0);
    final breathingSpeed =
        (widget.breathingSpeed.isFinite ? widget.breathingSpeed : 1.25)
            .clamp(0.5, 2.5);
    final rotationSpeed =
        (widget.rotationSpeed.isFinite ? widget.rotationSpeed : 0.25)
            .clamp(0.0, 1.0);
    final dotSize =
        (widget.dotSize.isFinite ? widget.dotSize : 4.0).clamp(3.0, 14.0);

    final authoredDiameter = (sphereSize + 30.0 + dotSize) * 2.0;

    return Semantics(
      label: 'Loading',
      excludeSemantics: true,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final elapsed =
              reduceMotion ? 0.0 : (_stopwatch.elapsedMicroseconds / 1000000.0);

          return CustomPaint(
            size: Size(
              widget.width ?? authoredDiameter,
              widget.height ?? authoredDiameter,
            ),
            painter: _BreathingPainter(
              elapsed: elapsed,
              sphereSize: sphereSize,
              breathingSpeed: breathingSpeed,
              rotationSpeed: rotationSpeed,
              dotSize: dotSize,
              primaryColor: effectivePrimary,
              secondaryColor: effectiveSecondary,
              particles: _particles,
            ),
          );
        },
      ),
    );
  }
}

class _BreathingPainter extends CustomPainter {
  final double elapsed;
  final double sphereSize;
  final double breathingSpeed;
  final double rotationSpeed;
  final double dotSize;
  final Color primaryColor;
  final Color secondaryColor;
  final List<_BreathingParticle> particles;

  _BreathingPainter({
    required this.elapsed,
    required this.sphereSize,
    required this.breathingSpeed,
    required this.rotationSpeed,
    required this.dotSize,
    required this.primaryColor,
    required this.secondaryColor,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final authoredDiameter = (sphereSize + 30.0 + dotSize) * 2.0;
    final fitScale = math.min(
      1.0,
      math.min(size.width, size.height) / authoredDiameter,
    );
    final center = Offset(size.width / 2.0, size.height / 2.0);

    final time = math.max(0.0, elapsed);
    final maximumRadius = sphereSize;
    final breath = (math.sin(time * breathingSpeed) + 1.0) / 2.0;
    final currentRadius =
        maximumRadius * (80.0 / 140.0 + (60.0 / 140.0) * breath);
    final turbulence = 30.0 * breath;
    const focalLength = 400.0;
    final expansionBonus = 4.0 * breath;

    final rendered = <_RenderParticle>[];

    final cosY = math.cos(time * rotationSpeed);
    final sinY = math.sin(time * rotationSpeed);
    final cosX = math.cos(time * 0.2);
    final sinX = math.sin(time * 0.2);

    for (final particle in particles) {
      final px = particle.basePosition.x * currentRadius +
          math.sin(time * 3.0 + particle.phase) * turbulence;
      final py = particle.basePosition.y * currentRadius +
          math.cos(time * 4.0 + particle.phase) * turbulence;
      final pz = particle.basePosition.z * currentRadius +
          math.sin(time * 5.0 + particle.phase) * turbulence;

      // Rotate Y
      final ryX = px * cosY + pz * sinY;
      final ryY = py;
      final ryZ = -px * sinY + pz * cosY;

      // Rotate X
      final rxX = ryX;
      final rxY = ryY * cosX - ryZ * sinX;
      final rxZ = ryY * sinX + ryZ * cosX;

      final depthScale = focalLength / math.max(focalLength + rxZ, 1.0);
      final rearOpacity = 0.5 +
          0.5 * ((rxZ + maximumRadius) / (maximumRadius * 2.0));
      final opacity = rxZ < 0.0 ? rearOpacity.clamp(0.0, 1.0) : 1.0;

      rendered.add(
        _RenderParticle(
          id: particle.id,
          x: rxX * depthScale,
          y: rxY * depthScale,
          z: rxZ,
          size: (dotSize + expansionBonus) * depthScale,
          opacity: opacity,
          colorIndex: particle.colorIndex,
        ),
      );
    }

    // Sort back-to-front (Z ascending)
    rendered.sort((a, b) {
      if (a.z == b.z) {
        return a.id.compareTo(b.id);
      }
      return a.z.compareTo(b.z);
    });

    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in rendered) {
      final visualSize = p.size * fitScale;
      final baseColor = p.colorIndex == 0 ? primaryColor : secondaryColor;
      paint.color = baseColor.withValues(alpha: p.opacity);

      canvas.drawCircle(
        center + Offset(p.x * fitScale, p.y * fitScale),
        visualSize / 2.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BreathingPainter oldDelegate) {
    return oldDelegate.elapsed != elapsed ||
        oldDelegate.sphereSize != sphereSize ||
        oldDelegate.breathingSpeed != breathingSpeed ||
        oldDelegate.rotationSpeed != rotationSpeed ||
        oldDelegate.dotSize != dotSize ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}

class _BreathingVector {
  final double x;
  final double y;
  final double z;

  const _BreathingVector(this.x, this.y, this.z);
}

class _BreathingParticle {
  final int id;
  final _BreathingVector basePosition;
  final double phase;
  final int colorIndex;

  const _BreathingParticle({
    required this.id,
    required this.basePosition,
    required this.phase,
    required this.colorIndex,
  });

  static List<_BreathingParticle> makeCloud(int count) {
    final safeCount = math.max(2, count);
    final goldenAngle = math.pi * (3.0 - math.sqrt(5.0));

    return List.generate(safeCount, (index) {
      final y = 1.0 - (index / (safeCount - 1)) * 2.0;
      final horizontalRadius = math.sqrt(math.max(0.0, 1.0 - y * y));
      final theta = goldenAngle * index;

      int hash = (index + 1) & 0xFFFFFFFF;
      hash = (hash ^ (hash >> 16)) & 0xFFFFFFFF;
      hash = (hash * 0x7FEB352D) & 0xFFFFFFFF;
      hash = (hash ^ (hash >> 15)) & 0xFFFFFFFF;
      hash = (hash * 0x846CA68B) & 0xFFFFFFFF;
      hash = (hash ^ (hash >> 16)) & 0xFFFFFFFF;
      final phase = (hash / 0xFFFFFFFF) * 10.0;

      return _BreathingParticle(
        id: index,
        basePosition: _BreathingVector(
          math.cos(theta) * horizontalRadius,
          y,
          math.sin(theta) * horizontalRadius,
        ),
        phase: phase,
        colorIndex: index % 2,
      );
    });
  }
}

class _RenderParticle {
  final int id;
  final double x;
  final double y;
  final double z;
  final double size;
  final double opacity;
  final int colorIndex;

  const _RenderParticle({
    required this.id,
    required this.x,
    required this.y,
    required this.z,
    required this.size,
    required this.opacity,
    required this.colorIndex,
  });
}
