import 'package:flutter/material.dart';

import '../../theme/variables.dart';

const double _defaultAvatarSize =
    Spacing.v48px3remSpacing09 + Spacing.v8px05remSpacing03;

/// Shows a country flag as the centered content of a circular avatar.
class AvatarFlags extends StatelessWidget {
  const AvatarFlags({
    super.key,
    required this.flag,
    this.size = _defaultAvatarSize,
  });

  /// Country flag, usually an emoji such as `🇰🇪`.
  final String flag;

  /// Width and height of the avatar.
  final double size;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
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
        child: Text(
          flag,
          style: TextStyle(
            fontSize: size * Spacing.v32px2remSpacing07 / _defaultAvatarSize,
          ),
        ),
      ),
    );
  }
}
