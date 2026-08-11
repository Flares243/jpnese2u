import 'package:jpnese2u/util/function/common.dart';
import 'package:screen_capturer/screen_capturer.dart';

import 'package:jpnese2u/service/capture_serv/interface.dart';
import 'package:jpnese2u/util/app_dirent.dart';
import 'package:jpnese2u/util/extension/list_ext.dart';

class CaptureServ implements ICaptureService {
  const CaptureServ({
    required this.appDirents,
  });

  final AppDirent appDirents;

  @override
  Future<CapturedData?> capture() async {
    final tempDirPath = appDirents.temporaryDir.path;

    final captureData = await screenCapturer.capture(
      copyToClipboard: false,
      imagePath: [tempDirPath, getUniqueString()].toPath,
    );

    return captureData;
  }
}
