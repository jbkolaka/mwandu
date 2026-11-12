import 'package:flutter/material.dart';

/// Selection mode for [CDatePicker].
enum CDatePickerMode { single, range }

/// Configuration for [CDatePicker].
class CDatePickerProps {
  const CDatePickerProps({
    this.mode = CDatePickerMode.single,
    this.label = 'Date',
    this.placeholder,
    this.helperText,
    this.initialDate,
    this.initialDateRange,
    this.firstDate,
    this.lastDate,
    this.disabled = false,
    this.onDateChanged,
    this.onDateRangeChanged,
  });

  /// Select one date or a start and end date.
  final CDatePickerMode mode;

  /// Visible field label.
  final String label;

  /// Optional placeholder shown before a selection is made.
  final String? placeholder;

  /// Optional helper text below the field.
  final String? helperText;

  /// Initially selected date in [CDatePickerMode.single] mode.
  final DateTime? initialDate;

  /// Initially selected range in [CDatePickerMode.range] mode.
  final DateTimeRange? initialDateRange;

  /// Earliest selectable date.
  final DateTime? firstDate;

  /// Latest selectable date.
  final DateTime? lastDate;

  /// Whether the field is disabled.
  final bool disabled;

  /// Called when a single date is selected.
  final ValueChanged<DateTime>? onDateChanged;

  /// Called when a complete date range is selected.
  final ValueChanged<DateTimeRange>? onDateRangeChanged;
}
