import 'dart:async';
import 'dart:typed_data';

import 'package:jpnese2u/main.dart';
import 'package:jpnese2u/services/ocr_serv/macos.dart';
import 'package:jpnese2u/services/ocr_serv/winos.dart';
import 'package:jpnese2u/util/constant/constant.dart';

abstract class IOCRService {
  static IOCRService get getInstance => getIt<IOCRService>();

  factory IOCRService.platformInstance() {
    if (kIsMacOS) return MacOSOCRService();
    if (kIsWindows) return WinOSOCRService();
    throw UnimplementedError();
  }

  FutureOr<String?> textFromBytes(Uint8List bytes);
}
