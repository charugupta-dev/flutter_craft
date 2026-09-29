import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Style configuration for [ProfileStack].
///
/// Provides default Studio Ceramic palette and adaptive environment tokens
/// for light and dark themes.
class ProfileStackStyle {
  /// Palette used to deterministically tint avatar initials tiles.
  final List<Color> colors;

  /// Typography ink color for initials.
  final Color ink;

  /// Background color of the cut-out ring bordering each avatar.
  /// When null, defaults to canvas tone (#EEEAE3 light, #0F0F12 dark).
  final Color? ring;

  /// Fill color for the +N overflow pill badge.
  final Color? overflowFill;

  /// Ink color for the +N overflow pill text.
  final Color? overflowInk;

  /// Text color for the first-name captions rendered below fanned avatars.
  final Color? caption;

  /// Background fill for the floating full-name capsule tag.
  final Color? tagFill;

  /// Text ink for the floating full-name capsule tag.
  final Color? tagInk;

  const ProfileStackStyle({
    this.colors = const [
      Color(0xFFE06D53), // Terracotta Rust
      Color(0xFF5E9CAE), // Aegean Slate Blue
      Color(0xFFDDA15E), // Ochre Gold
      Color(0xFF7FA99B), // Celadon Jade
      Color(0xFF9B7E9F), // Heather Plum
      Color(0xFFE6CCB2), // Warm Bisque
    ],
    this.ink = const Color(0xFF1E1E24),
    this.ring,
    this.overflowFill,
    this.overflowInk,
    this.caption,
    this.tagFill,
    this.tagInk,
  });

  static const studioCeramic = ProfileStackStyle();

  /// Resolves style tokens against the current [BuildContext] theme brightness.
  ProfileStackResolvedStyle resolve(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark ||
        theme.colorScheme.brightness == Brightness.dark;
    return ProfileStackResolvedStyle(
      colors: colors,
      ink: ink,
      ring: ring ?? (isDark ? const Color(0xFF0F0F12) : const Color(0xFFEEEAE3)),
      overflowFill: overflowFill ??
          (isDark ? const Color(0xFF262626) : const Color(0xFFE0DDD5)),
      overflowInk: overflowInk ??
          (isDark ? const Color(0xFFF4F3EF) : const Color(0xFF141414)),
      caption: caption ??
          (isDark ? const Color(0xFFA6A49F) : const Color(0xFF6B6862)),
      tagFill: tagFill ??
          (isDark ? const Color(0xFFF4F3EF) : const Color(0xFF141414)),
      tagInk: tagInk ??
          (isDark ? const Color(0xFF141414) : const Color(0xFFF4F3EF)),
    );
  }
}

/// Resolved concrete colors for rendering [ProfileStack].
class ProfileStackResolvedStyle {
  final List<Color> colors;
  final Color ink;
  final Color ring;
  final Color overflowFill;
  final Color overflowInk;
  final Color caption;
  final Color tagFill;
  final Color tagInk;

  const ProfileStackResolvedStyle({
    required this.colors,
    required this.ink,
    required this.ring,
    required this.overflowFill,
    required this.overflowInk,
    required this.caption,
    required this.tagFill,
    required this.tagInk,
  });
}

/// An interactive avatar group control inspired by tactile iOS patterns.
///
/// In its collapsed state, avatars overlap with cut-out borders and an overflow
/// badge. When tapped or held, avatars fan open with staggered spring physics,
/// allowing live scrubbing, floating capsule name inspection, and selection.
class ProfileStack extends StatefulWidget {
  /// List of person names to display in the avatar group.
  final List<String> names;

  /// Optional list of image providers corresponding to [names].
  final List<ImageProvider?>? images;

  /// Avatar circle diameter in logical pixels. Defaults to 48.0.
  final double size;

  /// Maximum number of avatars shown before displaying the +N overflow badge.
  final int max;

  /// Fractional overlap in collapsed state (e.g. 0.25 = 25% overlap).
  final double overlap;

  /// Callback triggered when an avatar is tapped or released after scrubbing.
  final ValueChanged<String>? onSelect;

  /// Optional controlled expanded/collapsed state.
  final bool? isFanned;

  /// Callback fired when the fan expansion state changes.
  final ValueChanged<bool>? onFannedChanged;

  /// Visual styling configuration.
  final ProfileStackStyle? style;

  const ProfileStack({
    super.key,
    required this.names,
    this.images,
    this.size = 48.0,
    this.max = 4,
    this.overlap = 0.25,
    this.onSelect,
    this.isFanned,
    this.onFannedChanged,
    this.style,
  });

  @override
  State<ProfileStack> createState() => _ProfileStackState();
}

class _ProfileStackState extends State<ProfileStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _internalIsFanned = false;
  bool _targetFanned = false;
  int? _hoveredIndex;
  Timer? _holdTimer;
  bool _isScrubbing = false;
  Offset _downPosition = Offset.zero;

  static const double _avatarTop = 38.0;

  bool get _isFanned => widget.isFanned ?? _internalIsFanned;
  double get _collapsedStep => widget.size * (1.0 - widget.overlap);
  double get _fannedStep => widget.size + 14.0;

  @override
  void initState() {
    super.initState();
    final initialFanned = widget.isFanned ?? false;
    _internalIsFanned = initialFanned;
    _targetFanned = initialFanned;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 450),
      value: initialFanned ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(ProfileStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFanned != null && widget.isFanned != oldWidget.isFanned) {
      if (widget.isFanned!) {
        _openFan();
      } else {
        _closeFan();
      }
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _openFan() {
    _targetFanned = true;
    if (widget.isFanned == null) {
      _internalIsFanned = true;
    }
    _controller.forward();
    widget.onFannedChanged?.call(true);
  }

  void _closeFan() {
    _targetFanned = false;
    if (widget.isFanned == null) {
      _internalIsFanned = false;
    }
    _controller.reverse();
    if (_hoveredIndex != null) {
      setState(() => _hoveredIndex = null);
    }
    widget.onFannedChanged?.call(false);
  }

  void _hapticClick() {
    try {
      HapticFeedback.selectionClick();
    } catch (_) {}
  }

  void _hapticImpact() {
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  static int _fnv1a32(String text) {
    var hash = 0x811C9DC5;
    for (final unit in text.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  static Color _colorForName(String name, List<Color> colors) {
    if (colors.isEmpty) return const Color(0xFFE06D53);
    final hash = _fnv1a32(name);
    return colors[hash % colors.length];
  }

  static String _extractInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts =
        trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (trimmed.length >= 2) {
      return trimmed.substring(0, 2).toUpperCase();
    }
    return trimmed.toUpperCase();
  }

  static String _extractFirstName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';
    final parts =
        trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    return parts.isEmpty ? '' : parts.first;
  }

  int? _avatarIndexAt(Offset localPosition, int count) {
    if (count == 0) return null;
    final y = localPosition.dy;
    if (y < -50 || y > (_avatarTop + widget.size + 70)) return null;

    final x = localPosition.dx;
    if (x < -16 || x > (count * _fannedStep) + 24) return null;

    int idx = (x / _fannedStep).floor();
    if (idx < 0) idx = 0;
    if (idx >= count) idx = count - 1;
    return idx;
  }

  void _onPointerDown(PointerDownEvent event) {
    _downPosition = event.localPosition;
    _isScrubbing = false;
    _holdTimer?.cancel();

    _holdTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _isScrubbing = true;
      if (!_isFanned) {
        _openFan();
      }
      final idx = _avatarIndexAt(event.localPosition, widget.names.length);
      if (idx != null) {
        if (_hoveredIndex != idx) {
          setState(() => _hoveredIndex = idx);
          _hapticClick();
        }
      }
    });
  }

  void _onPointerMove(PointerMoveEvent event) {
    final distance = (event.localPosition - _downPosition).distance;
    if (distance > 10.0) {
      _holdTimer?.cancel();
      if (!_isScrubbing) {
        _isScrubbing = true;
        if (!_isFanned) {
          _openFan();
        }
      }
    }

    if (_isScrubbing || _isFanned) {
      final idx = _avatarIndexAt(event.localPosition, widget.names.length);
      if (idx != _hoveredIndex) {
        setState(() => _hoveredIndex = idx);
        if (idx != null) {
          _hapticClick();
        }
      }
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _holdTimer?.cancel();

    if (_isScrubbing) {
      final idx = _avatarIndexAt(event.localPosition, widget.names.length);
      if (idx != null && idx < widget.names.length) {
        _hapticImpact();
        widget.onSelect?.call(widget.names[idx]);
      }
      _closeFan();
      _isScrubbing = false;
    } else {
      if (!_isFanned) {
        _openFan();
      } else {
        final idx = _avatarIndexAt(event.localPosition, widget.names.length);
        if (idx != null && idx < widget.names.length) {
          _hapticImpact();
          widget.onSelect?.call(widget.names[idx]);
          _closeFan();
        } else {
          _closeFan();
        }
      }
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _holdTimer?.cancel();
    _isScrubbing = false;
    if (_hoveredIndex != null) {
      setState(() => _hoveredIndex = null);
    }
  }

  void _onMouseHover(PointerHoverEvent event) {
    if (!_isFanned || _controller.value < 0.5) return;
    final idx = _avatarIndexAt(event.localPosition, widget.names.length);
    if (idx != _hoveredIndex) {
      setState(() => _hoveredIndex = idx);
      if (idx != null) {
        _hapticClick();
      }
    }
  }

  void _onMouseExit(PointerExitEvent event) {
    if (_hoveredIndex != null) {
      setState(() => _hoveredIndex = null);
    }
  }

  double _avatarProgress(
    int i,
    int count,
    double controllerValue,
    bool isOpening,
    bool disableAnimations,
  ) {
    if (disableAnimations) {
      return controllerValue;
    }
    if (count <= 1) {
      return Curves.easeOutBack.transform(controllerValue);
    }

    const delayPerItem = 0.035;
    const itemDuration = 0.32;
    final maxDelay = (count - 1) * delayPerItem;
    final totalDuration = maxDelay + itemDuration;

    if (isOpening) {
      final startFraction = (i * delayPerItem) / totalDuration;
      final endFraction = (i * delayPerItem + itemDuration) / totalDuration;
      if (controllerValue <= startFraction) return 0.0;
      if (controllerValue >= endFraction) return 1.0;
      final t = (controllerValue - startFraction) / (endFraction - startFraction);
      return Curves.easeOutBack.transform(t);
    } else {
      final closeOrder = count - 1 - i;
      final startFraction = (closeOrder * delayPerItem) / totalDuration;
      final endFraction =
          (closeOrder * delayPerItem + itemDuration) / totalDuration;
      final tStartClose = 1.0 - startFraction;
      final tEndClose = 1.0 - endFraction;
      if (controllerValue >= tStartClose) return 1.0;
      if (controllerValue <= tEndClose) return 0.0;
      final t = (controllerValue - tEndClose) / (tStartClose - tEndClose);
      return Curves.easeInOutCubic.transform(t);
    }
  }

  Widget _buildAvatarCircle({
    required int index,
    required String name,
    required ProfileStackResolvedStyle style,
    required bool isHovered,
    required bool disableAnimations,
    required double size,
  }) {
    final image = (widget.images != null && index < widget.images!.length)
        ? widget.images![index]
        : null;
    final tileColor = _colorForName(name, style.colors);
    final initials = _extractInitials(name);

    final ringColor = (disableAnimations && isHovered)
        ? style.tagFill
        : style.ring;

    final borderSide = Border.all(
      color: ringColor,
      width: 2.5,
    );

    final boxShadow = isHovered && !disableAnimations
        ? const [
            BoxShadow(
              color: Color(0x38000000), // Colors.black.withOpacity(0.22)
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ]
        : const [
            BoxShadow(
              color: Color(0x14000000), // Colors.black.withOpacity(0.08)
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ];

    return Container(
      key: ValueKey('profile_avatar_$index'),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tileColor,
        border: borderSide,
        boxShadow: boxShadow,
        image: image != null
            ? DecorationImage(image: image, fit: BoxFit.cover)
            : null,
      ),
      alignment: Alignment.center,
      child: image == null
          ? Text(
              initials,
              style: TextStyle(
                color: style.ink,
                fontSize: size * 0.36,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            )
          : null,
    );
  }

  Widget _buildOverflowPill({
    required int count,
    required ProfileStackResolvedStyle style,
    required double size,
  }) {
    return Container(
      key: const ValueKey('profile_overflow_pill'),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: style.overflowFill,
        border: Border.all(
          color: style.ring,
          width: 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '+$count',
        style: TextStyle(
          color: style.overflowInk,
          fontSize: size * 0.34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildCaption(ProfileStackResolvedStyle style, String name) {
    final firstName = _extractFirstName(name);
    return SizedBox(
      width: widget.size + 24,
      child: Text(
        firstName,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: style.caption,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildNameTag(ProfileStackResolvedStyle style, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.tagFill,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        name,
        style: TextStyle(
          color: style.tagInk,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style =
        (widget.style ?? ProfileStackStyle.studioCeramic).resolve(context);
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    final count = widget.names.length;
    final visibleCount = math.min(count, widget.max);
    final overflow = count - visibleCount;
    final hasOverflow = overflow > 0;

    final collapsedStep = _collapsedStep;
    final fannedStep = _fannedStep;

    final collapsedWidth = hasOverflow
        ? (visibleCount * collapsedStep + widget.size)
        : (visibleCount > 0
            ? (visibleCount - 1) * collapsedStep + widget.size
            : widget.size);
    final fannedWidth = count <= 1
        ? widget.size
        : (count - 1) * fannedStep + widget.size;

    final totalHeight = _avatarTop + widget.size + 28.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final currentWidth = ui.lerpDouble(
              collapsedWidth,
              fannedWidth,
              _controller.value,
            ) ??
            collapsedWidth;

        final children = <_StackChildItem>[];

        // Avatars
        for (var i = 0; i < count; i++) {
          if (i >= visibleCount && _controller.value == 0.0) {
            continue;
          }

          final progress = _avatarProgress(
            i,
            count,
            _controller.value,
            _targetFanned,
            disableAnimations,
          );

          final startX = i < visibleCount
              ? i * collapsedStep
              : visibleCount * collapsedStep;
          final endX = i * fannedStep;
          final currentX = startX + (endX - startX) * progress;

          final avatarOpacity = i < visibleCount
              ? 1.0
              : (_controller.value * 2.0).clamp(0.0, 1.0);

          final isHovered = _hoveredIndex == i;
          final zIndex = isHovered ? (count + 10) : i;

          final scale = isHovered && !disableAnimations ? 1.18 : 1.0;
          final translateY = isHovered && !disableAnimations ? -4.0 : 0.0;

          children.add(
            _StackChildItem(
              zIndex: zIndex,
              widget: Positioned(
                left: currentX,
                top: _avatarTop,
                width: widget.size,
                height: widget.size,
                child: Opacity(
                  opacity: avatarOpacity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // Floating Name Tag (at top: -34)
                      if (!disableAnimations)
                        Positioned(
                          top: -34,
                          child: IgnorePointer(
                            child: AnimatedOpacity(
                              opacity: isHovered ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 150),
                              child: AnimatedScale(
                                scale: isHovered ? 1.0 : 0.6,
                                duration: const Duration(milliseconds: 150),
                                child: _buildNameTag(style, widget.names[i]),
                              ),
                            ),
                          ),
                        ),
                      // Avatar Circle with lift
                      Transform.translate(
                        offset: Offset(0, translateY),
                        child: Transform.scale(
                          scale: scale,
                          child: _buildAvatarCircle(
                            index: i,
                            name: widget.names[i],
                            style: style,
                            isHovered: isHovered,
                            disableAnimations: disableAnimations,
                            size: widget.size,
                          ),
                        ),
                      ),
                      // First-name Caption
                      if (_controller.value > 0.0)
                        Positioned(
                          top: widget.size + 6,
                          child: Opacity(
                            opacity: _controller.value.clamp(0.0, 1.0),
                            child: _buildCaption(style, widget.names[i]),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // Overflow pill (+N)
        if (hasOverflow && _controller.value < 1.0) {
          final overflowProgress = _avatarProgress(
            visibleCount,
            count,
            _controller.value,
            _targetFanned,
            disableAnimations,
          );
          final startX = visibleCount * collapsedStep;
          final endX = visibleCount * fannedStep;
          final currentOverflowX = startX + (endX - startX) * overflowProgress;
          final overflowOpacity =
              (1.0 - _controller.value * 2.0).clamp(0.0, 1.0);
          final overflowScale =
              (1.0 - _controller.value * 0.3).clamp(0.0, 1.0);

          children.add(
            _StackChildItem(
              zIndex: visibleCount,
              widget: Positioned(
                left: currentOverflowX,
                top: _avatarTop,
                width: widget.size,
                height: widget.size,
                child: Opacity(
                  opacity: overflowOpacity,
                  child: Transform.scale(
                    scale: overflowScale,
                    child: _buildOverflowPill(
                      count: overflow,
                      style: style,
                      size: widget.size,
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        children.sort((a, b) => a.zIndex.compareTo(b.zIndex));

        return Semantics(
          container: true,
          label: _isFanned
              ? 'Fanned avatar group with $count people'
              : 'Avatar stack with $count people, collapsed. Tap to expand.',
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _onPointerDown,
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            onPointerCancel: _onPointerCancel,
            child: MouseRegion(
              onHover: _onMouseHover,
              onExit: _onMouseExit,
              child: SizedBox(
                width: currentWidth,
                height: totalHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: children.map((c) => c.widget).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StackChildItem {
  final int zIndex;
  final Widget widget;

  _StackChildItem({required this.zIndex, required this.widget});
}
