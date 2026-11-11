import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'file_upload.props.dart';

Future<List<CFileUploadFile>> pickFiles({
  required bool multiple,
  required List<String> accept,
}) {
  final completer = Completer<List<CFileUploadFile>>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..multiple = multiple
    ..accept = accept.join(',')
    ..style.display = 'none';

  void finish(List<CFileUploadFile> files) {
    if (completer.isCompleted) return;
    completer.complete(files);
    input.remove();
  }

  input.addEventListener(
    'change',
    ((web.Event _) {
      final selected = <CFileUploadFile>[];
      final files = input.files;
      if (files != null) {
        for (var index = 0; index < files.length; index++) {
          final file = files.item(index);
          if (file == null) continue;
          selected.add(
            CFileUploadFile(
              id: '${DateTime.now().microsecondsSinceEpoch}-$index-${file.name}',
              name: file.name,
              sizeBytes: file.size,
              mimeType: file.type,
              source: file,
            ),
          );
        }
      }
      finish(selected);
    }).toJS,
  );
  input.addEventListener('cancel', ((web.Event _) => finish(const [])).toJS);
  web.document.body?.append(input);
  input.click();
  return completer.future;
}
