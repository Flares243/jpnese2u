import 'dart:typed_data';

import 'package:platform_ocr/platform_ocr.dart';

import 'package:jpnese2u/services/ocr_serv/interface.dart';

class OCRService implements IOCRService {
  final ocr = PlatformOcr();

  @override
  Future<String?> textFromBytes(Uint8List bytes) async {
    final textFromBytes = await ocr.recognizeText(
      OcrSource.memory(bytes),
      options: const OcrOptions(
        recognitionLanguages: [OcrLanguage.japanese],
      ),
    );

    return textFromBytes.text;
  }
}
