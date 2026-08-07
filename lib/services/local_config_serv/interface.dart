import 'dart:async';

abstract class ILocalConfigServ {
  Future<bool> setString(String key, String value);

  Future<String?> getString(String key);

  Future<bool> containsKey(String key);

  Future<bool> removePair(String key);
}
