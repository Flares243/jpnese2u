import 'dart:async';

import 'package:jpnese2u/main.dart';
import 'package:jpnese2u/services/tokenize_serv/model.dart';

abstract class ITokenizeServ {
  static ITokenizeServ get getInstance => getIt<ITokenizeServ>();

  bool get isAvailable;

  Future<bool> init();

  Future<List<RawToken>> tokenize(String text);

  Future<void> dispose();
}
