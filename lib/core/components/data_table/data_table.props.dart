import 'package:flutter/widgets.dart';

/// A column in a [CDataTable].
class CDataTableColumn {
  const CDataTableColumn({
    required this.key,
    required this.label,
    this.sortable = true,
    this.width,
    this.cellBuilder,
  });

  /// Value key used to read a cell from each row.
  final String key;

  /// Header text shown for this column.
  final String label;

  /// Whether the column header can sort the rows.
  final bool sortable;

  /// Optional fixed width for this column.
  final double? width;

  /// Optional renderer for the value in a cell.
  final Widget Function(BuildContext context, Object? value, int rowIndex)?
  cellBuilder;
}

/// Configuration for [CDataTable].
class CDataTableProps {
  const CDataTableProps({
    required this.columns,
    this.rows = const <Map<String, Object?>>[],
    this.title,
    this.description,
    this.emptyMessage = 'No data available',
    this.rowHeight,
    this.onRowTap,
  });

  /// Column definitions. Supply columns even when [rows] is empty.
  final List<CDataTableColumn> columns;

  /// Rows keyed by each [CDataTableColumn.key]. Defaults to an empty dataset.
  final List<Map<String, Object?>> rows;

  /// Optional table title.
  final String? title;

  /// Optional supporting text below the title.
  final String? description;

  /// Message displayed when no rows are available.
  final String emptyMessage;

  /// Optional row height override.
  final double? rowHeight;

  /// Called when a data row is tapped.
  final ValueChanged<Map<String, Object?>>? onRowTap;
}
