import 'package:jpnese2u/util/functions.dart';
import 'package:screen_capturer/screen_capturer.dart';

import 'package:jpnese2u/services/capture_serv/interface.dart';
import 'package:jpnese2u/util/app_directories.dart';
import 'package:jpnese2u/util/extensions/list_ext.dart';

class CaptureServ implements ICaptureService {
  const CaptureServ({
    required this.appDirectories,
  });

  final AppDirectories appDirectories;

  @override
  Future<CapturedData?> capture() async {
    final tempDirPath = appDirectories.temporaryDirectory.path;

    final captureData = await screenCapturer.capture(
      copyToClipboard: false,
      imagePath: [tempDirPath, getUniqueString()].toPath,
    );

    return captureData;
  }
}
