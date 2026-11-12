import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'date_picker.props.dart';
import 'date_picker.styles.dart';

/// Theme-aware date picker supporting single-date and range selection.
class CDatePicker extends StatefulWidget {
  const CDatePicker({super.key, required this.props});

  final CDatePickerProps props;

  @override
  State<CDatePicker> createState() => _CDatePickerState();
}

class _CDatePickerState extends State<CDatePicker> {
  late final TextEditingController _controller;
  DateTime? _date;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _date = widget.props.initialDate;
    _dateRange = widget.props.initialDateRange;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.initialDate != oldWidget.props.initialDate) {
      _date = widget.props.initialDate;
    }
    if (widget.props.initialDateRange != oldWidget.props.initialDateRange) {
      _dateRange = widget.props.initialDateRange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final value = widget.props.mode == CDatePickerMode.single
        ? _date == null
              ? null
              : _formatDate(_date!)
        : _dateRange == null
        ? null
        : '${_formatDate(_dateRange!.start)} – ${_formatDate(_dateRange!.end)}';
    final text = value ?? '';
    if (_controller.text != text) _controller.text = text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.props.label,
          style: TextStyle(
            color: widget.props.disabled
                ? CDatePickerStyles.disabledText(tokens)
                : CDatePickerStyles.text(tokens),
            fontSize: CDatePickerStyles.labelFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: CDatePickerStyles.helperTopSpacing),
        Semantics(
          label: widget.props.label,
          value: value ?? widget.props.placeholder ?? 'No date selected',
          child: SizedBox(
            height: CDatePickerStyles.fieldHeight,
            child: TextField(
              controller: _controller,
              readOnly: true,
              enabled: !widget.props.disabled,
              onTap: _openPicker,
              style: TextStyle(
                color: widget.props.disabled
                    ? CDatePickerStyles.disabledText(tokens)
                    : CDatePickerStyles.text(tokens),
                fontSize: CDatePickerStyles.fieldFontSize,
              ),
              decoration: InputDecoration(
                hintText: value == null ? widget.props.placeholder : null,
                filled: true,
                fillColor: CDatePickerStyles.fieldBackground(tokens),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: CDatePickerStyles.horizontalPadding,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                    color: CDatePickerStyles.border(tokens),
                    width: CDatePickerStyles.borderWidth,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                    color: CDatePickerStyles.focus(tokens),
                    width: 2,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                    color: tokens.borderDisabled,
                    width: CDatePickerStyles.borderWidth,
                  ),
                ),
                suffixIcon: IconButton(
                  tooltip: 'Open calendar',
                  onPressed: widget.props.disabled ? null : _openPicker,
                  icon: const Icon(Icons.calendar_month_outlined),
                  color: CDatePickerStyles.icon(tokens),
                ),
              ),
            ),
          ),
        ),
        if (widget.props.helperText != null) ...[
          const SizedBox(height: CDatePickerStyles.helperTopSpacing),
          Text(
            widget.props.helperText!,
            style: TextStyle(
              color: CDatePickerStyles.secondaryText(tokens),
              fontSize: CDatePickerStyles.helperFontSize,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _openPicker() async {
    if (widget.props.disabled) return;
    final tokens = context.tokens;
    final firstDate = DateUtils.dateOnly(
      widget.props.firstDate ?? DateTime(1900),
    );
    final lastDate = DateUtils.dateOnly(
      widget.props.lastDate ?? DateTime(2100),
    );
    if (lastDate.isBefore(firstDate)) return;
    final initialDate = _clampDate(
      _date ?? DateTime.now(),
      firstDate,
      lastDate,
    );

    if (widget.props.mode == CDatePickerMode.single) {
      final selected = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (context, child) => _themedPicker(context, tokens, child),
      );
      if (!mounted || selected == null) return;
      setState(() => _date = DateUtils.dateOnly(selected));
      widget.props.onDateChanged?.call(DateUtils.dateOnly(selected));
      return;
    }

    final initialRange = _validInitialRange(_dateRange, firstDate, lastDate);
    final selectedRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) => _themedPicker(context, tokens, child),
    );
    if (!mounted || selectedRange == null) return;
    final range = DateTimeRange(
      start: DateUtils.dateOnly(selectedRange.start),
      end: DateUtils.dateOnly(selectedRange.end),
    );
    setState(() => _dateRange = range);
    widget.props.onDateRangeChanged?.call(range);
  }

  Widget _themedPicker(
    BuildContext context,
    AppThemeTokens tokens,
    Widget? child,
  ) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: tokens.buttonPrimary,
          onPrimary: tokens.textOnColor,
          surface: tokens.layer01,
          onSurface: tokens.textPrimary,
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: tokens.layer01,
          surfaceTintColor: Colors.transparent,
          headerBackgroundColor: tokens.layer01,
          headerForegroundColor: tokens.textPrimary,
          dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return tokens.buttonPrimary;
            }
            return null;
          }),
          dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return tokens.textOnColor;
            }
            if (states.contains(WidgetState.disabled)) {
              return tokens.textDisabled;
            }
            return tokens.textPrimary;
          }),
          todayForegroundColor: WidgetStatePropertyAll<Color?>(
            tokens.interactive,
          ),
          todayBorder: BorderSide(color: tokens.interactive),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }

  DateTimeRange? _validInitialRange(
    DateTimeRange? range,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    if (range == null) return null;
    final start = _clampDate(range.start, firstDate, lastDate);
    final end = _clampDate(range.end, firstDate, lastDate);
    if (end.isBefore(start)) return null;
    return DateTimeRange(start: start, end: end);
  }

  DateTime _clampDate(DateTime date, DateTime firstDate, DateTime lastDate) {
    final normalized = DateUtils.dateOnly(date);
    if (normalized.isBefore(firstDate)) return firstDate;
    if (normalized.isAfter(lastDate)) return lastDate;
    return normalized;
  }

  String _formatDate(DateTime date) =>
      MaterialLocalizations.of(context).formatMediumDate(date);
}
