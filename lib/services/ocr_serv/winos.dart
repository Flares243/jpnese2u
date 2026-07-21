import 'dart:typed_data';

import 'package:jpnese2u/util/functions.dart';
import 'package:platform_ocr/platform_ocr.dart';

import 'package:jpnese2u/services/ocr_serv/interface.dart';

class WinOSOCRService implements IOCRService {
  final ocr = PlatformOcr();

  @override
  Future<String?> textFromBytes(Uint8List bytes) async {
    final textFromBytes = await ocr.recognizeText(
      OcrSource.memory(bytes),
      options: const OcrOptions(
        recognitionLanguages: [OcrLanguage.japanese],
      ),
    );

    var text = textFromBytes.lines
        .map((e) => e.text)
        .join('\n')
        .replaceAll(' ', '');
    text = normalizeJapanesePunctuation(text);

    return text;
  }
}
