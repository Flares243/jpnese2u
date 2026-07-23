import 'package:screen_capturer/screen_capturer.dart';

abstract class ICaptureService {
  Future<CapturedData?> capture() async {
    throw UnimplementedError('capture() has not been implemented.');
  }
}
