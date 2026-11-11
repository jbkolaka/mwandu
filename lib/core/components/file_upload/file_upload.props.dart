import 'package:flutter/widgets.dart';

/// A file selected in [CFileUpload].
class CFileUploadFile {
  const CFileUploadFile({
    required this.id,
    required this.name,
    required this.sizeBytes,
    this.mimeType = '',
    this.source,
  });

  /// Stable identifier used to remove the selected file.
  final String id;

  /// Display name of the file.
  final String name;

  /// File size in bytes.
  final int sizeBytes;

  /// Browser-reported MIME type, when available.
  final String mimeType;

  /// Platform file handle. On Flutter web this is the selected `web.File`.
  final Object? source;
}

/// Configuration for [CFileUpload].
class CFileUploadProps {
  const CFileUploadProps({
    this.title = 'Upload files',
    this.description = 'Select files from your device to add them here.',
    this.buttonLabel = 'Choose files',
    this.multiple = true,
    this.accept = const <String>[],
    this.maxFileSizeBytes,
    this.initialFiles = const <CFileUploadFile>[],
    this.disabled = false,
    this.onBrowse,
    this.onFilesChanged,
    this.onFileRejected,
  });

  /// Heading shown above the picker control.
  final String title;

  /// Supporting text shown below the heading.
  final String description;

  /// Label for the file picker button.
  final String buttonLabel;

  /// Whether users may select more than one file per browse action.
  final bool multiple;

  /// Accepted extensions or MIME types, such as `.pdf` or `image/*`.
  final List<String> accept;

  /// Optional maximum file size in bytes.
  final int? maxFileSizeBytes;

  /// Files to show when the widget is first built.
  final List<CFileUploadFile> initialFiles;

  /// Disables browsing and file removal.
  final bool disabled;

  /// Optional picker override for non-web platforms or custom pickers.
  final Future<List<CFileUploadFile>> Function()? onBrowse;

  /// Called when the selected file list changes.
  final ValueChanged<List<CFileUploadFile>>? onFilesChanged;

  /// Called when a selected file fails local validation.
  final ValueChanged<String>? onFileRejected;
}
