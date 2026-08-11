import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:jpnese2u/repository/shared_pref_repo/interface.dart';

class SecureSharedPrefRepo implements ISharedPrefRepo {
  const SecureSharedPrefRepo({required this.storage});

  final FlutterSecureStorage storage;

  @override
  Future<String?> getString(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> remove(String key) async {
    await storage.delete(key: key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  @override
  Future<void> clearAll() async {
    await storage.deleteAll();
  }
}
