import 'package:flutter/material.dart';
import 'package:mwandu/core/shared/enums/index.dart';
import 'package:mwandu/core/shared/pmvvm.dart';

extension CThemeContextExtension on BuildContext {
  get cTheme {
    return fetch<CTheme>();
  }
}
