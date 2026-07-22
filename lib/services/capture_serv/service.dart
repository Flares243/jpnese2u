import 'package:screen_capturer/screen_capturer.dart';

import 'package:jpnese2u/models/capture_info.dart';
import 'package:jpnese2u/services/capture_serv/interface.dart';
import 'package:jpnese2u/services/ocr_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:jpnese2u/util/app_directories.dart';
import 'package:jpnese2u/util/constant/constant.dart';
import 'package:jpnese2u/util/extensions/list_ext.dart';

class CaptureServ implements ICaptureService {
  const CaptureServ({
    required this.ocrServ,
    required this.tokenizeServ,
    required this.appDirectories,
  });

  final IOCRService ocrServ;
  final ITokenizeService tokenizeServ;
  final AppDirectories appDirectories;

  @override
  Future<CaptureInfo?> capture() async {
    final tempDirPath = appDirectories.temporaryDirectory.path;

    final captureData = await screenCapturer.capture(
      copyToClipboard: false,
      imagePath: [tempDirPath, kTempScreenshotFileName].toPath,
    );

    if (captureData == null) return null;

    String? text;
    List<RawToken> tokens = [];

    final imageBytes = captureData.imageBytes;

    if (imageBytes != null) {
      text = await ocrServ.textFromBytes(imageBytes);
    }

    if (text != null) {
      tokens = await tokenizeServ.tokenize(text);
      if (tokens.isNotEmpty) tokens.removeLast();
    }

    return CaptureInfo(data: captureData, text: text, tokens: tokens);
  }
}
