import 'package:permission_handler/permission_handler.dart';

abstract class IPermissionServ {
  Future<PermissionStatus?> checkScreenRecord() {
    throw UnimplementedError('checkScreenRecord() has not been implemented.');
  }

  Future<PermissionStatus?> requestScreenRecord() {
    throw UnimplementedError('requestScreenRecord() has not been implemented.');
  }
}
