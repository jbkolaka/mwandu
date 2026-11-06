import 'package:flutter/material.dart';

/// Minimal shim replacing `flutter_svg`'s [SvgPicture] used by legacy
/// components. Renders a placeholder instead of actual SVG assets.

class SvgPicture {
  SvgPicture._();

  static Widget asset(
    String assetName, {
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
  }) {
    return SizedBox(width: width, height: height);
  }
}
