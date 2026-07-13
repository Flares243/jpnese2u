import 'dart:async';
import 'dart:typed_data';

abstract class IOCRService {
  FutureOr<String?> textFromBytes(Uint8List bytes) {
    throw UnimplementedError('textFromByte is not implemented');
  }
}
