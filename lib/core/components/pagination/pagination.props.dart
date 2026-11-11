import 'package:flutter/widgets.dart';

/// Density variants for pagination controls.
enum CPaginationSize { sm, md, lg, xl }

/// Configuration for [CPagination].
class CPaginationProps {
  const CPaginationProps({
    required this.totalItems,
    this.initialPage = 1,
    this.pageSize = 10,
    this.pageSizes = const <int>[10, 20, 30, 40, 50],
    this.size = CPaginationSize.md,
    this.showPageSizeSelector = true,
    this.itemsPerPageLabel = 'Items per page',
    this.onPageChanged,
    this.onPageSizeChanged,
  });

  /// Number of items represented by the paged content.
  final int totalItems;

  /// Page selected on first build.
  final int initialPage;

  /// Number of items shown per page initially.
  final int pageSize;

  /// Available page sizes for the selector.
  final List<int> pageSizes;

  /// Control density.
  final CPaginationSize size;

  /// Whether to show the page-size selector.
  final bool showPageSizeSelector;

  /// Text label displayed beside the page-size selector.
  final String itemsPerPageLabel;

  /// Called when the selected page changes.
  final ValueChanged<int>? onPageChanged;

  /// Called when the selected page size changes.
  final ValueChanged<int>? onPageSizeChanged;
}
