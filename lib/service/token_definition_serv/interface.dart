import 'package:dio/dio.dart';
import 'package:jpnese2u/main.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';
import 'package:jpnese2u/service/tokenize_serv/model.dart';

abstract class ITokenDefinitionServ<T extends RawToken> {
  static ITokenDefinitionServ get getInstance => getIt<ITokenDefinitionServ>();

  Future<TokenDefinitionData?> getDefinitionForToken(
    T token, {
    CancelToken? cancelToken,
  });
}
