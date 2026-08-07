import 'package:jpnese2u/services/local_config_serv/interface.dart';
import 'package:jpnese2u/util/async_guard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServ implements ILocalConfigServ {
  const SharedPrefServ(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> getString(String key) async {
    try {
      return _prefs.getString(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setString(String key, String value) async {
    final resultSnapshot = await asyncGuard(
      () async => _prefs.setString(key, value),
    );

    return resultSnapshot.data ?? false;
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      return _prefs.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removePair(String key) async {
    try {
      return _prefs.remove(key);
    } catch (e) {
      return false;
    }
  }
}
