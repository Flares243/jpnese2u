import 'package:permission_handler/permission_handler.dart';

enum MacOSPermissionStatus {
  authorized,
  denied,
  restricted,
  notDetermined,
  ;

  static MacOSPermissionStatus fromString(String status) {
    return switch (status) {
      'authorized' => MacOSPermissionStatus.authorized,
      'denied' => MacOSPermissionStatus.denied,
      'restricted' => MacOSPermissionStatus.restricted,
      'notDetermined' => MacOSPermissionStatus.notDetermined,
      _ => throw Exception('Unknown MacOSPermissionStatus: $status'),
    };
  }

  PermissionStatus? get toPermissionStatus => switch (this) {
    MacOSPermissionStatus.authorized => PermissionStatus.granted,
    MacOSPermissionStatus.denied => PermissionStatus.denied,
    MacOSPermissionStatus.restricted => PermissionStatus.restricted,
    MacOSPermissionStatus.notDetermined => null,
  };
}
