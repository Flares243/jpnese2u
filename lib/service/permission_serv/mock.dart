import 'package:permission_handler/permission_handler.dart';

import 'package:jpnese2u/service/permission_serv/interface.dart';

class MockPermissionServ implements IPermissionServ {
  @override
  Future<PermissionStatus> checkScreenRecord() async {
    return PermissionStatus.granted;
  }

  @override
  Future<PermissionStatus> requestScreenRecord() async {
    return PermissionStatus.granted;
  }
}
