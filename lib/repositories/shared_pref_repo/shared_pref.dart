import 'package:shared_preferences/shared_preferences.dart';

import 'package:jpnese2u/repositories/shared_pref_repo/interface.dart';

class SharedPrefRepo implements ISharedPrefRepo {
  const SharedPrefRepo(this._sharedPref);

  final SharedPreferences _sharedPref;

  @override
  Future<String?> getString(String key) async {
    return _sharedPref.getString(key);
  }

  @override
  Future<void> remove(String key) async {
    await _sharedPref.remove(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _sharedPref.setString(key, value);
  }

  @override
  Future<void> clearAll() async {
    await _sharedPref.clear();
  }
}
