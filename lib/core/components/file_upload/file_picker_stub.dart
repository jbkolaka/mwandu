import 'file_upload.props.dart';

Future<List<CFileUploadFile>> pickFiles({
  required bool multiple,
  required List<String> accept,
}) {
  throw UnsupportedError(
    'Provide CFileUploadProps.onBrowse to use a native file picker.',
  );
}
