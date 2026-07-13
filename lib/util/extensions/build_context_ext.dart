import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tray_serv/service.dart';

extension BuildContextExt on BuildContext {
  IPermissionServ get permissionServ => read<IPermissionServ>();
  TrayServ get trayServ => read<TrayServ>();
}
