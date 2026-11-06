// Variables exported from FigCraft.
// Module: Layer

import 'dart:ui';

/// Layer level · On background
abstract final class LayerLevel {
  static const Color layerSelectedContextual = Color(0x338D8D8D);
  static const String layerName = 'Background';
  static const String fieldName = 'Field 01';
  static const String borderSubtleName = 'border-subtle-00';
  static const String borderStrongName = 'border-strong-01';
}

/// Layer level · On layer 01
abstract final class LayerLevelOnLayer01 {
  static const Color layerSelectedContextual = Color(0x338D8D8D);
  static const String layerName = 'Layer 01';
  static const String fieldName = 'Field 02';
  static const String borderSubtleName = 'border-subtle-01';
  static const String borderStrongName = 'border-strong-02';
}

/// Layer level · On layer 02
abstract final class LayerLevelOnLayer02 {
  static const Color layerSelectedContextual = Color(0x338D8D8D);
  static const String layerName = 'Layer 02';
  static const String fieldName = 'Field 03';
  static const String borderSubtleName = 'border-subtle-02';
  static const String borderStrongName = 'border-strong-03';
}
