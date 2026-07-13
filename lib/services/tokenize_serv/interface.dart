import 'dart:async';

import 'package:kuromoji/kuromoji.dart';

abstract class ITokenizeService {
  FutureOr<List<UnknownToken>> tokenize(String text) {
    throw UnimplementedError('tokenize is not implemented');
  }
}
