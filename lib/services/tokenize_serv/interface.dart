import 'dart:async';

import 'package:jpnese2u/services/tokenize_serv/constant.dart';
import 'package:jpnese2u/services/tokenize_serv/model.dart';

abstract class ITokenizeService {
  Future<void> init(DictionaryType dictType) async {
    throw UnimplementedError('init is not implemented');
  }

  FutureOr<List<RawToken>> tokenize(String text) {
    throw UnimplementedError('tokenize is not implemented');
  }
}
