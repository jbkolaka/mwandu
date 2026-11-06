import 'package:flutter/material.dart';

class Provider<T> extends InheritedWidget {
  const Provider.value({
    super.key,
    required this.value,
    required super.child,
  });

  final T value;

  static T of<T>(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<Provider<T>>();
    final widget = element?.widget as Provider<T>?;
    if (widget == null) {
      throw FlutterError('Provider<$T> not found in context');
    }
    return widget.value;
  }

  @override
  bool updateShouldNotify(covariant Provider<T> oldWidget) =>
      oldWidget.value != value;
}

extension PmvvmContextExtension on BuildContext {
  T fetch<T>() {
    return Provider.of<T>(this);
  }
}
