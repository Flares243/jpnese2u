import 'package:jpnese2u/main.dart';
import 'package:jpnese2u/service/permission_serv/macos_service.dart';
import 'package:jpnese2u/service/permission_serv/winos_service.dart';
import 'package:jpnese2u/util/constant/constant.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class IPermissionServ {
  static IPermissionServ get getInstance => getIt<IPermissionServ>();

  factory IPermissionServ.platformInstance() {
    if (kIsMacOS) return const MacOSPermissionServ();
    if (kIsWindows) return const WinOSPermissionServ();
    throw UnimplementedError();
  }

  Future<PermissionStatus> checkScreenRecord();

  Future<PermissionStatus> requestScreenRecord();
}
