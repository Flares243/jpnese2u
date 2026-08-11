import 'package:jpnese2u/api/renshuu_api/api.dart';
import 'package:jpnese2u/api/renshuu_api/dio.dart';
import 'package:jpnese2u/util/async_guard.dart';

Future<bool> validateRenshuuApiKey(String key) async {
  final snapshot = await asyncGuard(
    () async {
      final renshuuApi = RenshuuApi(RenshuuDio(renshuuApiKey: key));
      await renshuuApi.getProfile();
      return true;
    },
  );

  return snapshot.hasData;
}
