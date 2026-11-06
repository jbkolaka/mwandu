import 'package:flutter/material.dart';

import '../../theme/variables.dart';

const double _defaultAvatarSize =
    Spacing.v48px3remSpacing09 + Spacing.v8px05remSpacing03;
const double _defaultBadgeSize =
    Spacing.v16px1remSpacing05 + Spacing.v2px0125remSpacing01;

/// Places a circular status badge over the lower-right corner of an avatar.
class AvatarWithBadge extends StatelessWidget {
  const AvatarWithBadge({
    super.key,
    required this.avatar,
    this.badgeChild,
    this.badgeColor,
    this.size = _defaultAvatarSize,
    this.badgeSize = _defaultBadgeSize,
  });

  /// Avatar shown beneath the badge.
  final Widget avatar;

  /// Optional content centered in the badge, such as a small status icon.
  final Widget? badgeChild;

  /// Optional badge fill override. Defaults to the theme's success token.
  final Color? badgeColor;

  /// Width and height of the avatar.
  final double size;

  /// Width and height of the circular badge. Defaults to 18 logical pixels.
  final double badgeSize;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: avatar),
          Positioned(
            // Let the badge straddle the avatar edge instead of sitting fully
            // inside it, as in the Wise avatar treatment.
            right: -badgeSize / 4,
            bottom: -badgeSize / 4,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: badgeColor ?? tokens.supportSuccess,
                shape: BoxShape.circle,
                border: Border.all(
                  color: tokens.borderSubtle01,
                  width: Spacing.v2px0125remSpacing01,
                ),
              ),
              alignment: Alignment.center,
              child: badgeChild,
            ),
          ),
        ],
      ),
    );
  }
}
