import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'envs/.env')
abstract class SecureEnv {
  @EnviedField(varName: 'RENSHUU_READ_ONLY_API_KEY', obfuscate: true)
  static final String renshuuReadOnlyApiKey = _SecureEnv.renshuuReadOnlyApiKey;
}
