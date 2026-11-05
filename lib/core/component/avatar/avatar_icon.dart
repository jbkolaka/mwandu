import 'package:flutter/material.dart';

import '../../theme/variables.dart';

const double _defaultAvatarSize =
    Spacing.v48px3remSpacing09 + Spacing.v8px05remSpacing03;

/// A circular, theme-aware avatar for representing a person or account with
/// an icon instead of a photo.
class AvatarIcon extends StatelessWidget {
  const AvatarIcon({
    super.key,
    required this.icon,
    this.size = _defaultAvatarSize,
    this.iconSize = Spacing.v32px2remSpacing07,
    this.backgroundColor,
    this.iconColor,
    this.semanticLabel,
  });

  /// Icon shown in the center of the avatar.
  final IconData icon;

  /// Width and height of the avatar. Defaults to 56 logical pixels.
  final double size;

  /// Size of the centered icon.
  final double iconSize;

  /// Optional overrides; theme tokens are used when these are not supplied.
  final Color? backgroundColor;
  final Color? iconColor;

  /// Accessible description for the avatar. If omitted, the icon is decorative.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Semantics(
      label: semanticLabel,
      image: semanticLabel != null,
      excludeSemantics: semanticLabel == null,
      child: Container(
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
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor ?? tokens.iconPrimary,
          ),
        ),
      ),
    );
  }
}
