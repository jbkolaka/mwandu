import 'package:flutter/material.dart';

import '../../theme/variables.dart';

const double _defaultAvatarSize =
    Spacing.v48px3remSpacing09 + Spacing.v8px05remSpacing03;

/// Shows two circular avatars overlapping side by side.
class AvatarDoubleHorizontal extends StatelessWidget {
  const AvatarDoubleHorizontal({
    super.key,
    required this.first,
    required this.second,
    this.size = _defaultAvatarSize,
    this.overlap = Spacing.v24px15remSpacing06,
  });

  /// Content of the avatar on the left.
  final Widget first;

  /// Content of the avatar on the right.
  final Widget second;

  /// Diameter of each avatar circle. Defaults to 56 logical pixels.
  final double size;

  /// Amount the circles overlap horizontally.
  final double overlap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    Widget circle(Widget child) => Container(
      width: size,
      height: size,
      foregroundDecoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: tokens.borderSubtle01,
          width: Spacing.v2px0125remSpacing01,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: tokens.layerAccent01,
        foregroundColor: tokens.iconPrimary,
        child: child,
      ),
    );

    return SizedBox(
      width: size * 2 - overlap,
      height: size,
      child: Stack(
        children: [
          Positioned(left: 0, child: circle(first)),
          Positioned(right: 0, child: circle(second)),
        ],
      ),
    );
  }
}
