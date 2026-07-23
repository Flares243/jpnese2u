import 'package:permission_handler/permission_handler.dart';

import 'package:jpnese2u/services/permission_serv/macos_service.dart';
import 'package:jpnese2u/services/permission_serv/winos_service.dart';
import 'package:jpnese2u/util/constant/constant.dart';

abstract class IPermissionServ {
  factory IPermissionServ() {
    if (kIsMacOS) {
      return MacOSPermissionServ();
    }

    if (kIsWindows) {
      return WinOSPermissionServ();
    }

    throw UnimplementedError();
  }

  Future<PermissionStatus?> checkScreenRecord() {
    throw UnimplementedError('checkScreenRecord() has not been implemented.');
  }

  Future<PermissionStatus?> requestScreenRecord() {
    throw UnimplementedError('requestScreenRecord() has not been implemented.');
  }
}
