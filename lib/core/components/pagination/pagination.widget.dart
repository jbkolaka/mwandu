import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'pagination.props.dart';
import 'pagination.styles.dart';

/// Theme-aware pagination controls with page navigation and page-size choice.
class CPagination extends StatefulWidget {
  const CPagination({super.key, required this.props});

  final CPaginationProps props;

  @override
  State<CPagination> createState() => _CPaginationState();
}

class _CPaginationState extends State<CPagination> {
  late int _currentPage;
  late int _pageSize;
  late final TextEditingController _pageController;

  int get _pageCount =>
      (widget.props.totalItems / _pageSize).ceil().clamp(1, 1 << 31).toInt();

  int get _totalItems => widget.props.totalItems < 0 ? 0 : widget.props.totalItems;

  int get _startItem => _totalItems == 0
      ? 0
      : ((_currentPage - 1) * _pageSize) + 1;

  int get _endItem =>
      (_currentPage * _pageSize).clamp(0, _totalItems).toInt();

  @override
  void initState() {
    super.initState();
    _pageSize = _normalizedPageSize(widget.props.pageSize);
    _currentPage = _normalizedPage(widget.props.initialPage);
    _pageController = TextEditingController(text: '$_currentPage');
  }

  @override
  void didUpdateWidget(covariant CPagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.pageSize != oldWidget.props.pageSize) {
      _pageSize = _normalizedPageSize(widget.props.pageSize);
    }
    if (widget.props.initialPage != oldWidget.props.initialPage) {
      _currentPage = _normalizedPage(widget.props.initialPage);
    } else {
      _currentPage = _normalizedPage(_currentPage);
    }
    _syncPageField();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final props = widget.props;
    final height = CPaginationStyles.controlHeight(props.size);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.v16px1remSpacing05,
        vertical: Spacing.v8px05remSpacing03,
      ),
      decoration: BoxDecoration(
        color: CPaginationStyles.background(tokens),
        border: Border(
          top: BorderSide(color: CPaginationStyles.border(tokens)),
        ),
      ),
      child: Semantics(
        container: true,
        label: 'Pagination',
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: CPaginationStyles.groupSpacing,
          runSpacing: CPaginationStyles.controlSpacing,
          children: [
            _buildRange(tokens),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: CPaginationStyles.controlSpacing,
              children: [
                if (props.showPageSizeSelector) _buildPageSizeSelector(tokens),
                _buildPageNavigation(tokens, height),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRange(AppThemeTokens tokens) {
    return Semantics(
      liveRegion: true,
      child: Text(
        '$_startItem–$_endItem of $_totalItems items',
        style: TextStyle(
          color: CPaginationStyles.secondaryText(tokens),
          fontSize: CPaginationStyles.labelFontSize,
        ),
      ),
    );
  }

  Widget _buildPageSizeSelector(AppThemeTokens tokens) {
    final sizes = _availablePageSizes;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: CPaginationStyles.controlSpacing,
      children: [
        Text(
          widget.props.itemsPerPageLabel,
          style: TextStyle(
            color: CPaginationStyles.primaryText(tokens),
            fontSize: CPaginationStyles.labelFontSize,
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: _pageSize,
            dropdownColor: CPaginationStyles.background(tokens),
            style: TextStyle(
              color: CPaginationStyles.primaryText(tokens),
              fontSize: CPaginationStyles.labelFontSize,
            ),
            iconEnabledColor: CPaginationStyles.icon(tokens),
            focusColor: CPaginationStyles.focus(tokens),
            items: [
              for (final size in sizes)
                DropdownMenuItem<int>(value: size, child: Text('$size')),
            ],
            onChanged: _changePageSize,
          ),
        ),
      ],
    );
  }

  Widget _buildPageNavigation(AppThemeTokens tokens, double height) {
    final previousEnabled = _currentPage > 1;
    final nextEnabled = _currentPage < _pageCount;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPageButton(
          tokens,
          icon: Icons.chevron_left,
          label: 'Previous page',
          enabled: previousEnabled,
          onPressed: () => _changePage(_currentPage - 1),
          height: height,
        ),
        Semantics(
          label: 'Page number, $_currentPage of $_pageCount',
          child: SizedBox(
            width: CPaginationStyles.pageFieldWidth,
            height: height,
            child: TextField(
            controller: _pageController,
            enabled: _pageCount > 1,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: _submitPage,
            style: TextStyle(
              color: CPaginationStyles.primaryText(tokens),
              fontSize: CPaginationStyles.labelFontSize,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.v4px025remSpacing02,
                vertical: Spacing.v8px05remSpacing03,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: CPaginationStyles.border(tokens)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CPaginationStyles.border(tokens)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CPaginationStyles.focus(tokens),
                  width: 2,
                ),
              ),
            ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.v4px025remSpacing02,
          ),
          child: Text(
            'of $_pageCount',
            style: TextStyle(
              color: CPaginationStyles.secondaryText(tokens),
              fontSize: CPaginationStyles.labelFontSize,
            ),
          ),
        ),
        _buildPageButton(
          tokens,
          icon: Icons.chevron_right,
          label: 'Next page',
          enabled: nextEnabled,
          onPressed: () => _changePage(_currentPage + 1),
          height: height,
        ),
      ],
    );
  }

  Widget _buildPageButton(
    AppThemeTokens tokens, {
    required IconData icon,
    required String label,
    required bool enabled,
    required VoidCallback onPressed,
    required double height,
  }) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            focusColor: CPaginationStyles.focus(tokens),
            hoverColor: CPaginationStyles.hover(tokens),
            splashColor: CPaginationStyles.active(tokens),
            child: SizedBox(
              width: height,
              height: height,
              child: Icon(
                icon,
                size: CPaginationStyles.iconSize,
                color: enabled
                    ? CPaginationStyles.icon(tokens)
                    : tokens.textDisabled,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<int> get _availablePageSizes {
    final sizes = widget.props.pageSizes
        .where((size) => size > 0)
        .toSet()
        .toList()..sort();
    if (sizes.isEmpty) return <int>[_pageSize];
    if (!sizes.contains(_pageSize)) sizes.add(_pageSize);
    sizes.sort();
    return sizes;
  }

  int _normalizedPageSize(int size) {
    if (size <= 0) return 10;
    final validSizes = widget.props.pageSizes.where((value) => value > 0);
    return validSizes.isEmpty || validSizes.contains(size)
        ? size
        : validSizes.first;
  }

  int _normalizedPage(int page) => page.clamp(1, _pageCount).toInt();

  void _syncPageField() {
    final text = '$_currentPage';
    if (_pageController.text != text) _pageController.text = text;
  }

  void _changePage(int page) {
    final nextPage = _normalizedPage(page);
    if (nextPage == _currentPage) return;
    setState(() {
      _currentPage = nextPage;
      _syncPageField();
    });
    widget.props.onPageChanged?.call(nextPage);
  }

  void _changePageSize(int? pageSize) {
    if (pageSize == null || pageSize <= 0 || pageSize == _pageSize) return;
    setState(() {
      _pageSize = pageSize;
      _currentPage = 1;
      _syncPageField();
    });
    widget.props.onPageSizeChanged?.call(pageSize);
    widget.props.onPageChanged?.call(1);
  }

  void _submitPage(String value) {
    final page = int.tryParse(value);
    if (page == null) {
      _syncPageField();
      return;
    }
    _changePage(page);
    _syncPageField();
  }
}
