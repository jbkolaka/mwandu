import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme, Radius;

import 'file_picker_stub.dart'
    if (dart.library.js_interop) 'file_picker_web.dart' as picker;
import 'file_upload.props.dart';
import 'file_upload.styles.dart';

/// Carbon-inspired file picker with single- or multi-file selection.
///
/// File selection is handled locally. Use [CFileUploadProps.onFilesChanged] to
/// connect selected files to an application-specific upload service.
class CFileUpload extends StatefulWidget {
  const CFileUpload({super.key, required this.props});

  final CFileUploadProps props;

  @override
  State<CFileUpload> createState() => _CFileUploadState();
}

class _CFileUploadState extends State<CFileUpload> {
  late List<CFileUploadFile> _files;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _files = List<CFileUploadFile>.of(widget.props.initialFiles);
  }

  @override
  void didUpdateWidget(covariant CFileUpload oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.initialFiles != oldWidget.props.initialFiles) {
      _files = List<CFileUploadFile>.of(widget.props.initialFiles);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.props.title,
          style: TextStyle(
            color: CFileUploadStyles.text(tokens),
            fontSize: CFileUploadStyles.titleFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: CFileUploadStyles.sectionGap),
        Text(
          widget.props.description,
          style: TextStyle(
            color: CFileUploadStyles.secondaryText(tokens),
            fontSize: CFileUploadStyles.bodyFontSize,
          ),
        ),
        const SizedBox(height: CFileUploadStyles.outerPadding),
        Container(
          padding: const EdgeInsets.all(CFileUploadStyles.outerPadding),
          decoration: BoxDecoration(
            color: CFileUploadStyles.background(tokens),
            border: Border.all(
              color: CFileUploadStyles.border(tokens),
              width: CFileUploadStyles.borderWidth,
            ),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: CFileUploadStyles.outerPadding,
            runSpacing: CFileUploadStyles.sectionGap,
            children: [
              Icon(
                Icons.upload_file,
                size: CFileUploadStyles.iconSize,
                color: CFileUploadStyles.icon(tokens),
              ),
              Text(
                widget.props.multiple
                    ? 'Choose one or more files'
                    : 'Choose a file',
                style: TextStyle(
                  color: CFileUploadStyles.text(tokens),
                  fontSize: CFileUploadStyles.bodyFontSize,
                ),
              ),
              TextButton.icon(
                onPressed: widget.props.disabled ? null : _browse,
                icon: const Icon(Icons.attach_file),
                label: Text(widget.props.buttonLabel),
                style: TextButton.styleFrom(
                  backgroundColor: tokens.buttonPrimary,
                  foregroundColor: tokens.textOnColor,
                ),
              ),
            ],
          ),
        ),
        if (widget.props.accept.isNotEmpty ||
            widget.props.maxFileSizeBytes != null) ...[
          const SizedBox(height: CFileUploadStyles.sectionGap),
          Text(
            _constraintDescription,
            style: TextStyle(
              color: CFileUploadStyles.secondaryText(tokens),
              fontSize: CFileUploadStyles.captionFontSize,
            ),
          ),
        ],
        if (_errorMessage != null) ...[
          const SizedBox(height: CFileUploadStyles.sectionGap),
          Semantics(
            liveRegion: true,
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: CFileUploadStyles.error(tokens),
                fontSize: CFileUploadStyles.bodyFontSize,
              ),
            ),
          ),
        ],
        if (_files.isNotEmpty) ...[
          const SizedBox(height: CFileUploadStyles.outerPadding),
          for (var index = 0; index < _files.length; index++)
            _buildFileRow(context, tokens, _files[index], index),
        ],
      ],
    );
  }

  Widget _buildFileRow(
    BuildContext context,
    AppThemeTokens tokens,
    CFileUploadFile file,
    int index,
  ) {
    return Container(
      constraints: const BoxConstraints(minHeight: CFileUploadStyles.fileRowHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: CFileUploadStyles.outerPadding,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: CFileUploadStyles.border(tokens)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            size: CFileUploadStyles.iconSize,
            color: CFileUploadStyles.icon(tokens),
          ),
          const SizedBox(width: CFileUploadStyles.sectionGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CFileUploadStyles.text(tokens),
                    fontSize: CFileUploadStyles.bodyFontSize,
                  ),
                ),
                Text(
                  _formatSize(file.sizeBytes),
                  style: TextStyle(
                    color: CFileUploadStyles.secondaryText(tokens),
                    fontSize: CFileUploadStyles.captionFontSize,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove ${file.name}',
            onPressed: widget.props.disabled ? null : () => _removeFile(index),
            icon: const Icon(Icons.close),
            color: CFileUploadStyles.icon(tokens),
          ),
        ],
      ),
    );
  }

  String get _constraintDescription {
    final details = <String>[];
    if (widget.props.accept.isNotEmpty) {
      details.add('Accepted: ${widget.props.accept.join(', ')}');
    }
    if (widget.props.maxFileSizeBytes case final maxSize?) {
      details.add('Maximum size: ${_formatSize(maxSize)}');
    }
    return details.join(' · ');
  }

  Future<void> _browse() async {
    setState(() => _errorMessage = null);
    try {
      final selected = await (widget.props.onBrowse?.call() ??
          picker.pickFiles(
            multiple: widget.props.multiple,
            accept: widget.props.accept,
          ));
      _addFiles(selected);
    } on UnsupportedError catch (error) {
      if (mounted) {
        setState(
          () => _errorMessage = error.message?.toString() ??
              'A file picker is not available on this platform.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Files could not be selected. Try again.');
      }
    }
  }

  void _addFiles(List<CFileUploadFile> selected) {
    if (!mounted || selected.isEmpty) return;
    final accepted = <CFileUploadFile>[];
    final rejected = <String>[];
    for (final file in selected) {
      final reason = _rejectionReason(file);
      if (reason == null) {
        accepted.add(file);
      } else {
        rejected.add('${file.name}: $reason');
        widget.props.onFileRejected?.call('${file.name}: $reason');
      }
    }
    setState(() {
      _errorMessage = rejected.isEmpty ? null : rejected.join('\n');
      if (accepted.isNotEmpty) {
        _files = widget.props.multiple
            ? [..._files, ...accepted]
            : [accepted.first];
      }
    });
    if (accepted.isNotEmpty) {
      widget.props.onFilesChanged?.call(List<CFileUploadFile>.unmodifiable(_files));
    }
  }

  String? _rejectionReason(CFileUploadFile file) {
    final maxSize = widget.props.maxFileSizeBytes;
    if (maxSize != null && file.sizeBytes > maxSize) {
      return 'exceeds the ${_formatSize(maxSize)} size limit';
    }
    if (widget.props.accept.isNotEmpty && !_matchesAccept(file)) {
      return 'file type is not accepted';
    }
    return null;
  }

  bool _matchesAccept(CFileUploadFile file) {
    final name = file.name.toLowerCase();
    final type = file.mimeType.toLowerCase();
    return widget.props.accept.any((rule) {
      final normalized = rule.trim().toLowerCase();
      if (normalized.startsWith('.')) return name.endsWith(normalized);
      if (normalized.endsWith('/*')) {
        return type.startsWith(normalized.substring(0, normalized.length - 1));
      }
      return type == normalized;
    });
  }

  void _removeFile(int index) {
    final next = List<CFileUploadFile>.of(_files)..removeAt(index);
    setState(() {
      _files = next;
      _errorMessage = null;
    });
    widget.props.onFilesChanged?.call(List<CFileUploadFile>.unmodifiable(next));
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
