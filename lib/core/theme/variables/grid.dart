// Variables exported from FigCraft.
// Module: Grid

/// Grid mode · Wide
abstract final class GridMode {
  static const double gutter = 32;
  static const double leftEndMargin = 16;
  static const double rightEndMargin = 16;
  static const double v4ColumnMinWidth = 288;
  static const double v4ColumnMaxWidth = 288;
  static const double v2ColumnMinWidth = 48;
  static const double v2ColumnMaxWidth = 48;
  static const double v6ColumnMinWidth = 288;
  static const double v6ColumnMaxWidth = 288;
  static const double v8ColumnMinWidth = 288;
  static const double v8ColumnMaxWidth = 288;
  static const double v2ColumnWidth = 48;
  static const double v4ColumnWidth = 288;
  static const double v6ColumnWidth = 288;
  static const double v8ColumnWidth = 288;
  static const double v12ColumnWidth = 288;
  static const double asideLeftSpacerWidth = 0;
  static const double asideLeftSpacerMinWidth = 0;
  static const double asideLeftSpacerMaxWidth = 0;
  static const double asideLeftSpacerMaxXL = 288;
  static const double leftEndMarginWithAside = 0;
  static const double rightEndMarginWithAside = 0;
  static const double endMargins = 16;
  static const double v5ColumnWidth = 288;
  static const bool asideLeft = true;
}

/// Grid mode · Narrow
abstract final class GridModeNarrow {
  static const double gutter = 16;
  static const double leftEndMargin = 0;
  static const double rightEndMargin = 16;
  static const double v4ColumnMinWidth = 304;
  static const double v4ColumnMaxWidth = 304;
  static const double v2ColumnMinWidth = 64;
  static const double v2ColumnMaxWidth = 64;
  static const double v6ColumnMinWidth = 304;
  static const double v6ColumnMaxWidth = 304;
  static const double v8ColumnMinWidth = 304;
  static const double v8ColumnMaxWidth = 304;
  static const double v2ColumnWidth = 64;
  static const double v4ColumnWidth = 304;
  static const double v6ColumnWidth = 304;
  static const double v8ColumnWidth = 304;
  static const double v12ColumnWidth = 304;
  static const double asideLeftSpacerWidth = 0;
  static const double asideLeftSpacerMinWidth = 0;
  static const double asideLeftSpacerMaxWidth = 0;
  static const double asideLeftSpacerMaxXL = 304;
  static const double leftEndMarginWithAside = 0;
  static const double rightEndMarginWithAside = 0;
  static const double endMargins = 16;
  static const double v5ColumnWidth = 304;
  static const bool asideLeft = true;
}

/// Grid mode · Condensed
abstract final class GridModeCondensed {
  static const double gutter = 0;
  static const double leftEndMargin = 0;
  static const double rightEndMargin = 0;
  static const double v4ColumnMinWidth = 320;
  static const double v4ColumnMaxWidth = 320;
  static const double v2ColumnMinWidth = 80;
  static const double v2ColumnMaxWidth = 64;
  static const double v6ColumnMinWidth = 320;
  static const double v6ColumnMaxWidth = 320;
  static const double v8ColumnMinWidth = 320;
  static const double v8ColumnMaxWidth = 320;
  static const double v2ColumnWidth = 80;
  static const double v4ColumnWidth = 320;
  static const double v6ColumnWidth = 320;
  static const double v8ColumnWidth = 320;
  static const double v12ColumnWidth = 320;
  static const double asideLeftSpacerWidth = 0;
  static const double asideLeftSpacerMinWidth = 0;
  static const double asideLeftSpacerMaxWidth = 0;
  static const double asideLeftSpacerMaxXL = 320;
  static const double leftEndMarginWithAside = 0;
  static const double rightEndMarginWithAside = 0;
  static const double endMargins = 16;
  static const double v5ColumnWidth = 320;
  static const bool asideLeft = true;
}

/// Grid mode · Nested
abstract final class GridModeNested {
  static const double gutter = 0;
  static const double leftEndMargin = 0;
  static const double rightEndMargin = 0;
  static const double v4ColumnMinWidth = 144;
  static const double v4ColumnMaxWidth = 144;
  static const double v2ColumnMinWidth = 56;
  static const double v2ColumnMaxWidth = 56;
  static const double v6ColumnMinWidth = 232;
  static const double v6ColumnMaxWidth = 232;
  static const double v8ColumnMinWidth = 320;
  static const double v8ColumnMaxWidth = 320;
  static const double v2ColumnWidth = 0;
  static const double v4ColumnWidth = 0;
  static const double v6ColumnWidth = 0;
  static const double v8ColumnWidth = 0;
  static const double v12ColumnWidth = 0;
  static const double asideLeftSpacerWidth = 0;
  static const double asideLeftSpacerMinWidth = 0;
  static const double asideLeftSpacerMaxWidth = 0;
  static const double asideLeftSpacerMaxXL = 0;
  static const double leftEndMarginWithAside = 0;
  static const double rightEndMarginWithAside = 0;
  static const double endMargins = 16;
  static const double v5ColumnWidth = 0;
  static const bool asideLeft = false;
}

/// Aside · No Asides
abstract final class Aside {
  static const bool asideLeft = false;
  static const bool asideRight = false;
  static const bool hideWhenHasAsideLeft = true;
}

/// Aside · Aside Left
abstract final class AsideAsideLeft {
  static const bool asideLeft = true;
  static const bool asideRight = false;
  static const bool hideWhenHasAsideLeft = false;
}

/// Aside · Aside Right
abstract final class AsideAsideRight {
  static const bool asideLeft = false;
  static const bool asideRight = true;
  static const bool hideWhenHasAsideLeft = false;
}

/// Aside · Aside Left + Right
abstract final class AsideAsideLeftRight {
  static const bool asideLeft = true;
  static const bool asideRight = true;
  static const bool hideWhenHasAsideLeft = false;
}
