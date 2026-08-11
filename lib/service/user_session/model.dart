import 'package:dart_mappable/dart_mappable.dart';

part 'model.mapper.dart';

@MappableClass()
class UserSession with UserSessionMappable {
  final String? renshuuApiKey;

  const UserSession({
    this.renshuuApiKey,
  });
}
