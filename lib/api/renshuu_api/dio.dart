import 'package:dio/dio.dart';

import 'package:jpnese2u/api/constant.dart';

class RenshuuDio extends DioMixin implements Dio {
  RenshuuDio({required String renshuuApiKey}) {
    options = BaseOptions().copyWith(
      baseUrl: 'https://api.renshuu.org/v1/',
      headers: {
        HeaderKeys.authorization.key: 'Bearer $renshuuApiKey',
      },
    );

    httpClientAdapter = HttpClientAdapter();
  }
}
