import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A delightful line of text that bends under a vertical drag gesture
/// and springs back with realistic physics upon release.
///
/// Inspired by WithAnimation (https://www.withanimation.app/library/spring-text).
/// Crafted by Charu for `flutter_craft`.
/// Self-contained widget with zero external dependencies.
class SpringText extends StatefulWidget {
  /// The text string to display and animate.
  final String text;

  /// Font size for the text (clamped between 20.0 and 72.0).
  final double fontSize;

  /// Color of the text. If null, automatically uses White in Dark Mode
  /// and Black in Light Mode.
  final Color? color;

  /// Optional custom text style to apply to characters.
  final TextStyle? textStyle;

  /// Maximum vertical drag distance in points (clamped between 60.0 and 260.0).
  final double maxDrag;

  /// Intensity of the curvature arc when dragged (clamped between 0.2 and 1.0).
  final double curveStrength;

  /// Spring bounciness / damping upon release (clamped between 0.0 and 0.9).
  /// Higher values result in more oscillations.
  final double bounce;

  /// Horizontal spacing between consecutive characters in points.
  final double characterSpacing;

  /// Padding around the text to provide a comfortable hit/touch target.
  final EdgeInsetsGeometry padding;

  const SpringText(
    this.text, {
    super.key,
    this.fontSize = 40.0,
    this.color,
    this.textStyle,
    this.maxDrag = 180.0,
    this.curveStrength = 0.70,
    this.bounce = 0.70,
    this.characterSpacing = 2.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
  });

  @override
  State<SpringText> createState() => _SpringTextState();
}

class _SpringTextState extends State<SpringText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _dragY = 0.0;
  double _dragStartY = 0.0;
  double _dragStartOffset = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(
      value: 0.0,
      vsync: this,
    )..addListener(_onAnimationTick);
  }

  void _onAnimationTick() {
    setState(() {
      _dragY = _controller.value;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onAnimationTick);
    _controller.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _dragStartY = details.globalPosition.dy;
    _dragStartOffset = _dragY;
    setState(() {
      _isDragging = true;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final clampedMaxDrag = widget.maxDrag.clamp(60.0, 260.0);
    final totalDelta = details.globalPosition.dy - _dragStartY;
    final targetY = (_dragStartOffset + totalDelta).clamp(
      -clampedMaxDrag,
      clampedMaxDrag,
    );

    setState(() {
      _dragY = targetY;
      _controller.value = targetY;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });

    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      setState(() {
        _dragY = 0.0;
        _controller.value = 0.0;
      });
      return;
    }

    final clampedBounce = widget.bounce.clamp(0.0, 0.9);

    // Natural frequency calculation:
    // SwiftUI response = 0.5s -> stiffness = (2 * pi / response)^2 ~ 158.0.
    // Damping ratio = 1 - bounce.
    final simulation = SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 160.0,
        ratio: (1.0 - clampedBounce).clamp(0.05, 1.0),
      ),
      _dragY,
      0.0,
      (details.primaryVelocity ?? 0.0).clamp(-1500.0, 1500.0),
    );

    _controller.animateWith(simulation);
  }

  void _onDragCancel() {
    _onDragEnd(DragEndDetails());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor =
        widget.color ?? (isDark ? Colors.white : Colors.black);
    final clampedFontSize = widget.fontSize.clamp(20.0, 72.0);
    final clampedCurveStrength = widget.curveStrength.clamp(0.2, 1.0);

    final effectiveTextStyle = (widget.textStyle ?? const TextStyle()).copyWith(
      fontSize: clampedFontSize,
      fontWeight: widget.textStyle?.fontWeight ?? FontWeight.w900,
      color: effectiveColor,
      letterSpacing: widget.textStyle?.letterSpacing ?? -0.5,
    );

    final characters = widget.text.characters.toList();
    final count = characters.length;
    final midpoint = count > 1 ? (count - 1) / 2.0 : 0.0;

    final glyphWidgets = <Widget>[];
    for (int i = 0; i < count; i++) {
      final char = characters[i];
      final distance = i - midpoint;
      final normalized = midpoint == 0 ? 0.0 : distance / midpoint;
      final xOffset = normalized * _dragY.abs() * 0.15;
      final yOffset =
          _dragY - (normalized * normalized * _dragY * clampedCurveStrength);
      final rotationDegrees = normalized * _dragY * -0.15;
      final rotationRadians = rotationDegrees * (math.pi / 180.0);

      glyphWidgets.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.characterSpacing / 2.0,
          ),
          child: Transform.translate(
            offset: Offset(xOffset, yOffset),
            child: Transform.rotate(
              angle: rotationRadians,
              alignment: Alignment.center,
              child: Text(
                char == ' ' ? '\u00A0' : char,
                style: effectiveTextStyle,
              ),
            ),
          ),
        ),
      );
    }

    return Semantics(
      label: widget.text,
      hint: 'Drag vertically to bend the text',
      excludeSemantics: true,
      child: MouseRegion(
        cursor:
            _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragStart: _onDragStart,
          onVerticalDragUpdate: _onDragUpdate,
          onVerticalDragEnd: _onDragEnd,
          onVerticalDragCancel: _onDragCancel,
          child: Padding(
            padding: widget.padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: glyphWidgets,
            ),
          ),
        ),
      ),
    );
  }
}
