import 'package:flutter/material.dart';

import '../../theme/variables.dart' hide Theme;

const double _defaultAvatarSize =
    Spacing.v48px3remSpacing09 + Spacing.v8px05remSpacing03;

/// A circular, theme-aware avatar that displays two initials.
class AvatarText extends StatelessWidget {
  const AvatarText({
    super.key,
    required this.initials,
    this.size = _defaultAvatarSize,
    this.backgroundColor,
    this.textColor,
  });

  /// The two letters shown in the avatar.
  final String initials;

  /// Width and height of the avatar. Defaults to 56 logical pixels.
  final double size;

  /// Optional overrides; theme tokens are used when these are not supplied.
  final Color? backgroundColor;
  final Color? textColor;

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
        backgroundColor: backgroundColor ?? tokens.layerAccent01,
        child: Text(
          initials.length <= 2 ? initials : initials.substring(0, 2),
          maxLines: 1,
          overflow: TextOverflow.clip,
          style:
              Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: textColor ?? tokens.textPrimary) ??
              TextStyle(
                color: textColor ?? tokens.textPrimary,
                fontSize: Spacing.v24px15remSpacing06,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
