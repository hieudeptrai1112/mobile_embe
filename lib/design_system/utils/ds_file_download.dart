import 'ds_file_download_stub.dart'
    if (dart.library.io) 'ds_file_download_io.dart' as impl;

/// Downloads or shares a file from a local [path] or remote [url].
abstract final class DsFileDownload {
  static Future<void> download({
    required String fileName,
    String? path,
    String? url,
  }) {
    return impl.downloadFile(
      fileName: fileName,
      path: path,
      url: url,
    );
  }
}
