import 'package:jpnese2u/models/capture_info.dart';

abstract class ICaptureService {
  Future<CaptureInfo?> capture() async {
    throw UnimplementedError('capture() has not been implemented.');
  }
}
