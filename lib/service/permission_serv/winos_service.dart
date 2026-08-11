import 'package:permission_handler/permission_handler.dart';

import 'package:jpnese2u/service/permission_serv/interface.dart';

class WinOSPermissionServ implements IPermissionServ {
  const WinOSPermissionServ();

  @override
  Future<PermissionStatus> checkScreenRecord() async {
    return PermissionStatus.granted;
  }

  @override
  Future<PermissionStatus> requestScreenRecord() async {
    return PermissionStatus.granted;
  }
}
