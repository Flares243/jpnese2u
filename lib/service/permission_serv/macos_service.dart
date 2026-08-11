import 'package:flutter_macos_permissions/flutter_macos_permissions.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:jpnese2u/service/permission_serv/constant.dart';
import 'package:jpnese2u/service/permission_serv/interface.dart';

class MacOSPermissionServ implements IPermissionServ {
  const MacOSPermissionServ();

  @override
  Future<PermissionStatus> checkScreenRecord() async {
    final resultString = await FlutterMacosPermissions.screenRecordingStatus();
    final result = MacOSPermissionStatus.fromString(resultString);
    return result.toPermissionStatus;
  }

  @override
  Future<PermissionStatus> requestScreenRecord() async {
    final status = await checkScreenRecord();
    if (status == PermissionStatus.granted) return status;

    await FlutterMacosPermissions.requestScreenRecording();
    return checkScreenRecord();
  }
}
