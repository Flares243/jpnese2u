import 'package:flutter/material.dart';
import 'package:jpnese2u/main.dart';
import 'package:jpnese2u/repository/shared_pref_repo/secure_storage.dart';
import 'package:jpnese2u/service/user_session/model.dart';
import 'package:jpnese2u/util/constant/local_config_key.dart';
import 'package:jpnese2u/util/constant/type.dart';

class UserSessionService extends ChangeNotifier {
  static UserSessionService get getInstance => getIt<UserSessionService>();

  final SecureSharedPrefRepo secureSharedPrefRepo;

  UserSession _userSession = const UserSession();
  UserSession get userSession => _userSession;

  UserSessionService({
    required this.secureSharedPrefRepo,
  });

  Future<void> init() async {
    final renshuuApiKey = await secureSharedPrefRepo.getString(
      LocalConfigKey.renshuuApiKey,
    );

    _userSession = UserSession(renshuuApiKey: renshuuApiKey);
    notifyListeners();
  }

  Future<void> saveRenshuuApiKey(String key) async {
    await secureSharedPrefRepo.setString(LocalConfigKey.renshuuApiKey, key);
    _userSession = _userSession.copyWith(renshuuApiKey: key);
    notifyListeners();
  }

  void setState(SetStateCallback<UserSession> callback) {
    _userSession = callback(_userSession);
    notifyListeners();
  }
}
