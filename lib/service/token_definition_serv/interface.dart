import 'package:jpnese2u/main.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';

abstract class ITokenDefinitionServ {
  static ITokenDefinitionServ get getInstance => getIt<ITokenDefinitionServ>();

  Future<TokenDefinitionData?> getDefinitionForToken(CaptureTokenData token);
}
