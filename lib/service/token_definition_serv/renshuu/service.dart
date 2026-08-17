import 'package:dio/dio.dart';
import 'package:jpnese2u/api/renshuu_api/api.dart';
import 'package:jpnese2u/api/renshuu_api/models/extension.dart';
import 'package:jpnese2u/service/token_definition_serv/interface.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';
import 'package:jpnese2u/service/tokenize_serv/sudachi/model.dart';
import 'package:jpnese2u/util/async_guard.dart';
import 'package:jpnese2u/util/extension/async_snapshot_ext.dart';

class RenshuuTokenDefinitionServ implements ITokenDefinitionServ<SudachiToken> {
  final RenshuuApi _api;

  const RenshuuTokenDefinitionServ({required this._api});

  @override
  Future<TokenDefinitionData?> getDefinitionForToken(
    SudachiToken token, {
    CancelToken? cancelToken,
  }) async {
    final snapshot = await asyncGuard(
      () => _api.wordSearch(
        value: token.dictionaryForm,
        pg: '1',
        cancelToken: cancelToken,
      ),
    );

    return snapshot.foldOrNull(
      onData: (result) => result.words?.firstOrNull?.toTokenDefinitionData(),
    );
  }
}
