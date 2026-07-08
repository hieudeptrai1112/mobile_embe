import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> downloadFile({
  required String fileName,
  String? path,
  String? url,
}) async {
  final localPath = await _resolveLocalPath(
    fileName: fileName,
    path: path,
    url: url,
  );

  await Share.shareXFiles(
    [XFile(localPath, name: fileName)],
    subject: fileName,
  );
}

Future<String> _resolveLocalPath({
  required String fileName,
  String? path,
  String? url,
}) async {
  if (path != null && path.isNotEmpty) {
    final file = File(path);
    if (!await file.exists()) {
      throw StateError('Không tìm thấy file trên thiết bị.');
    }
    return path;
  }

  if (url != null && url.isNotEmpty) {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw StateError('Tải file thất bại (${response.statusCode}).');
    }

    final directory = await getApplicationCacheDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  throw StateError('File không có đường dẫn tải xuống.');
}
