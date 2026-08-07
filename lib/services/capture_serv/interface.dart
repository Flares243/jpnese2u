import 'package:jpnese2u/main.dart';
import 'package:screen_capturer/screen_capturer.dart';

abstract class ICaptureService {
  static ICaptureService get getInstance => getIt<ICaptureService>();

  Future<CapturedData?> capture();
}
