import 'package:jpnese2u/api/renshuu_api/api.dart';
import 'package:jpnese2u/api/renshuu_api/models/extension.dart';
import 'package:jpnese2u/service/token_definition_serv/interface.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';
import 'package:jpnese2u/service/tokenize_serv/sudachi/model.dart';
import 'package:jpnese2u/util/async_guard.dart';

import 'package:jpnese2u/util/extension/async_snapshot_ext.dart';

class RenshuuServ implements ITokenDefinitionServ<SudachiToken> {
  final RenshuuApi _api;

  RenshuuServ({required this._api});

  @override
  Future<List<TokenDefinitionData>?> getTokenDefinition(
    SudachiToken token,
  ) async {
    final snapshot = await asyncGuard(
      () => _api.wordSearch(
        value: token.dictionaryForm,
        pg: '1',
      ),
    );

    return snapshot.foldOrNull(
      onData: (result) =>
          result.words?.map((e) => e.toTokenDefinitionData()).toList(),
    );
  }

  @override
  Future<void> dispose() => throw UnimplementedError();
}
