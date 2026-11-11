import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'data_table.props.dart';
import 'data_table.styles.dart';

/// Carbon-inspired, theme-aware data table with optional sortable columns.
///
/// Pass column definitions to render an empty table state before data is ready:
///
/// ```dart
/// CDataTable(
///   props: CDataTableProps(
///     columns: [CDataTableColumn(key: 'name', label: 'Name')],
///   ),
/// )
/// ```
class CDataTable extends StatefulWidget {
  const CDataTable({super.key, required this.props});

  final CDataTableProps props;

  @override
  State<CDataTable> createState() => _CDataTableState();
}

class _CDataTableState extends State<CDataTable> {
  int? _sortColumnIndex;
  bool _ascending = true;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final props = widget.props;
    final rows = _sortedRows(props);

    return Container(
      decoration: BoxDecoration(
        color: CDataTableStyles.backgroundColor(tokens),
        border: Border.all(
          color: CDataTableStyles.borderColor(tokens),
          width: CDataTableStyles.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (props.title != null || props.description != null)
            _buildTitle(tokens, props),
          if (props.columns.isEmpty)
            _buildEmptyState(tokens, props.emptyMessage)
          else
            _buildTable(context, tokens, props, rows),
        ],
      ),
    );
  }

  Widget _buildTitle(AppThemeTokens tokens, CDataTableProps props) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (props.title case final title?)
            Text(
              title,
              style: TextStyle(
                color: tokens.textPrimary,
                fontSize: CDataTableStyles.titleFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (props.description case final description?) ...[
            if (props.title != null)
              const SizedBox(height: Spacing.v4px025remSpacing02),
            Text(
              description,
              style: TextStyle(
                color: tokens.textSecondary,
                fontSize: CDataTableStyles.descriptionFontSize,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTable(
    BuildContext context,
    AppThemeTokens tokens,
    CDataTableProps props,
    List<Map<String, Object?>> rows,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        columnWidths: {
          for (var i = 0; i < props.columns.length; i++)
            if (props.columns[i].width != null)
              i: FixedColumnWidth(props.columns[i].width!),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: CDataTableStyles.headerBackgroundColor(tokens),
              border: Border(
                bottom: BorderSide(color: CDataTableStyles.borderColor(tokens)),
              ),
            ),
            children: [
              for (var i = 0; i < props.columns.length; i++)
                _buildHeader(context, tokens, props.columns[i], i),
            ],
          ),
          if (rows.isEmpty)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
                  child: Text(
                    props.emptyMessage,
                    style: TextStyle(
                      color: tokens.textSecondary,
                      fontSize: CDataTableStyles.cellFontSize,
                    ),
                  ),
                ),
                for (var i = 1; i < props.columns.length; i++)
                  const SizedBox.shrink(),
              ],
            )
          else
            for (var rowIndex = 0; rowIndex < rows.length; rowIndex++)
              _buildRow(context, tokens, props, rows[rowIndex], rowIndex),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppThemeTokens tokens,
    CDataTableColumn column,
    int columnIndex,
  ) {
    final activeSort = _sortColumnIndex == columnIndex;
    return InkWell(
      onTap: column.sortable ? () => _sort(columnIndex) : null,
      hoverColor: CDataTableStyles.hoverColor(tokens),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: CDataTableStyles.headerHeight,
        ),
        padding: const EdgeInsets.only(
          left: CDataTableStyles.cellHorizontalPadding,
          right: CDataTableStyles.cellRightPadding,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              column.label,
              style: TextStyle(
                color: tokens.textSecondary,
                fontSize: CDataTableStyles.headerFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (column.sortable) ...[
              const SizedBox(width: Spacing.v4px025remSpacing02),
              Icon(
                activeSort
                    ? (_ascending ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.unfold_more,
                size: 16,
                color: activeSort ? tokens.iconPrimary : tokens.iconSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  TableRow _buildRow(
    BuildContext context,
    AppThemeTokens tokens,
    CDataTableProps props,
    Map<String, Object?> row,
    int rowIndex,
  ) {
    return TableRow(
      decoration: BoxDecoration(
        color: CDataTableStyles.backgroundColor(tokens),
        border: Border(
          bottom: BorderSide(color: CDataTableStyles.borderColor(tokens)),
        ),
      ),
      children: [
        for (final column in props.columns)
          InkWell(
            onTap: props.onRowTap == null ? null : () => props.onRowTap!(row),
            hoverColor: CDataTableStyles.hoverColor(tokens),
            child: Container(
              constraints: BoxConstraints(
                minHeight: props.rowHeight ?? CDataTableStyles.defaultRowHeight,
              ),
              padding: const EdgeInsets.only(
                left: CDataTableStyles.cellHorizontalPadding,
                right: CDataTableStyles.cellRightPadding,
              ),
              alignment: Alignment.centerLeft,
              child: column.cellBuilder?.call(
                    context,
                    row[column.key],
                    rowIndex,
                  ) ??
                  Text(
                    row[column.key]?.toString() ?? '',
                    style: TextStyle(
                      color: tokens.textPrimary,
                      fontSize: CDataTableStyles.cellFontSize,
                    ),
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(AppThemeTokens tokens, String message) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.v16px1remSpacing05),
      child: Text(
        message,
        style: TextStyle(
          color: tokens.textSecondary,
          fontSize: CDataTableStyles.cellFontSize,
        ),
      ),
    );
  }

  List<Map<String, Object?>> _sortedRows(CDataTableProps props) {
    if (_sortColumnIndex == null ||
        _sortColumnIndex! >= props.columns.length ||
        props.rows.isEmpty) {
      return props.rows;
    }
    final key = props.columns[_sortColumnIndex!].key;
    final sorted = List<Map<String, Object?>>.of(props.rows);
    sorted.sort((a, b) {
      final comparison = (a[key]?.toString() ?? '').compareTo(
        b[key]?.toString() ?? '',
      );
      return _ascending ? comparison : -comparison;
    });
    return sorted;
  }

  void _sort(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _ascending = !_ascending;
      } else {
        _sortColumnIndex = columnIndex;
        _ascending = true;
      }
    });
  }
}
