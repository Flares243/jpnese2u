import 'dart:io';
import 'dart:typed_data';

import 'package:jpnese2u/util/extension/generic_ext.dart';
import 'package:jpnese2u/util/async_guard.dart';

class FileExplorerServ {
  Future<bool> isFileExists(String filePath) async {
    final file = File(filePath);

    return await file.exists();
  }

  Future<bool> saveFile(String filePath, Uint8List bytes) async {
    final result = await asyncGuard(
      () async {
        final file = File(filePath);

        await file.create(recursive: true);
        await file.writeAsBytes(bytes);

        return true;
      },
    );

    return result.connectionState == .done && result.data.onNull(false);
  }
}
