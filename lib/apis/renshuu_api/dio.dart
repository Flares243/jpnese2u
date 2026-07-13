import 'package:dio/dio.dart';

import 'package:jpnese2u/apis/constant.dart';
import 'package:jpnese2u/config/env.dart';

Dio renshuuApiDio() {
  final dio = Dio();

  dio.options.baseUrl = 'https://api.renshuu.org/v1/';
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers[HeaderKeys.authorization.key] =
            'Bearer ${SecureEnv.renshuuReadOnlyApiKey}';

        return handler.next(options);
      },
    ),
  );

  return dio;
}
