import 'package:jpnese2u/api/renshuu_api/api.dart';
import 'package:jpnese2u/api/renshuu_api/models/extension.dart';
import 'package:jpnese2u/service/token_definition_serv/interface.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:jpnese2u/util/async_guard.dart';
import 'package:jpnese2u/util/extension/async_snapshot_ext.dart';

class RenshuuTokenDefinitionServ implements ITokenDefinitionServ {
  final RenshuuApi api;

  const RenshuuTokenDefinitionServ({required this.api});

  @override
  Future<TokenDefinitionData?> getDefinitionForToken(
    CaptureTokenData token,
  ) async {
    final snapshot = await asyncGuard(
      () => api.wordSearch(value: token.surface, pg: '1'),
    );

    return snapshot.fold<TokenDefinitionData?>(
      onData: (result) => result.words?.firstOrNull?.toTokenDefinitionData(
        tokenId: token.id,
        surface: token.surface,
      ),
      orElse: () => null,
    );
  }
}
