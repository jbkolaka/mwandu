import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'content_switcher.props.dart';
import 'content_switcher.styles.dart';

/// Carbon-inspired control for selecting one of several content areas.
///
/// ```dart
/// CContentSwitcher(
///   props: CContentSwitcherProps(
///     options: [
///       CContentSwitcherOption(label: 'Overview', content: Text('Overview')),
///       CContentSwitcherOption(label: 'Details', content: Text('Details')),
///     ],
///   ),
/// )
/// ```
class CContentSwitcher extends StatefulWidget {
  const CContentSwitcher({super.key, required this.props});

  final CContentSwitcherProps props;

  @override
  State<CContentSwitcher> createState() => _CContentSwitcherState();
}

class _CContentSwitcherState extends State<CContentSwitcher> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _validIndex(widget.props.initialIndex);
  }

  @override
  void didUpdateWidget(covariant CContentSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedIndex >= widget.props.options.length ||
        (widget.props.options.isNotEmpty &&
            !widget.props.options[_selectedIndex].enabled)) {
      _selectedIndex = _validIndex(widget.props.initialIndex);
    }
  }

  int _validIndex(int index) {
    final options = widget.props.options;
    if (options.isEmpty) return 0;
    if (index >= 0 && index < options.length && options[index].enabled) {
      return index;
    }
    final firstEnabled = options.indexWhere((option) => option.enabled);
    return firstEnabled < 0 ? 0 : firstEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.props;
    final options = props.options;
    final tokens = context.tokens;
    final selectedIndex = _validIndex(_selectedIndex);
    final selectedContent = options.isEmpty
        ? null
        : options[selectedIndex].content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (options.isNotEmpty)
          Focus(
            canRequestFocus: false,
            onKeyEvent: (node, event) => _handleKeyEvent(event),
            child: Semantics(
              container: true,
              label: 'Content switcher',
              child: Container(
                height: CContentSwitcherStyles.height(props.size),
                padding: const EdgeInsets.all(Spacing.v4px025remSpacing02),
                decoration: BoxDecoration(
                  color: props.lowContrast
                      ? CContentSwitcherStyles.background(tokens)
                      : Colors.transparent,
                  border: props.lowContrast
                      ? null
                      : Border.all(
                          color: CContentSwitcherStyles.selectedBorder(tokens),
                          width: CContentSwitcherStyles.borderWidth,
                        ),
                ),
                child: Row(
                  children: [
                    for (var index = 0; index < options.length; index++)
                      if (props.expand)
                        Expanded(child: _buildOption(context, index, tokens))
                      else
                        _buildOption(context, index, tokens),
                  ],
                ),
              ),
            ),
          ),
        if (selectedContent != null) ...[
          const SizedBox(height: Spacing.v16px1remSpacing05),
          selectedContent,
        ],
      ],
    );
  }

  Widget _buildOption(BuildContext context, int index, AppThemeTokens tokens) {
    final props = widget.props;
    final option = props.options[index];
    final selected = index == _selectedIndex;

    return Semantics(
      button: true,
      enabled: option.enabled,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: option.label,
      child: InkWell(
        onTap: option.enabled ? () => _select(index) : null,
        borderRadius: BorderRadius.zero,
        focusColor: tokens.focus,
        hoverColor: tokens.layerHover01,
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: props.expand
                ? Spacing.v8px05remSpacing03
                : CContentSwitcherStyles.horizontalPadding,
          ),
          decoration: BoxDecoration(
            color: selected && props.lowContrast
                ? CContentSwitcherStyles.selectedBackground(tokens)
                : Colors.transparent,
            border: selected && !props.lowContrast
                ? Border.all(
                    color: CContentSwitcherStyles.selectedBorder(tokens),
                    width: CContentSwitcherStyles.borderWidth,
                  )
                : null,
            borderRadius: BorderRadius.zero,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (option.icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: option.enabled
                        ? (selected
                              ? CContentSwitcherStyles.foreground(tokens)
                              : CContentSwitcherStyles.inactiveForeground(
                                  tokens,
                                ))
                        : tokens.textDisabled,
                    size: CContentSwitcherStyles.iconSize,
                  ),
                  child: option.icon!,
                ),
                const SizedBox(width: CContentSwitcherStyles.iconGap),
              ],
              Flexible(
                child: Text(
                  option.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: option.enabled
                        ? (selected
                              ? CContentSwitcherStyles.foreground(tokens)
                              : CContentSwitcherStyles.inactiveForeground(
                                  tokens,
                                ))
                        : tokens.textDisabled,
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.arrowLeft &&
        key != LogicalKeyboardKey.arrowRight) {
      return KeyEventResult.ignored;
    }

    final direction = key == LogicalKeyboardKey.arrowRight ? 1 : -1;
    final options = widget.props.options;
    for (var step = 1; step <= options.length; step++) {
      final index = (_selectedIndex + direction * step) % options.length;
      final wrappedIndex = (index + options.length) % options.length;
      if (options[wrappedIndex].enabled) {
        _select(wrappedIndex);
        break;
      }
    }
    return KeyEventResult.handled;
  }

  void _select(int index) {
    if (index == _selectedIndex || !widget.props.options[index].enabled) {
      return;
    }
    setState(() => _selectedIndex = index);
    widget.props.onSelectionChanged?.call(index);
  }
}
